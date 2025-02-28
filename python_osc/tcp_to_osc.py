from pythonosc.udp_client import SimpleUDPClient
from enum import Enum
import threading
import datetime
import struct
import socket
import json
import time

# Protocol Version
VERSION = 1

# OSC configuration
OSC_IP, OSC_PORT = "127.0.0.1", 8000
osc_client = SimpleUDPClient(OSC_IP, OSC_PORT)
osc_lock = threading.Lock()

# EMG configuration
EMG_HOST, EMG_PORTS = "127.0.0.1", [5123, 5124, 5125, 5126]  # Command, Response, Data, Analyses
DATA_CHANNELS = list(range(1, 17))

# Data multiplier
DATA_MULTIPLIER = 5000


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


# Analyzer configuration
reference_device = "DelsysEmgDataCollector"
analyzer_config = {
    "name": "foot_cycle",
    "analyzer_type": "cyclic_timed_events",
    "time_reference_device": reference_device,
    "learning_rate": 0.5,
    "initial_phase_durations": [400, 600],
    "events": [
        {
            "name": "heel_strike",
            "previous": "toe_off",
            "start_when": [
                {"type": "threshold", "device": reference_device, "channel": 0,
                 "comparator": "<=", "value": 0.2},
                {"type": "direction", "device": reference_device, "channel": 0, "direction": "negative"}
            ]
        },
        {
            "name": "toe_off",
            "previous": "heel_strike",
            "start_when": [
                {"type": "threshold", "device": reference_device, "channel": 0,
                 "comparator": ">=", "value": -0.2},
                {"type": "direction", "device": reference_device, "channel": 0, "direction": "positive"}
            ]
        }
    ]
}


def log_message(message, level="INFO") -> None:
    """Print messages with a timestamp and log level."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
    print(f"[{timestamp}] [{level}]: {message}")


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
        log_message(f"Invalid command {command}", "ERROR")
        return False

    # Pack command as 8 bytes (4-byte version + 4-byte command)
    command_packet = to_packet(command.value)

    try:
        # Send the command
        sock.sendall(command_packet)
        log_message(f"Sent command: {command.name} ({command.value})")

        # Read the full 16-byte response
        response = sock.recv(16)
        parsed_response = interpret_response(response)

        # Handle interpretation errors
        if "error" in parsed_response:
            log_message(f"Response interpretation error: {parsed_response['error']}", "ERROR")
            return False

        # Check if response is OK (1) or NOK (0)
        if parsed_response["status"] != 1:
            log_message(f"Command {command.name} failed", "ERROR")
            return False

        return True

    except socket.error as e:
        log_message(f"Socket error: {e}", "ERROR")
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
        response = response_sock.recv(16)
        parsed_response = interpret_response(response)

        if "error" in parsed_response:
            log_message(f"Error in extra data response: {parsed_response['error']}", "ERROR")
            return False

        if parsed_response["status"] != 1:
            log_message(f"Extra data failed (NOK received)", "ERROR")
            return False

        log_message(f"Extra data sent successfully")
        return True

    except socket.error as e:
        log_message(f"Socket error while sending extra data: {e}", "ERROR")
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
            log_message(f"Connected to {host}:{port}")

        except Exception as e:
            log_message(f"Error connecting to {host}:{port}: {e}", "ERROR")
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
            log_message(f"Handshake error: {parsed_response['error']}", "ERROR")
            return False

    log_message("Handshake successful")
    return sockets


def parse_data_length(data: bytes) -> int:
    """Extract expected data length from header bytes 12-15."""
    return struct.unpack('<I', data[12:16])[0]


def send_osc_message(address: str, value: float) -> None:
    """Thread-safe function to send OSC messages."""
    with osc_lock:
        osc_client.send_message(address, value)


def listen_to_live_data(sock: socket) -> None:
    """Listen for live data packets and send them via OSC."""
    buffer = bytearray()
    expected_length = None
    sent_timestamps = set()

    log_message(f"Sending live data via OSC on {OSC_IP}:{OSC_PORT}")

    while True:
        try:
            data = sock.recv(4096)
            if not data:
                break
            buffer.extend(data)

            # Read header to determine packet length if not set
            if expected_length is None and len(buffer) >= 16:
                expected_length = parse_data_length(buffer[:16])
                buffer = buffer[16:]

            # Process full packets
            while expected_length and len(buffer) >= expected_length:
                raw_data = buffer[:expected_length]
                buffer = buffer[expected_length:]
                expected_length = None

                try:
                    decoded_data = json.loads(raw_data.decode('utf-8'))

                    for key in decoded_data.keys():
                        for entry in decoded_data[key]['data']['data']:
                            timestamp, channels = entry[0], entry[1]

                            if timestamp not in sent_timestamps:
                                sent_timestamps.add(timestamp)

                                for channel in DATA_CHANNELS:
                                    if channel <= len(channels):
                                        # Send data via OSC
                                        send_osc_message(f'/sensor_{channel}', channels[channel-1] * DATA_MULTIPLIER)

                except json.JSONDecodeError:
                    log_message("JSON decode error in live data. Resetting buffer.", "ERROR")
                    buffer.clear()

        except Exception as e:
            log_message(f"Error processing data: {e}", "ERROR")
            break

    sock.close()
    log_message("Live data connection closed")


def listen_to_live_analyses(sock: socket) -> None:
    """Listen for live analyses packets and send them via OSC."""
    buffer = bytearray()
    expected_length = None

    log_message(f"Sending live analyses via OSC on {OSC_IP}:{OSC_PORT}")

    while True:
        try:
            data = sock.recv(4096)
            if not data:
                break
            buffer.extend(data)

            # Read header to determine packet length if not set
            if expected_length is None and len(buffer) >= 16:
                expected_length = parse_data_length(buffer[:16])
                buffer = buffer[16:]

            # Process full packets
            while expected_length and len(buffer) >= expected_length:
                raw_data = buffer[:expected_length]
                buffer = buffer[expected_length:]
                expected_length = None

                try:
                    decoded_data = json.loads(raw_data.decode('utf-8'))

                    if "data" in decoded_data:
                        for key, analysis in decoded_data["data"].items():
                            if isinstance(analysis, list) and len(analysis) >= 2 and isinstance(analysis[1], list):
                                extracted_data = analysis[1]  # Extract the analysis data

                                # Send data via OSC
                                send_osc_message(f'/{key.replace(" ", "_")}', extracted_data)

                            else:
                                log_message(f"Unexpected format in '{key}' data", "ERROR")

                except json.JSONDecodeError:
                    log_message("JSON decode error in analysis data. Resetting buffer.", "ERROR")
                    buffer.clear()

        except Exception as e:
            log_message(f"Error processing analysis data: {e}", "ERROR")
            break

    sock.close()
    log_message("Live analysis connection closed")


def main():
    """Main function to establish connections and start data processing."""

    # Establish connections with handshake
    sockets = connect_and_handshake(EMG_HOST, EMG_PORTS)
    if not sockets:
        log_message("Failed to establish all connections. Exiting...", "ERROR")
        return

    # Send CONNECT_DELSYS_EMG command
    if not send_command(sockets[0], Command.CONNECT_DELSYS_EMG):
        log_message("Failed to send CONNECT_DELSYS_EMG command. Exiting...", "ERROR")
        return

    # Start live data listener thread
    data_thread = threading.Thread(target=listen_to_live_data, args=(sockets[2],), daemon=True)
    data_thread.start()

    # Send ADD_ANALYZER command
    if not send_command(sockets[0], Command.ADD_ANALYZER):
        log_message("Failed to send ADD_ANALYZER command. Exiting...", "ERROR")
        return

    # Send the analyzer configuration
    if not send_extra_data(sockets[1], sockets[0], analyzer_config):
        log_message("Failed to send analyzer configuration. Exiting...", "ERROR")
        return

    # Start live analyses listener thread
    analyses_thread = threading.Thread(target=listen_to_live_analyses, args=(sockets[3],), daemon=True)
    analyses_thread.start()

    try:
        log_message("Connections established. Running... Press Ctrl+C to exit.")
        threading.Event().wait()
    except KeyboardInterrupt:
        log_message("\nShutting down...")
    finally:
        for sock in sockets:
            sock.close()
        log_message("Connections closed")


if __name__ == "__main__":
    main()
