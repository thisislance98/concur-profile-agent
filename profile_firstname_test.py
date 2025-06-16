#!/usr/bin/env python3
"""
Simple test script to demonstrate how to:
1. Obtain a JWT access token from Concur (OAuth 2.0 Password Grant)
2. Fetch the current user's first name via the Travel Profile v2 API
3. Update the user's first name via the same API

Prerequisites:
- The following environment variables must be set (e.g. in your .env file):
    CONCUR_CLIENT_ID=<your-client-id>
    CONCUR_CLIENT_SECRET=<your-client-secret>
    CONCUR_USERNAME=<username@login.com>  # the loginId we will operate on
    CONCUR_PASSWORD=<your-concur-password>

This script purposefully sits at the project root (outside the `joule/` package) so it
won't be packaged with the Joule bots.

NOTE: Running this script will PERMANENTLY modify the first name for the given user in
Concur!  Use a test user account or revert the change afterwards.
"""
from __future__ import annotations

import os
import sys
import textwrap
from typing import Tuple

import requests
from dotenv import load_dotenv
from xml.etree import ElementTree as ET

# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------

def authenticate() -> Tuple[str, str]:
    """Return (access_token, geolocation) by calling the OAuth /token endpoint."""
    client_id = os.getenv("CONCUR_CLIENT_ID")
    client_secret = os.getenv("CONCUR_CLIENT_SECRET")
    username = os.getenv("CONCUR_USERNAME")
    password = os.getenv("CONCUR_PASSWORD")

    if not all([client_id, client_secret, username, password]):
        missing = [name for name, value in (
            ("CONCUR_CLIENT_ID", client_id),
            ("CONCUR_CLIENT_SECRET", client_secret),
            ("CONCUR_USERNAME", username),
            ("CONCUR_PASSWORD", password),
        ) if not value]
        sys.exit(f"Missing required environment variables: {', '.join(missing)}")

    token_url = "https://us.api.concursolutions.com/oauth2/v0/token"
    payload = {
        "client_id": client_id,
        "client_secret": client_secret,
        "grant_type": "password",
        "username": username,
        "password": password,
    }
    headers = {"Content-Type": "application/x-www-form-urlencoded"}

    resp = requests.post(token_url, data=payload, headers=headers, timeout=30)
    try:
        resp.raise_for_status()
    except requests.HTTPError as e:
        sys.exit(f"Authentication failed: {e}\n{resp.text}")

    data = resp.json()
    return data["access_token"], data["geolocation"]


def get_first_name(access_token: str, geolocation: str, login_id: str) -> str:
    """Fetch the user's current first name."""
    profile_url = f"{geolocation}/api/travelprofile/v2.0/profile"
    params = {"userid_type": "login", "userid_value": login_id}
    headers = {"Authorization": f"Bearer {access_token}", "Accept": "application/xml"}

    resp = requests.get(profile_url, headers=headers, params=params, timeout=30)
    try:
        resp.raise_for_status()
    except requests.HTTPError as e:
        sys.exit(f"Failed to fetch profile: {e}\n{resp.text}")

    root = ET.fromstring(resp.text.encode())
    first_name = root.findtext("./General/FirstName", default="")
    return first_name


def update_first_name(access_token: str, geolocation: str, login_id: str, new_first_name: str) -> None:
    """Update the user's first name via Profile v2 API."""
    profile_url = f"{geolocation}/api/travelprofile/v2.0/profile"
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/xml",
    }

    update_xml = textwrap.dedent(
        f"""\
        <?xml version=\"1.0\" encoding=\"utf-8\"?>
        <ProfileResponse xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Action=\"Update\" LoginId=\"{login_id}\">
          <General>
            <FirstName>{new_first_name}</FirstName>
          </General>
        </ProfileResponse>
        """
    ).strip()

    resp = requests.post(profile_url, headers=headers, data=update_xml.encode(), timeout=30)
    try:
        resp.raise_for_status()
    except requests.HTTPError as e:
        sys.exit(f"Failed to update profile: {e}\n{resp.text}")

    print("Update response:\n", resp.text)


# ---------------------------------------------------------------------------
# Main CLI
# ---------------------------------------------------------------------------

def main():
    load_dotenv()

    # Authenticate
    token, geo = authenticate()

    login_id = os.getenv("CONCUR_USERNAME")
    if not login_id:
        sys.exit("CONCUR_USERNAME env var must be set to the user's loginId.")

    print(f"Using geolocation: {geo}\nFetching profile for {login_id}…")
    current_first_name = get_first_name(token, geo, login_id)
    print(f"Current First Name: {current_first_name}")

    # Toggle between two values for demonstration
    new_first_name = "John" if current_first_name != "John" else "Johnny"
    print(f"Updating first name to: {new_first_name}")
    update_first_name(token, geo, login_id, new_first_name)

    # Verify
    refreshed_first_name = get_first_name(token, geo, login_id)
    print(f"First name after update: {refreshed_first_name}")


if __name__ == "__main__":
    main() 