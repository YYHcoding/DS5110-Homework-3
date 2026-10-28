from pathlib import Path
import urllib.request
import zipfile
import hashlib

URL = "https://files.grouplens.org/datasets/movielens/ml-100k.zip"

PROJECT_ROOT = Path(__file__).resolve().parent.parent
RAW_DIR = PROJECT_ROOT / "data" / "raw"
ZIP_PATH = RAW_DIR / "ml-100k.zip"
def download_dataset():
    RAW_DIR.mkdir(parents=True, exist_ok=True)

    if ZIP_PATH.exists():
        print("ZIP file already exists. Skipping download.")
    else:
        print("Downloading MovieLens 100K...")
        urllib.request.urlretrieve(URL, ZIP_PATH)
        print("Download completed.")


def extract_dataset():
    extracted_dir = RAW_DIR / "ml-100k"

    if extracted_dir.exists():
        print("Dataset already extracted. Skipping extraction.")
    else:
        print("Extracting MovieLens 100K...")

        with zipfile.ZipFile(ZIP_PATH, "r") as zip_ref:
            zip_ref.extractall(RAW_DIR)

        print("Extraction completed.")

def calculate_checksum():
    sha256 = hashlib.sha256()

    with open(ZIP_PATH, "rb") as file:
        for chunk in iter(lambda: file.read(8192), b""):
            sha256.update(chunk)

    checksum = sha256.hexdigest()
    print("SHA-256:", checksum)

    return checksum

def verify_zip():
    with zipfile.ZipFile(ZIP_PATH, "r") as zip_ref:
        bad_file = zip_ref.testzip()

    if bad_file is None:
        print("ZIP integrity check passed.")
    else:
        raise ValueError(f"Corrupted file inside ZIP: {bad_file}")

def verify_extracted_files():
    extracted_dir = RAW_DIR / "ml-100k"

    required_files = ["u.user", "u.item", "u.data"]

    for filename in required_files:
        file_path = extracted_dir / filename

        if not file_path.is_file():
            raise FileNotFoundError(f"Missing required file: {filename}")

    print("All required dataset files are present.")

if __name__ == "__main__":
    download_dataset()
    verify_zip()
    extract_dataset()
    verify_extracted_files()
    calculate_checksum()
    
    