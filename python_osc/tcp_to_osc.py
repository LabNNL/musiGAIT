from pythonosc.udp_client import SimpleUDPClient
import threading
import datetime
import struct
import socket
import json


# OSC configuration
OSC_IP, OSC_PORT = "127.0.0.1", 8000
osc_client = SimpleUDPClient(OSC_IP, OSC_PORT)

# EMG configuration
DATA_CHANNELS = list(range(1, 17))
EMG_HOST, EMG_PORTS = "127.0.0.1", [5123, 5124, 5125]


def log_message(message, level="INFO"):
    """Print messages with a timestamp and log level."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
    print(f"[{timestamp}] [{level}]: {message}")

def to_packet(command_int):
    """Create an 8-byte packet with version and command information."""
    protocol_version = 1
    return struct.pack("<II", protocol_version, command_int)


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


def send_command(sock, command):
    """Send a command packet to the server."""
    sock.sendall(to_packet(command))
    log_message(f"Command {command} sent")


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
                    values_to_send = {}

                    for entry in decoded_data[0]['data']['data']:
                        timestamp, channels = entry[0], entry[1]

                        if timestamp not in sent_timestamps:
                            sent_timestamps.add(timestamp)

                            for channel in DATA_CHANNELS:
                                if channel <= len(channels):
                                    if channel not in values_to_send:
                                        values_to_send[channel] = []
                                    values_to_send[channel].append(channels[channel - 1])

                    # Send accumulated values for each channel in a flat list
                    for channel, values in values_to_send.items():
                        osc_client.send_message(f'/sensor_{channel}', values)

                except json.JSONDecodeError:
                    log_message("JSON decode error. Resetting buffer.", "ERROR")
                    buffer.clear()
        except Exception as e:
            log_message(f"Error processing data: {e}", "ERROR")
            break

    sock.close()
    log_message("Live data connection closed")


def main():
    """Main function to establish connections and start data processing."""
    sockets = connect_and_handshake(EMG_HOST, EMG_PORTS)
    if not sockets:
        log_message("Failed to establish all connections. Exiting...", "ERROR")
        return

    send_command(sockets[0], 11)  # Send CONNECT_DELSYS_EMG command

    data_thread = threading.Thread(target=listen_to_live_data, args=(sockets[-1],), daemon=True)
    data_thread.start()

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
