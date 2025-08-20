import requests
import json
import os


def main():
    print("Downloading the file...")
    current_file_path = os.path.abspath(__file__)
    current_dir = os.path.dirname(current_file_path)

    with open(os.path.join(current_dir, "config.json"), 'r') as f:
        config = json.load(f)

    file_name = config["file_name"]
    base_url = config["folder_url"]
    download_id = config["download_id"]

    file_url = f"{base_url}/{file_name}{download_id}"
    output_path = os.path.join(current_dir, file_name)

    with requests.get(file_url, stream=True, allow_redirects=True) as r:
        r.raise_for_status()
        with open(output_path, 'wb') as f:
            for chunk in r.iter_content(chunk_size=1024 * 64):
                if chunk:  # filter out keep-alive chunks
                    f.write(chunk)

    print("Download complete!")


if __name__ == "__main__":
    main()
