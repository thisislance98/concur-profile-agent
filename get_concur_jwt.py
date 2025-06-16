import os
import sys
import requests
from dotenv import load_dotenv
import xml.etree.ElementTree as ET

# Load environment variables from .env if present
load_dotenv()

# Required environment variables
client_id = os.getenv("CONCUR_CLIENT_ID")
client_secret = os.getenv("CONCUR_CLIENT_SECRET")
username = os.getenv("CONCUR_USERNAME")
password = os.getenv("CONCUR_PASSWORD")

def missing_vars():
    return [
        var for var, val in [
            ("CONCUR_CLIENT_ID", client_id),
            ("CONCUR_CLIENT_SECRET", client_secret),
            ("CONCUR_USERNAME", username),
            ("CONCUR_PASSWORD", password),
        ] if not val
    ]

if missing_vars():
    sys.exit(f"Missing required environment variables: {', '.join(missing_vars())}")

# Concur OAuth2 token endpoint (US instance)
TOKEN_URL = "https://us.api.concursolutions.com/oauth2/v0/token"
PROFILE_URL = "https://us.api.concursolutions.com/api/travelprofile/v2.0/profile"

payload = {
    "client_id": client_id,
    "client_secret": client_secret,
    "grant_type": "password",
    "username": username,
    "password": password,
}
headers = {"Content-Type": "application/x-www-form-urlencoded"}

try:
    response = requests.post(TOKEN_URL, data=payload, headers=headers)
    response.raise_for_status()
    data = response.json()
    access_token = data["access_token"]
    print(f"Access token: {access_token[:20]}...\n")
except requests.RequestException as e:
    print(f"Error requesting token: {e}")
    if e.response is not None:
        print(e.response.text)
    sys.exit(1)

# Use the token to get the user's profile
profile_headers = {
    "Authorization": f"Bearer {access_token}",
    "Accept": "application/xml",
}
try:
    profile_response = requests.get(PROFILE_URL, headers=profile_headers)
    profile_response.raise_for_status()
    xml_content = profile_response.text
    # Parse XML to get <FirstName>
    root = ET.fromstring(xml_content)
    first_name = None
    general = root.find("General")
    if general is not None:
        first_name_elem = general.find("FirstName")
        if first_name_elem is not None:
            first_name = first_name_elem.text
    if first_name:
        print(f"User's first name: {first_name}")
    else:
        print("Could not find user's first name in profile response.")
except requests.RequestException as e:
    print(f"Error requesting profile: {e}")
    if e.response is not None:
        print(e.response.text)
    sys.exit(1)
except ET.ParseError as e:
    print(f"Error parsing XML: {e}")
    print(xml_content)
    sys.exit(1)

# Prompt for new first name
new_first_name = input("Enter new first name for the user: ").strip()
if not new_first_name:
    print("No new first name provided. Exiting.")
    sys.exit(0)

# Prepare XML payload for update
update_xml = f'''<?xml version="1.0" encoding="utf-8"?>
<ProfileResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Action="Update" LoginId="{username}">
  <General>
    <FirstName>{new_first_name}</FirstName>
  </General>
</ProfileResponse>'''

update_headers = {
    "Authorization": f"Bearer {access_token}",
    "Content-Type": "application/xml",
    "Accept": "application/xml",
}

try:
    update_response = requests.post(PROFILE_URL, headers=update_headers, data=update_xml.encode("utf-8"))
    update_response.raise_for_status()
    print("Update response:")
    print(update_response.text)
    # Optionally, re-fetch and print the updated first name
    profile_response = requests.get(PROFILE_URL, headers=profile_headers)
    profile_response.raise_for_status()
    xml_content = profile_response.text
    root = ET.fromstring(xml_content)
    general = root.find("General")
    updated_first_name = None
    if general is not None:
        first_name_elem = general.find("FirstName")
        if first_name_elem is not None:
            updated_first_name = first_name_elem.text
    if updated_first_name:
        print(f"Updated user's first name: {updated_first_name}")
    else:
        print("Could not verify updated first name in profile response.")
except requests.RequestException as e:
    print(f"Error updating profile: {e}")
    if e.response is not None:
        print(e.response.text)
    sys.exit(1)
except ET.ParseError as e:
    print(f"Error parsing XML after update: {e}")
    print(xml_content)
    sys.exit(1) 