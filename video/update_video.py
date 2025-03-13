import os
import shutil
import urllib.request
import json


def main():
    print("Downloading the video file...")
    current_file_path = os.path.abspath(__file__)
    current_dir = os.path.dirname(current_file_path)
    
    # Read the config file (config.json)
    with open(f"{current_dir}/config.json", 'r') as f:
        config = json.load(f)

    # Download the folder from the URL 
    file_name = config["file_name"]
    base_path = config["folder_url"]
    file_path = f"{base_path}/download?path=%2F&files={file_name}"
    urllib.request.urlretrieve(file_path, file_name)

    # Move the downloaded file to the correct location
    shutil.move(file_name, f"{current_dir}/{file_name}")

    print("Download complete!")

if __name__ == '__main__':
    main()
