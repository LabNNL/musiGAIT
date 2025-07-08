from pythonosc.osc_server import BlockingOSCUDPServer
from pythonosc.udp_client import SimpleUDPClient
from pythonosc.dispatcher import Dispatcher
from enum import Enum
import threading
import argparse
import logging
import struct
import socket
import json
import time

# Protocol Version
VERSION = 1

# OSC send to MaxMSP
OSC_IP, OSC_PORT = "127.0.0.1", 8000
osc_client = SimpleUDPClient(OSC_IP, OSC_PORT)
osc_lock = threading.Lock()

# EMG to Delsys server
EMG_HOST = "127.0.0.1"

CURRENT_SENSORS = []
SOCKETS = []

# OSC to change analyzer configuration
ANALYZER_IP, ANALYZER_PORT = "127.0.0.1", 8001

# Data multiplier
DATA_MULTIPLIER = 10000

# Analyzer configuration
ANALYZER_LEFT_CHANNEL = -1
ANALYZER_LEFT_THRESHOLD = 5

ANALYZER_RIGHT_CHANNEL = -1
ANALYZER_RIGHT_THRESHOLD = 5

ANALYZER_LEARNING_RATE = 0.8

ANALYZER_DEVICE = "DelsysEmgDataCollector"
ANALYZER_REFERENCE = "DelsysEmgDataCollector"

analyzer_config_left = {
	"name": "foot_cycle_left",
	"analyzer_type": "cyclic_timed_events",
	"time_reference_device": ANALYZER_REFERENCE,
	"learning_rate": ANALYZER_LEARNING_RATE,
	"initial_phase_durations": [400, 600],
	"events": [
		{
			"name": "heel_strike",
			"previous": "toe_off",
			"start_when": [
				{
					"type": "threshold",
					"device": ANALYZER_DEVICE,
					"channel": ANALYZER_LEFT_CHANNEL - 1,
					"comparator": ">=",
					"value": ANALYZER_LEFT_THRESHOLD
				}
			]
		},
		{
			"name": "toe_off",
			"previous": "heel_strike",
			"start_when": [
				{
					"type": "threshold",
					"device": ANALYZER_DEVICE,
					"channel": ANALYZER_LEFT_CHANNEL - 1,
					"comparator": "<",
					"value": ANALYZER_LEFT_THRESHOLD
				}
			]
		}
	]
}

analyzer_config_right = {
	"name": "foot_cycle_right",
	"analyzer_type": analyzer_config_left["analyzer_type"],
	"time_reference_device": ANALYZER_REFERENCE,
	"learning_rate": ANALYZER_LEARNING_RATE,
	"initial_phase_durations": analyzer_config_left["initial_phase_durations"],
	"events": [
		{
			"name": "heel_strike",
			"previous": "toe_off",
			"start_when": [
				{
					"type": "threshold",
					"device": ANALYZER_DEVICE,
					"channel": ANALYZER_RIGHT_CHANNEL-1,
					"comparator": ">=",
					"value": ANALYZER_RIGHT_THRESHOLD
				}
			]
		},
		{
			"name": "toe_off",
			"previous": "heel_strike",
			"start_when": [
				{
					"type": "threshold",
					"device": ANALYZER_DEVICE,
					"channel": ANALYZER_RIGHT_CHANNEL-1,
					"comparator": "<",
					"value": ANALYZER_RIGHT_THRESHOLD
				}
			]
		}
	]
}

logging.basicConfig(
	level=logging.INFO, 
	format='[%(asctime)s.%(msecs)03d] [%(levelname)s] %(message)s', 
	datefmt='%Y-%m-%d %H:%M:%S'
)
log = logging.getLogger(__name__)


# Commands
class Command(Enum):
	HANDSHAKE = 0
	CONNECT_DELSYS_ANALOG = 10
	CONNECT_DELSYS_EMG = 11
	CONNECT_MAGSTIM = 12
	ZERO_DELSYS_ANALOG = 40
	ZERO_DELSYS_EMG = 41
	DISCONNECT_DELSYS_ANALOG = 20
	DISCONNECT_DELSYS_EMG = 21
	DISCONNECT_MAGSTIM = 22
	START_RECORDING = 30
	STOP_RECORDING = 31
	GET_LAST_TRIAL_DATA = 32
	ADD_ANALYZER = 50
	REMOVE_ANALYZER = 51
	FAILED = 100


def to_packet(command_int: int) -> bytes:
	"""
	Create an 8-byte packet: 4 bytes for version + 4 bytes for command.

	Returns:
		bytes: Packed 8-byte packet (little-endian).
	"""
	return struct.pack("<II", VERSION, command_int)


def interpret_response(response: bytes) -> dict:
	"""
	Interpret a 16-byte response from the server.

	Expected response structure:
	- 4 bytes: Protocol version (little-endian, should be == VERSION)
	- 8 bytes: Timestamp (little-endian, milliseconds since UNIX epoch)
	- 4 bytes: Response code (little-endian, NOK = 0, OK = 1)

	Returns:
		dict: Parsed response with protocol version, timestamp, human-readable time, and status.
	"""

	if not response or len(response) != 16:
		return {
			"error": "Invalid response length",
			"raw_data": response.hex() if response else None
		}

	# Unpack response (little-endian format)
	protocol_version, timestamp, status = struct.unpack('<I Q I', response)

	# Check protocol version
	if protocol_version != VERSION:
		return {
			"error": f"Invalid protocol version: {protocol_version}",
			"raw_data": response.hex() if response else None
		}

	# Convert timestamp to human-readable format
	timestamp_seconds = timestamp / 1000.0
	human_readable_time = time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(timestamp_seconds))

	return {
		"protocol_version": protocol_version,
		"timestamp": timestamp,
		"human_time": human_readable_time,
		"status": status,
	}


def recv_exact(sock: socket.socket, n: int) -> bytes:
	"""Read exactly n bytes or raise if the socket closes early."""
	buf = b""
	while len(buf) < n:
		chunk = sock.recv(n - len(buf))
		if not chunk:
			raise ConnectionError("Socket closed unexpectedly while reading")
		buf += chunk
	return buf


def send_command(sock, command: Command) -> bool:
	"""
	Send a command to the server using the required protocol format.

	The command is structured as:
	- 4 bytes (little-endian) for protocol version
	- 4 bytes (little-endian) for the command

	Returns:
		bool: True if the command was successful, False otherwise.
	"""
	if not isinstance(command, Command):
		log.error(f"Invalid command {command}")
		return False

	# Pack command as 8 bytes (4-byte version + 4-byte command)
	command_packet = to_packet(command.value)

	try:
		# Send the command
		sock.sendall(command_packet)
		log.info(f"Sent command: {command.name} ({command.value})")

		# Read the full 16-byte response
		response = recv_exact(sock, 16)
		parsed_response = interpret_response(response)

		# Handle interpretation errors
		if "error" in parsed_response:
			log.error(f"Response interpretation error: {parsed_response['error']}")
			return False

		# Check if response is OK (1) or NOK (0)
		if parsed_response["status"] != 1:
			log.error(f"Command {command.name} failed")
			return False

		return True

	except socket.error as e:
		log.error(f"Socket error: {e}")
		return False


def send_extra_data(sock, response_sock, extra_data: dict) -> bool:
	"""
	Sends extra data in the correct format.

	Format:
	- 4 bytes: Protocol version (little-endian, should be == VERSION)
	- 4 bytes: Length of the JSON string (little-endian)
	- Remaining bytes: The JSON string itself

	Returns:
		bool: True if extra data was sent successfully, False otherwise.
	"""

	try:
		# Serialize extra data as JSON
		json_data = json.dumps(extra_data).encode('utf-8')
		data_length = len(json_data)

		# Create the header (VERSION, DATA SIZE)
		header = struct.pack('<II', VERSION, data_length)

		# Send the header and JSON data
		sock.sendall(header + json_data)

		# Wait for the response
		response = recv_exact(response_sock, 16)
		parsed_response = interpret_response(response)

		if "error" in parsed_response:
			log.error(f"Error in extra data response: {parsed_response['error']}")
			return False

		if parsed_response["status"] != 1:
			log.error(f"Extra data failed (NOK received)")
			return False

		log.info(f"Extra data sent successfully")
		return True

	except socket.error as e:
		log.error(f"Socket error while sending extra data: {e}")
		return False


def connect_and_handshake(host: str, ports: list[int]) -> list[socket.socket] | bool:
	"""
	Connects to all ports and performs a handshake.

	Returns:
		list: List of connected sockets if successful, otherwise False.
	"""
	sockets = []

	# Attempt to connect to all ports
	for port in ports:
		try:
			sock = socket.create_connection((host, port))
			sockets.append(sock)
			log.info(f"Connected to {host}:{port}")

		except Exception as e:
			log.error(f"Error connecting to {host}:{port}: {e}")
			for s in sockets:
				s.close()
			return False

	# Perform handshake on the first socket
	if len(sockets) == len(ports):
		handshake_message = to_packet(Command.HANDSHAKE.value)
		sockets[0].sendall(handshake_message)

		response = sockets[0].recv(16)
		parsed_response = interpret_response(response)

		if "error" in parsed_response:
			log.error(f"Handshake error: {parsed_response['error']}")
			return False

	log.info("Handshake successful")
	return sockets


def parse_data_length(data: bytes) -> int:
	"""Extract expected data length from header bytes 12-15."""
	return struct.unpack('<I', data[12:16])[0]


def send_osc_message(address: str, value: float) -> None:
	"""Thread-safe function to send OSC messages."""
	with osc_lock:
		osc_client.send_message(address, value)


def listen_to_live_data(sock: socket.socket) -> None:
	"""Listen for live data packets and send them via OSC."""
	sent_timestamps = set()
	log.info(f"Sending live data via OSC on {OSC_IP}:{OSC_PORT}")

	try:
		while True:
			header = recv_exact(sock, 16)
			body_length = parse_data_length(header)
			body = recv_exact(sock, body_length)

			try:
				decoded = json.loads(body.decode('utf-8'))
				for key, payload in decoded.items():
					for entry in payload['data']['data']:
						timestamp, channels = entry[0], entry[1]
						if timestamp in sent_timestamps:
							continue
						sent_timestamps.add(timestamp)
						for ch in CURRENT_SENSORS:
							if 1 <= ch <= len(channels):
								send_osc_message(f'/sensor_{ch}', channels[ch-1] * DATA_MULTIPLIER)

			except json.JSONDecodeError:
				log.error("JSON decode error; skipping this packet.")

	except (ConnectionError, socket.error) as e:
		log.error(f"Live-data socket closed: {e}")

	finally:
		sock.close()
		log.info("Live data connection closed")


def listen_to_live_analyses(sock: socket) -> None:
	"""Listen for live analyses packets and send them via OSC."""
	buffer = bytearray()
	expected_length = None

	log.info(f"Sending live analyses via OSC on {OSC_IP}:{OSC_PORT}")

	try:
		while True:
			header = recv_exact(sock, 16)
			body_length = parse_data_length(header)
			body = recv_exact(sock, body_length)
			
			try:
				decoded = json.loads(body.decode('utf-8'))
				if "data" in decoded:
					for key, analysis in decoded["data"].items():
						# make OSC address safe
						addr = f'/{key.replace(" ", "_")}'
						# if analysis[1] is a list of values, send each separately:
						if (
							isinstance(analysis, list)
							and len(analysis) >= 2
							and isinstance(analysis[1], list)
						):
							for value in analysis[1]:
								send_osc_message(addr, value)
						else:
							log.error(f"Unexpected format in '{key}' data")
			except json.JSONDecodeError:
				log.error("JSON decode error in live analyses; skipping this packet")

	except (ConnectionError, socket.error) as e:
		log.info(f"Live-analyses socket closed: {e}")
	finally:
		sock.close()
		log.info("Live analysis connection closed")


def analyzer_update_channels(address: str, *args) -> None:
	"""Handles incoming OSC messages to update ANALYZER_CHANNEL."""
	global ANALYZER_LEFT_CHANNEL, ANALYZER_RIGHT_CHANNEL

	try:
		with osc_lock:
			if len(args) == 1:
				ANALYZER_LEFT_CHANNEL = int(args[0])
				ANALYZER_RIGHT_CHANNEL = -1
				log.info(f"Updated ANALYZER_LEFT_CHANNEL: {ANALYZER_LEFT_CHANNEL}")
			
			elif len(args) >= 2:
				ANALYZER_LEFT_CHANNEL = int(args[0])
				ANALYZER_RIGHT_CHANNEL = int(args[1])
				log.info(f"Updated ANALYZER_CHANNELS: {ANALYZER_LEFT_CHANNEL}, {ANALYZER_RIGHT_CHANNEL}")
			
			else:
				raise IndexError("No channel data provided.")

		send_analyzer_config()

	except (ValueError, IndexError) as e:
		log.error(f"Error updating ANALYZER_CHANNEL: {e}")


def analyzer_update_thresholds(address: str, *args) -> None:
	"""Handles incoming OSC messages to update ANALYZER_THRESHOLD."""
	global ANALYZER_LEFT_THRESHOLD, ANALYZER_RIGHT_THRESHOLD

	try:
		with osc_lock:
			if len(args) == 1:
				ANALYZER_LEFT_THRESHOLD = float(args[0])
				log.info(f"Updated ANALYZER_LEFT_THRESHOLD: {ANALYZER_LEFT_THRESHOLD}")
			
			elif len(args) >= 2:
				ANALYZER_LEFT_THRESHOLD = float(args[0])
				ANALYZER_RIGHT_THRESHOLD = float(args[1])
				log.info(f"Updated ANALYZER_THRESHOLDS: {ANALYZER_LEFT_THRESHOLD}, {ANALYZER_RIGHT_THRESHOLD}")
			
			else:
				raise IndexError("No threshold data provided.")

		send_analyzer_config()

	except (ValueError, IndexError) as e:
		log.error(f"Error updating ANALYZER_THRESHOLDS: {e}")


def analyzer_update_learningrate(address: str, *args) -> None:
	"""Handles incoming OSC messages to update ANALYZER_LEARNING_RATE."""
	global ANALYZER_LEARNING_RATE

	try:
		with osc_lock:
			ANALYZER_LEARNING_RATE = float(args[0])

		send_analyzer_config()
		log.info(f"Updated ANALYZER_LEARNING_RATE: {ANALYZER_LEARNING_RATE}")

	except (ValueError, IndexError) as e:
		log.error(f"Error updating ANALYZER_LEARNING_RATE: {e}")


def update_analyzer_config() -> None:
	"""Update the analyzer configuration."""
	global analyzer_config_left, ANALYZER_LEFT_CHANNEL, ANALYZER_LEFT_THRESHOLD
	global analyzer_config_right, ANALYZER_RIGHT_CHANNEL, ANALYZER_RIGHT_THRESHOLD

	with osc_lock:
		# Left
		analyzer_config_left["events"][0]["start_when"][0]["channel"] = ANALYZER_LEFT_CHANNEL - 1
		analyzer_config_left["events"][0]["start_when"][0]["value"] = ANALYZER_LEFT_THRESHOLD
		analyzer_config_left["events"][1]["start_when"][0]["channel"] = ANALYZER_LEFT_CHANNEL - 1
		analyzer_config_left["events"][1]["start_when"][0]["value"] = ANALYZER_LEFT_THRESHOLD

		# Right
		analyzer_config_right["events"][0]["start_when"][0]["channel"] = ANALYZER_RIGHT_CHANNEL - 1
		analyzer_config_right["events"][0]["start_when"][0]["value"] = ANALYZER_RIGHT_THRESHOLD
		analyzer_config_right["events"][1]["start_when"][0]["channel"] = ANALYZER_RIGHT_CHANNEL - 1
		analyzer_config_right["events"][1]["start_when"][0]["value"] = ANALYZER_RIGHT_THRESHOLD


def send_analyzer_config() -> None:
	"""Send the updated analyzer configuration to the server."""
	global SOCKETS

	if not SOCKETS or len(SOCKETS) < 2:
		log.error("Sockets not initialized, cannot send analyzer configuration.")
		return

	# One-time function attribute initialization
	if not hasattr(send_analyzer_config, "left_active"):
		send_analyzer_config.left_active = False
		send_analyzer_config.right_active = False

	update_analyzer_config()

	sides = {
		"left": {
			"channel": ANALYZER_LEFT_CHANNEL,
			"config": analyzer_config_left,
		},
		"right": {
			"channel": ANALYZER_RIGHT_CHANNEL,
			"config": analyzer_config_right,
		}
	}

	for side, values in sides.items():
		channel = values["channel"]
		config = values["config"]
		active_attr = f"{side}_active"
		is_active = getattr(send_analyzer_config, active_attr)

		if channel == -1:
			if is_active:
				if not send_command(SOCKETS[0], Command.REMOVE_ANALYZER):
					log.error(f"Failed to remove {side} analyzer '{config['name']}'")
				
				elif not send_extra_data(SOCKETS[1], SOCKETS[0], {"analyzer": config["name"]}):
					log.error(f"Failed to send {side} analyzer name '{config['name']}'")
				
				else:
					log.info(f"{side.capitalize()} analyzer '{config['name']}' removed due to disabled channel.")
					setattr(send_analyzer_config, active_attr, False)
		
		else:
			if is_active:
				if not send_command(SOCKETS[0], Command.REMOVE_ANALYZER):
					log.error(f"Failed to remove {side} analyzer '{config['name']}'")
					continue  # Skip adding if we can't remove

				elif not send_extra_data(SOCKETS[1], SOCKETS[0], {"analyzer": config["name"]}):
					log.error(f"Failed to send {side} analyzer name '{config['name']}'")
					continue

			if not send_command(SOCKETS[0], Command.ADD_ANALYZER):
				log.error(f"Failed to send ADD_ANALYZER for {side} '{config['name']}'")

			elif not send_extra_data(SOCKETS[1], SOCKETS[0], config):
				log.error(f"Failed to send configuration for {side} '{config['name']}'")

			else:
				log.info(f"{side.capitalize()} analyzer '{config['name']}' updated successfully.")
				setattr(send_analyzer_config, active_attr, True)


def change_current_sensors(address: str, *args) -> None:
	"""Handles incoming OSC messages to change the current sensor."""
	global CURRENT_SENSORS

	try:
		with osc_lock:
			CURRENT_SENSORS = [int(arg) for arg in args]

		log.info(f"Changed current sensors to {CURRENT_SENSORS}")

	except (ValueError, IndexError) as e:
		log.error(f"Error changing current sensor: {e}")


def listen_to_osc_updates() -> None:
	"""Starts an OSC server to listen for threshold and channel updates from Max/MSP."""
	dispatcher = Dispatcher()
	dispatcher.map("/sensors", change_current_sensors)
	dispatcher.map("/analyzer_channels", analyzer_update_channels)
	dispatcher.map("/analyzer_thresholds", analyzer_update_thresholds)
	dispatcher.map("/analyzer_learningrate", analyzer_update_learningrate)

	server = BlockingOSCUDPServer((ANALYZER_IP, ANALYZER_PORT), dispatcher)
	log.info(f"Listening for OSC updates on port {ANALYZER_PORT}...")
	server.serve_forever()


def main():
	"""Main function to parse CLI args, establish connections and start data processing."""

	# Parse server ports
	parser = argparse.ArgumentParser(description="TCP→OSC bridge: specify Delsys EMG ports to use")
	parser.add_argument("--portCommand", type=int, default=5000, help="EMG command port")
	parser.add_argument("--portResponse", type=int, default=5001, help="EMG response port")
	parser.add_argument("--portLiveData", type=int, default=5002, help="EMG data stream port")
	parser.add_argument("--portLiveAnalyses", type=int, default=5003, help="EMG analyses stream port")
	args = parser.parse_args()

	# Override the default ports
	global EMG_PORTS
	EMG_PORTS = [
		args.portCommand,
		args.portResponse,
		args.portLiveData,
		args.portLiveAnalyses,
	]

	# Establish connections with handshake
	global SOCKETS
	SOCKETS = connect_and_handshake(EMG_HOST, EMG_PORTS)

	if not SOCKETS:
		log.error("Failed to establish all connections. Exiting...")
		return

	# Send CONNECT_DELSYS_EMG command
	if not send_command(SOCKETS[0], Command.CONNECT_DELSYS_EMG):
		log.error("Failed to send CONNECT_DELSYS_EMG command. Exiting...")
		return

	# Start live data listener thread
	data_thread = threading.Thread(target=listen_to_live_data, args=(SOCKETS[2],), daemon=True)
	data_thread.start()

	# # Send ADD_ANALYZER command
	# if not send_command(SOCKETS[0], Command.ADD_ANALYZER):
	# 	log.error("Failed to send ADD_ANALYZER command. Exiting...")
	# 	return

	# # Send the analyzer configuration
	# if not send_extra_data(SOCKETS[1], SOCKETS[0], analyzer_config_left):
	# 	log.error("Failed to send analyzer configuration. Exiting...")
	# 	return

	# Send analyzer config (only if channel != -1)
	send_analyzer_config()

	# Start live analyses listener thread
	analyses_thread = threading.Thread(target=listen_to_live_analyses, args=(SOCKETS[3],), daemon=True)
	analyses_thread.start()

	# Start the OSC listener to change analyzer configuration
	analyzer_update_thread = threading.Thread(target=listen_to_osc_updates, daemon=True)
	analyzer_update_thread.start()

	try:
		log.info("Connections established. Running... Press Ctrl+C to exit.")
		threading.Event().wait()
	except KeyboardInterrupt:
		log.info("\nShutting down...")
	finally:
		for sock in SOCKETS:
			sock.close()
		log.info("Connections closed")


if __name__ == "__main__":
	main()
