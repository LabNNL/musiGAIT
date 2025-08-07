from pythonosc.osc_server import BlockingOSCUDPServer
from pythonosc.udp_client import SimpleUDPClient
from pythonosc.dispatcher import Dispatcher
from typing import Callable
from enum import Enum
import threading
import argparse
import logging
import random
import struct
import socket
import select
import json
import time

# Server Version
VERSION = 2

# OSC send to MaxMSP
OSC_IP, OSC_PORT = "127.0.0.1", 8000
osc_client = SimpleUDPClient(OSC_IP, OSC_PORT)
osc_lock = threading.RLock()
msg_lock = threading.Lock()

# EMG to Delsys server
EMG_HOST = "127.0.0.1"

CURRENT_SENSORS = []

SOCKETS = []
IDX_COMMAND = 0  # ports[0] → command port
IDX_MESSAGE = 1  # ports[1] → message port
IDX_LIVE_DATA = 2  # ports[2] → live data port
IDX_LIVE_ANALYSES = 3  # ports[3] → analyses port

# OSC to change analyzer configuration
ANALYZER_IP, ANALYZER_PORT = "127.0.0.1", 8001

# Data multiplier
DATA_MULTIPLIER = 10000

# Analyzer configuration
ANALYZER_LEFT_CHANNEL = None
ANALYZER_LEFT_THRESHOLD = 5

ANALYZER_RIGHT_CHANNEL = None
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
					"channel": ANALYZER_LEFT_CHANNEL,
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
					"channel": ANALYZER_LEFT_CHANNEL,
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
					"channel": ANALYZER_RIGHT_CHANNEL,
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
					"channel": ANALYZER_RIGHT_CHANNEL,
					"comparator": "<",
					"value": ANALYZER_RIGHT_THRESHOLD
				}
			]
		}
	]
}

# Header size
RESPONSE_HEADER_BYTES = 24

logging.basicConfig(
	level=logging.INFO, 
	format='[%(asctime)s.%(msecs)03d] [%(levelname)s] %(message)s', 
	datefmt='%Y-%m-%d %H:%M:%S'
)
log = logging.getLogger(__name__)
logging.addLevelName(logging.ERROR, "FATAL")

stop_event = threading.Event()



# ----------------------------- Enums & Protocol Definitions -----------------------------

# Commands
class Command(Enum):
	NONE = 0xFFFFFFFF
	HANDSHAKE = 0
	GET_STATES = 1

	CONNECT_DELSYS_ANALOG = 10
	CONNECT_DELSYS_EMG = 11
	CONNECT_MAGSTIM = 12

	DISCONNECT_DELSYS_ANALOG = 20
	DISCONNECT_DELSYS_EMG = 21
	DISCONNECT_MAGSTIM = 22

	START_RECORDING = 30
	STOP_RECORDING = 31
	GET_LAST_TRIAL_DATA = 32

	ZERO_DELSYS_ANALOG = 40
	ZERO_DELSYS_EMG = 41

	ADD_ANALYZER = 50
	REMOVE_ANALYZER = 51

	FAILED = 100

# Server messages
class ServerMessage(Enum):
	OK = 0
	NOK = 1
	LISTENING_EXTRA_DATA = 2
	SENDING_DATA = 10
	STATES_CHANGED = 20

# Data types
class DataType(Enum):
	STATES = 0
	FULL_TRIAL = 1
	LIVE_DATA = 10
	LIVE_ANALYSES = 11
	NONE_TYPE = 0xFFFFFFFF



# ----------------------------- Utilities -----------------------------

def to_packet(command_int: int) -> bytes:
	"""
	Create an 8-byte packet: 4 bytes for version + 4 bytes for command.

	Returns:
		bytes: Packed 8-byte packet (little-endian).
	"""
	return struct.pack("<II", VERSION, command_int)


def parse_header(response: bytes) -> dict:
	"""
	Interpret a response from the server.

	Header structure (little-endian):
	  1) 4 bytes : protocol version (must == VERSION)
	  2) 4 bytes : echoed command
	  3) 4 bytes : server message (OK, NOK, etc.)
	  4) 4 bytes : data type (STATES, FULL_TRIAL, NONE, etc.)
	  5) 8 bytes : timestamp (ms since UNIX epoch)

	Returns:
		On success, a dict with:
			- protocol_version (int)
			- command_echo (Command)
			- server_msg (ServerMessage)
			- data_type (DataType)
			- timestamp (int)
			- human_time (str, UTC)
		
		On failure, a dict with:
			- error (str)
			- raw_data (hex str or None)
	"""

	if not response or len(response) != RESPONSE_HEADER_BYTES:
		return {
			"error": "Invalid response length",
			"raw_data": response.hex() if response else None
		}

	# Unpack raw fields
	version, raw_cmd, raw_msg, raw_type, raw_ts = struct.unpack('<I I I I Q', response)

	# Check protocol version
	if version != VERSION:
		return {
			"error": f"Invalid protocol version: {version}",
			"raw_data": response.hex() if response else None
		}

	# Convert to enums
	try:
		command = Command(raw_cmd)
		server_msg = ServerMessage(raw_msg)
		data_type = DataType(raw_type)
	
	except ValueError as e:
		return {
			"error": f"Unknown enum value: {e}",
			"raw_data": response.hex() if response else None
		}

	# Format timestamp
	human_time = time.strftime(
		'%Y-%m-%d %H:%M:%S', 
		time.gmtime(raw_ts / 1000.0)
	)

	return {
		"protocol_version": version,
		"command_echo": command,
		"server_msg": server_msg,
		"data_type": data_type,
		"timestamp": raw_ts,
		"human_time": human_time
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


def parse_data_length(length_bytes: bytes) -> int:
	"""Unpack the 8-byte little-endian length field."""
	return struct.unpack('<Q', length_bytes)[0]



# ----------------------------- Socket Communication -----------------------------
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

		# Read the full response
		response = recv_exact(sock, RESPONSE_HEADER_BYTES)
		parsed_response = parse_header(response)

		# Handle interpretation errors
		if "error" in parsed_response:
			log.error(f"Response interpretation error: {parsed_response['error']}")
			return False

		# For ADD_ANALYZER / REMOVE_ANALYZER we also accept LISTENING_EXTRA_DATA
		if command in (Command.ADD_ANALYZER, Command.REMOVE_ANALYZER):
			allowed = (ServerMessage.OK, ServerMessage.LISTENING_EXTRA_DATA)
		else:
			allowed = (ServerMessage.OK,)

		if parsed_response["server_msg"] not in allowed:
			log.error(f"Command {command.name} failed (got {parsed_response['server_msg'].name})")
			return False

		return True

	except socket.error as e:
		log.error(f"Socket error: {e}")
		return False


def send_extra_data(msg_sock, extra_data: dict) -> bool:
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
		# Serialize
		json_data = json.dumps(extra_data).encode('utf-8')
		header = struct.pack('<II', VERSION, len(json_data))
		payload = header + json_data

		with msg_lock:
			# Temporarily force blocking mode
			orig_blocking = msg_sock.getblocking()
			msg_sock.setblocking(True)
			
			try:
				msg_sock.sendall(payload)
				response_header = recv_exact(msg_sock, RESPONSE_HEADER_BYTES)
				parsed_response = parse_header(response_header)

				if parsed_response.get("data_type") is not DataType.NONE_TYPE:
					length_bytes = recv_exact(msg_sock, 8)
					body_len = parse_data_length(length_bytes)
					_ = recv_exact(msg_sock, body_len)
			
			finally:
				msg_sock.setblocking(orig_blocking)

		# Check parsed
		if "error" in parsed_response:
			log.error(f"Error in extra data response: {parsed_response['error']}")
			return False

		if parsed_response["server_msg"] not in (
			ServerMessage.OK,
			ServerMessage.LISTENING_EXTRA_DATA,
			ServerMessage.SENDING_DATA,
			ServerMessage.STATES_CHANGED
		):
			log.error(f"Extra data failed (`{parsed_response['server_msg']}` received)")
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

	# Random ID
	random_id = random.randint(0x10000000, 0xFFFFFFFE)
	packet_id = struct.pack('<II', VERSION, random_id)

	# Attempt to connect to all ports
	for port in ports:
		try:
			sock = socket.create_connection((host, port))
			sockets.append(sock)
			log.info(f"Connected to {host}:{port}")
			sock.sendall(packet_id)

		except Exception as e:
			log.error(f"Error connecting to {host}:{port}: {e}")
			for s in sockets:
				s.close()
			return False

	# Perform handshake on the first socket
	if len(sockets) == len(ports):
		handshake_message = to_packet(Command.HANDSHAKE.value)
		sockets[IDX_COMMAND].sendall(handshake_message)

		response = recv_exact(sockets[IDX_COMMAND], RESPONSE_HEADER_BYTES)
		parsed = parse_header(response)

		if parsed.get("error") or parsed["server_msg"] is not ServerMessage.OK:
			log.error(f"Handshake error: {parsed['error']}")
			return False

	log.info("Handshake successful")
	return sockets



# ----------------------------- Live Data Handling -----------------------------

def listen_to_live_data(sock: socket.socket, stop_event: threading.Event) -> None:
	"""Listen for live data packets and send them via OSC."""
	sent_timestamps = set()
	log.info(f"Sending live data via OSC on {OSC_IP}:{OSC_PORT}")

	try:
		while not stop_event.is_set():
			header = recv_exact(sock, RESPONSE_HEADER_BYTES)
			parsed = parse_header(header)

			if parsed["data_type"] is not DataType.NONE_TYPE:
				length_bytes = recv_exact(sock, 8)
				body_length = parse_data_length(length_bytes)
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


def listen_to_live_analyses(sock: socket, stop_event: threading.Event) -> None:
	"""Listen for live analyses packets and send them via OSC."""
	buffer = bytearray()
	expected_length = None

	log.info(f"Sending live analyses via OSC on {OSC_IP}:{OSC_PORT}")

	try:
		while not stop_event.is_set():
			header = recv_exact(sock, RESPONSE_HEADER_BYTES)
			parsed = parse_header(header)
			
			if parsed["data_type"] is not DataType.NONE_TYPE:
				length_bytes = recv_exact(sock, 8)
				body_length = parse_data_length(length_bytes)
				body = recv_exact(sock, body_length)
				
				try:
					decoded = json.loads(body.decode('utf-8'))
					for key, analysis in decoded.get("data", {}).items():
						addr = "/" + key.replace(" ", "_")
						# analysis might be [timestamp, scalar] or [timestamp, [a,b,c]]
						if isinstance(analysis, list) and len(analysis) >= 2:
							vals = analysis[1]
							# wrap a scalar in a list
							if not isinstance(vals, list):
								vals = [vals]
							for v in vals:
								send_osc_message(addr, v)
						else:
							# if it's a dict, flatten:
							if isinstance(analysis, dict):
								for subkey, v in analysis.items():
									send_osc_message(f"{addr}/{subkey}", v)
							else:
								log.error(f"Unexpected format for analysis '{key}': {analysis}")
				
				except json.JSONDecodeError:
					log.error("JSON decode error in live analyses; skipping this packet")

	except (ConnectionError, socket.error) as e:
		log.info(f"Live-analyses socket closed: {e}")
	
	finally:
		sock.close()
		log.info("Live analysis connection closed")



# ----------------------------- OSC Communication -----------------------------

def start_osc_server() -> tuple[BlockingOSCUDPServer, threading.Thread]:
	"""Starts an OSC server to listen for threshold and channel updates from Max/MSP."""
	dispatcher = Dispatcher()
	dispatcher.map("/sensors", change_current_sensors)
	dispatcher.map("/analyzer_channels", analyzer_update_channels)
	dispatcher.map("/analyzer_thresholds", analyzer_update_thresholds)
	dispatcher.map("/analyzer_learningrate", analyzer_update_learningrate)

	server = BlockingOSCUDPServer((ANALYZER_IP, ANALYZER_PORT), dispatcher)
	thread = threading.Thread(target=server.serve_forever, daemon=True)
	thread.start()
	log.info(f"OSC server listening on {ANALYZER_IP}:{ANALYZER_PORT}")
	return server, thread


def send_osc_message(address: str, value: float) -> None:
	"""Thread-safe function to send OSC messages."""
	with osc_lock:
		osc_client.send_message(address, value)


def change_current_sensors(address: str, *args) -> None:
	"""Handles incoming OSC messages to change the current sensor."""
	global CURRENT_SENSORS

	try:
		with osc_lock:
			CURRENT_SENSORS = [int(arg) for arg in args]

		log.info(f"Changed current sensors to {CURRENT_SENSORS}")

	except (ValueError, IndexError) as e:
		log.error(f"Error changing current sensor: {e}")


def analyzer_update_channels(address: str, *args) -> None:
	"""Handles incoming OSC messages to update ANALYZER_CHANNEL."""
	global ANALYZER_LEFT_CHANNEL, ANALYZER_RIGHT_CHANNEL

	try:
		with osc_lock:	
			if len(args) == 1:
				ANALYZER_LEFT_CHANNEL = int(args[0]) -1
				ANALYZER_RIGHT_CHANNEL = None
				log.info(f"Updated ANALYZER_LEFT_CHANNEL: {int(args[0])}")
			
			elif len(args) >= 2:
				ANALYZER_LEFT_CHANNEL = int(args[0]) -1
				ANALYZER_RIGHT_CHANNEL = int(args[1]) -1
				log.info(f"Updated ANALYZER_CHANNELS: {int(args[0])}, {int(args[1])}")
			
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



# ----------------------------- Analyzer Configuration -----------------------------

def update_analyzer_config() -> None:
	"""Update the analyzer configuration."""
	global analyzer_config_left, ANALYZER_LEFT_CHANNEL, ANALYZER_LEFT_THRESHOLD
	global analyzer_config_right, ANALYZER_RIGHT_CHANNEL, ANALYZER_RIGHT_THRESHOLD

	with osc_lock:
		# Left
		analyzer_config_left["events"][0]["start_when"][0]["channel"] = ANALYZER_LEFT_CHANNEL
		analyzer_config_left["events"][0]["start_when"][0]["value"] = ANALYZER_LEFT_THRESHOLD
		analyzer_config_left["events"][1]["start_when"][0]["channel"] = ANALYZER_LEFT_CHANNEL
		analyzer_config_left["events"][1]["start_when"][0]["value"] = ANALYZER_LEFT_THRESHOLD

		# Right
		analyzer_config_right["events"][0]["start_when"][0]["channel"] = ANALYZER_RIGHT_CHANNEL
		analyzer_config_right["events"][0]["start_when"][0]["value"] = ANALYZER_RIGHT_THRESHOLD
		analyzer_config_right["events"][1]["start_when"][0]["channel"] = ANALYZER_RIGHT_CHANNEL
		analyzer_config_right["events"][1]["start_when"][0]["value"] = ANALYZER_RIGHT_THRESHOLD


def _remove_analyzer(side: str, cmd_sock, msg_sock, config: dict) -> bool:
	"""
	Send REMOVE_ANALYZER + analyzer name.
	Returns True on success.
	"""
	if not config:
		log.error(f"No cached config to remove for {side}")
		return False

	if not send_command(cmd_sock, Command.REMOVE_ANALYZER):
		log.error(f"Failed to send REMOVE_ANALYZER command for {side}")
		return False

	if not send_extra_data(msg_sock, {"analyzer": config["name"]}):
		log.error(f"Failed to send analyzer name for removal of {side}")
		return False

	log.info(f"Removed {side} analyzer {config['name']}'")
	return True


def _add_analyzer(side: str, cmd_sock, msg_sock, config: dict) -> bool:
	"""
	Send ADD_ANALYZER + full config.
	Returns True on success.
	"""
	if not send_command(cmd_sock, Command.ADD_ANALYZER):
		log.error(f"Failed to send ADD_ANALYZER command for {side}")
		return False

	if not send_extra_data(msg_sock, config):
		log.error(f"Failed to send configuration for {side} analyzer '{config.get('name')}'")
		return False

	log.info(f"Added/updated {side} analyzer '{config['name']}'")
	return True


def send_analyzer_config() -> None:
	"""Send the updated analyzer configuration to the server."""
	global SOCKETS

	if not SOCKETS or len(SOCKETS) < 2:
		log.error("Sockets not initialized, cannot send analyzer configuration.")
		return

	cmd_sock = SOCKETS[IDX_COMMAND]
	msg_sock = SOCKETS[IDX_MESSAGE]

	# One-time function attribute initialization
	if not hasattr(send_analyzer_config, "_cache"):
		send_analyzer_config._cache = {
			"left": {"active": False, "config": None},
			"right": {"active": False, "config": None}
	}

	update_analyzer_config()

	sides = {
		"left": (ANALYZER_LEFT_CHANNEL, analyzer_config_left),
		"right": (ANALYZER_RIGHT_CHANNEL, analyzer_config_right),
	}
	cache = send_analyzer_config._cache
	
	for side, (channel, config) in sides.items():
		entry = cache[side]
		was_active = entry["active"]
		last_config = entry["config"]

		if channel is None:
			if was_active:
				if _remove_analyzer(side, cmd_sock, msg_sock, last_config):
					entry["active"] = False
					entry["config"] = None
			else:
				log.debug(f"No {side} analyzer to remove; skipping.")
			continue

		if was_active and last_config == config:
			log.debug(f"No change in {side} analyzer; skipping.")
			continue

		if was_active:
			if not _remove_analyzer(side, cmd_sock, msg_sock, last_config):
				continue

		if _add_analyzer(side, cmd_sock, msg_sock, config):
			entry["active"] = True
			entry["config"] = json.loads(json.dumps(config))



# ----------------------------- Message Dispatcher -----------------------------

def _handle_states_changed(parsed, body) -> None:
	log.info("Detected STATES_CHANGED: requesting GET_STATES")
	if not send_command(SOCKETS[IDX_COMMAND], Command.GET_STATES):
		log.error("GET_STATES request failed")


def _handle_states(parsed, body) -> None:
	"""
	Forwards a STATES response (JSON) to Max/MSP via OSC at /states.
	"""
	try:
		json_str = body.decode("utf-8")
		
		with osc_lock:
			osc_client.send_message("/states", json_str)
		
		log.info("Forwarded /states to Max/MSP")

	except Exception as e:
		log.error(f"Error forwarding STATES to Max/MSP: {e}")


def _handle_unexpected(parsed, body) -> None:
	log.debug(f"No handler for server_msg={parsed['server_msg']} data_type={parsed['data_type']}")


MESSAGE_HANDLERS: dict[Enum, Callable] = {
	ServerMessage.STATES_CHANGED: _handle_states_changed,
	DataType.STATES: _handle_states,
}


def message_dispatcher(sock: socket.socket, stop_event: threading.Event) -> None:
	sock.setblocking(False)
	while not stop_event.is_set():
		
		if msg_lock.locked():
			time.sleep(0.5)
			continue

		# wait up to 0.1s for data to arrive
		ready, _, _ = select.select([sock], [], [], 0.1)
		if not ready:
			continue

		try:
			# parse header & body
			header = recv_exact(sock, RESPONSE_HEADER_BYTES)
			parsed = parse_header(header)

			if parsed.get("error"):
				log.error(f"Header parse error: {parsed['error']}")
				continue

			# read body if present
			body = None
			if parsed["data_type"] is not DataType.NONE_TYPE:
				length_bytes = recv_exact(sock, 8)
				body_len = parse_data_length(length_bytes)
				body = recv_exact(sock, body_len)

			# pick a handler by server_msg first, then data_type
			handler = MESSAGE_HANDLERS.get(parsed["server_msg"]) \
					or MESSAGE_HANDLERS.get(parsed["data_type"]) \
					or _handle_unexpected

			handler(parsed, body)

		except Exception as e:
			log.error(f"Message dispatcher error: {e}")
			break



# ----------------------------- Main -----------------------------

def main():
	"""Main function to parse CLI args, establish connections and start data processing."""

	# Parse server ports
	parser = argparse.ArgumentParser(description="TCP/OSC bridge: specify Delsys EMG ports to use")
	parser.add_argument("--portCommand", type=int, default=5000, help="EMG command port")
	parser.add_argument("--portMessage", type=int, default=5001, help="EMG message port")
	parser.add_argument("--portLiveData", type=int, default=5002, help="EMG data stream port")
	parser.add_argument("--portLiveAnalyses", type=int, default=5003, help="EMG analyses stream port")
	parser.add_argument("--useMock", type=str, default="false", choices=["true", "false"], 
		help="Use MOCK server instead of real EMG: 'true' or 'false'")
	args = parser.parse_args()

	# Override the default ports
	global EMG_PORTS
	EMG_PORTS = [
		args.portCommand,
		args.portMessage,
		args.portLiveData,
		args.portLiveAnalyses,
	]

	# Establish connections with handshake
	global SOCKETS
	SOCKETS = connect_and_handshake(EMG_HOST, EMG_PORTS)

	reader_thread = threading.Thread(
		target=message_dispatcher,
		args=(SOCKETS[IDX_MESSAGE], stop_event),
		daemon=True
	)
	reader_thread.start()

	if not SOCKETS:
		log.error("Failed to establish all connections. Exiting...")
		return

	# Send CONNECT_DELSYS_EMG command
	if not send_command(SOCKETS[IDX_COMMAND], Command.CONNECT_DELSYS_EMG):
		log.error("Failed to send CONNECT_DELSYS_EMG command. Exiting...")
		return

	# Start live data listener thread
	data_thread = threading.Thread(
		target=listen_to_live_data, 
		args=(SOCKETS[IDX_LIVE_DATA], stop_event), 
		daemon=True
	)
	data_thread.start()

	# Send analyzer config (only if channel != None)
	send_analyzer_config()

	# Start live analyses listener thread
	analyses_thread = threading.Thread(
		target=listen_to_live_analyses, 
		args=(SOCKETS[IDX_LIVE_ANALYSES], stop_event), 
		daemon=True
	)
	analyses_thread.start()

	# Start the OSC listener to change analyzer configuration
	osc_server, osc_thread = start_osc_server()

	try:
		log.info("Connections established. Running... Press Ctrl+C to exit.")
		stop_event.wait()
	
	except KeyboardInterrupt:
		log.info("\nShutting down...")
		stop_event.set()
		osc_server.shutdown()
		osc_server.server_close()
	
	finally:
		data_thread.join()
		analyses_thread.join()
		osc_thread.join()
		
		for sock in SOCKETS:
			sock.close()
		
		log.info("Connections closed")


if __name__ == "__main__":
	main()
