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

# EMG configuration
EMG_HOST, EMG_PORTS = "127.0.0.1", [5123, 5124, 5125, 5126]  # Command, Response, Data, Analyses
DATA_CHANNELS = list(range(1, 17))

# Data multiplier
DATA_MULTIPLIER = 5000


import threading
import datetime
import struct
import socket
import json
import time

# Version
VERSION = 1

# OSC configuration
OSC_IP, OSC_PORT = "127.0.0.1", 8000
osc_client = SimpleUDPClient(OSC_IP, OSC_PORT)

# EMG configuration
EMG_HOST, EMG_PORTS = "127.0.0.1", [5123, 5124, 5125, 5126]
DATA_CHANNELS = list(range(1, 17))

# Data multiplier
DATA_MULTIPLIER = 10000
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
analyzer_config = {
    "name": "Right Foot",
    "analyzer_type": "cyclic_timed_events",
    "time_reference_device": "DelsysAnalogDataCollector",
    "learning_rate": 0.5,
    "initial_phase_durations": [400, 600],
    "events": [
        {
            "name": "heel_strike",
            "previous": "toe_off",
            "start_when": [
                {"type": "threshold", "device": "DelsysAnalogDataCollector", "channel": 0, "comparator": "<=", "value": 0.2},
                {"type": "direction", "device": "DelsysAnalogDataCollector", "channel": 0, "direction": "negative"}
            ]
        },
        {
            "name": "toe_off",
            "previous": "heel_strike",
            "start_when": [
                {"type": "threshold", "device": "DelsysAnalogDataCollector", "channel": 0, "comparator": ">=", "value": -0.2},
                {"type": "direction", "device": "DelsysAnalogDataCollector", "channel": 0, "direction": "positive"}
            ]
        }
    ]
}


def log_message(message, level="INFO"):
    """Print messages with a timestamp and log level."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
    print(f"[{timestamp}] [{level}]: {message}")


def to_packet(command_int):
    """Create an 8-byte packet with version and command information."""
    return struct.pack("<II", VERSION, command_int)


def receive_exactly(sock, num_bytes):
    """Ensure that we receive exactly num_bytes."""
    data = bytearray()
    while len(data) < num_bytes:
        chunk = sock.recv(num_bytes - len(data))
        if not chunk:
            raise ConnectionError("Connection closed unexpectedly")
        data.extend(chunk)
    return bytes(data)


def send_command(sock, command):
    """Send a command packet to the server."""
    sock.sendall(to_packet(command))
    log_message(f"Command {command} sent")

    # Read the full 16-byte response
    response = receive_exactly(sock, 16)
    if len(response) != 16:
        log_message("Incomplete response received", "ERROR")
        return False

    # Unpack the response using little-endian format
    protocol_version, timestamp, status = struct.unpack('<I Q I', response)

    if protocol_version != VERSION:
        log_message(f"Warning: Unexpected protocol version {protocol_version}", "WARNING")

    # Convert timestamp from milliseconds to a readable format
    timestamp_seconds = timestamp / 1000.0
    human_readable_time = time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(timestamp_seconds))

    # Log the parsed response
    log_message(f"Response received: Protocol={protocol_version}, Time={human_readable_time}, Status={status}")

    # Check if response is OK (1) or NOK (0)
    if status != 1:
        log_message(f"Command {command} failed", "ERROR")
        return False

    return True


def send_analyzer_data(sock, response_sock, analyzer_data):
    data_json = json.dumps(analyzer_data)
    data_bytes = data_json.encode('utf-8')
    header = struct.pack('<II', VERSION, len(data_bytes))
    response_sock.sendall(header + data_bytes)
    log_message("Analyzer data sent")

    response = receive_exactly(sock, 16)
    protocol_version, timestamp, status = struct.unpack('<I Q I', response)

    if status != 1:
        log_message("Analyzer data transmission failed", "ERROR")
        return False

    return True


def connect_and_handshake(host, ports):
    """Connect to all ports and perform a handshake."""
    sockets = []

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

    # Perform handshake
    if len(sockets) == len(ports):
        handshake_message = to_packet(0)  # Handshake command = 0
        sockets[0].sendall(handshake_message)
        response = sockets[0].recv(4)
        if struct.unpack('<I', response)[0] != 1:
            log_message("Handshake failed", "ERROR")
            return False

    log_message("Handshake successful")
    return sockets


def parse_data_length(data):
    """Extract expected data length from header bytes 12-15."""
    return struct.unpack('<I', data[12:16])[0]


def listen_to_live_data(sock):
    """Listen for live data packets and process them."""
    buffer = bytearray()
    expected_length = None
    sent_timestamps = set()

    log_message(f"Serving live data on {OSC_IP}:{OSC_PORT}")

    while True:
        try:
            data = sock.recv(4096)
            if not data:
                break
            buffer.extend(data)

            # Read header to determine packet length
            if expected_length is None and len(buffer) >= 16:
                expected_length = parse_data_length(buffer)
                del buffer[:16]

            # Process full packets
            while expected_length and len(buffer) >= expected_length:
                raw_data = buffer[:expected_length]
                del buffer[:expected_length]
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
                                        osc_client.send_message(f'/sensor_{channel}', channels[channel-1] * DATA_MULTIPLIER)

                except json.JSONDecodeError:
                    log_message("JSON decode error. Resetting buffer.", "ERROR")
                    buffer.clear()

        except Exception as e:
            log_message(f"Error processing data: {e}", "ERROR")
            break

    sock.close()
    log_message("Live data connection closed")


def listen_to_live_analyses(sock):
    """Listen for live analyses packets and process them."""
    log_message(f"Serving live analyses on {OSC_IP}:{OSC_PORT}")

    while True:
        try:
            data = sock.recv(4096)
            if not data:
                break
            decoded_data = json.loads(data.decode('utf-8'))
            log_message(f"Analysis data received: {decoded_data}")
            osc_client.send_message("/analysis", decoded_data)
        except Exception as e:
            log_message(f"Error processing analysis data: {e}", "ERROR")
            break
    sock.close()
    log_message("Live analysis connection closed")


def main():
    """Main function to establish connections and start data processing."""
    sockets = connect_and_handshake(EMG_HOST, EMG_PORTS)
    if not sockets:
        log_message("Failed to establish all connections. Exiting...", "ERROR")
        return

    # Send CONNECT_DELSYS_EMG command
    send_command(sockets[0], 11)
    data_thread = threading.Thread(target=listen_to_live_data, args=(sockets[2],), daemon=True)
    data_thread.start()

    # send ADD_ANALYZER command
    send_command(sockets[0], 50)
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
