import importlib.util
import subprocess
import sys
import os

VENV_DIR = ".venv"
PYTHON_EXEC = os.path.join(VENV_DIR, "Scripts" if os.name == "nt" else "bin", "python")

DEPENDENCIES = ["yt-dlp", "imageio[ffmpeg]"]


def is_installed(package):
    """Check if a package is installed in the current Python environment."""
    return importlib.util.find_spec(package.replace("-", "_")) is not None


def setup_venv():
    """Sets up a virtual environment and installs dependencies if needed."""
    if not os.path.exists(VENV_DIR):
        print("Creating virtual environment...")
        try:
            subprocess.run([sys.executable, "-m", "venv", VENV_DIR], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error creating venv: {e}")
            sys.exit(1)

    # Ensure pip is installed and updated
    try:
        subprocess.run([PYTHON_EXEC, "-m", "ensurepip", "--default-pip"], check=True)
        subprocess.run([PYTHON_EXEC, "-m", "pip", "install", "--upgrade", "pip"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error installing/upgrading pip: {e}")
        sys.exit(1)

    # Install dependencies if missing
    missing_dependencies = [pkg for pkg in DEPENDENCIES if not is_installed(pkg)]
    if missing_dependencies:
        print(f"Installing missing dependencies: {', '.join(missing_dependencies)}")
        try:
            subprocess.run([PYTHON_EXEC, "-m", "pip", "install"] + missing_dependencies, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error installing dependencies: {e}")
            sys.exit(1)


def download_audio(youtube_url, output_path="output_audio"):
    """Downloads audio from a YouTube video and converts it to WAV."""
    import yt_dlp
    from imageio_ffmpeg import get_ffmpeg_exe

    # Automatically overwrite output file if it exists
    if os.path.exists(output_path):
        os.remove(output_path)

    # Verify ffmpeg availability
    ffmpeg_path = get_ffmpeg_exe()
    if not os.path.exists(ffmpeg_path):
        print("FFmpeg not found. Please install it or ensure it's accessible.")
        sys.exit(1)

    ydl_opts = {
        'format': 'bestaudio/best',
        'noplaylist': True,
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'wav',
        }],
        'postprocessor_args': ['-ar', '44100', '-ac', '2'],  # Ensures 44.1kHz stereo WAV
        'outtmpl': output_path,
        'ffmpeg_location': ffmpeg_path
    }

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        try:
            ydl.download([youtube_url])
        except yt_dlp.utils.DownloadError as e:
            print(f"Error downloading video: {e}")
            sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python youtube_fetch.py <YouTube_URL>")
        sys.exit(1)

    video_url = sys.argv[1]

    if os.path.exists(VENV_DIR) and sys.prefix != sys.base_prefix:
        download_audio(video_url)
    else:
        # Step 1: Setup Virtual Environment & Install Dependencies
        setup_venv()

        # Step 2: Restart the script inside the virtual environment
        subprocess.run([PYTHON_EXEC, __file__, video_url], check=True)
