import subprocess
import sys
import os

VENV_DIR = ".venv"
PYTHON_EXEC = os.path.join(VENV_DIR, "Scripts" if os.name == "nt" else "bin", "python")

DEPENDENCIES = ["yt-dlp", "imageio[ffmpeg]"]


def setup_venv():
    """Sets up a virtual environment and installs dependencies if needed."""
    if not os.path.exists(VENV_DIR):
        print("Creating virtual environment...")
        try:
            subprocess.run([sys.executable, "-m", "venv", VENV_DIR], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error creating venv: {e}")
            sys.exit(1)

    # Ensure pip is installed and updated using Python itself
    try:
        subprocess.run([PYTHON_EXEC, "-m", "ensurepip", "--default-pip"], check=True)
        subprocess.run([PYTHON_EXEC, "-m", "pip", "install", "--upgrade", "pip"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error installing/upgrading pip: {e}")
        sys.exit(1)

    # Install dependencies if missing
    for package in DEPENDENCIES:
        result = subprocess.run([PYTHON_EXEC, "-c", f"import {package.split('-')[0]}; print('OK')"], capture_output=True, text=True)
        if "OK" not in result.stdout:
            print(f"Installing {package}...")
            try:
                subprocess.run([PYTHON_EXEC, "-m", "pip", "install", package], check=True)
            except subprocess.CalledProcessError as e:
                print(f"Error installing {package}: {e}")
                sys.exit(1)


def download_audio(video_url, output_path="output_audio"):
    """Downloads audio from a YouTube video and converts it to WAV."""
    import yt_dlp
    from imageio_ffmpeg import get_ffmpeg_exe

    # Delete the output file if it already exists
    if os.path.exists(output_path):
        os.remove(output_path)

    ffmpeg_path = get_ffmpeg_exe() 

    ydl_opts = {
        'format': 'bestaudio/best',
        'noplaylist': True,
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'wav',
            'preferredquality': '320',
        }],
        'outtmpl': output_path,
        'ffmpeg_location': ffmpeg_path
    }

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        ydl.download([video_url])




if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python youtube_fetch.py <YouTube_URL>")
        sys.exit(1)

    video_url = sys.argv[1]

    if sys.prefix != sys.base_prefix:
        download_audio(video_url)
    else:
        # Step 1: Setup Virtual Environment & Install Dependencies
        setup_venv()

        # Step 2: Restart the script inside the virtual environment
        subprocess.run([PYTHON_EXEC, __file__, video_url])
