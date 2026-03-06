#!/bin/bash

# Install the latest version of firefox.
# We can't use the one in the snap store because there's a bug which  means
# that confined snap applications don't work over VNC.
#
# https://bugs.launchpad.net/ubuntu/+source/snapd/+bug/1951491

# We're going to add the mozilla repository and install firefox from there.

sudo install -d -m 0755 /etc/apt/keyrings

wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | \
sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] \
https://packages.mozilla.org/apt mozilla main" | \
sudo tee /etc/apt/sources.list.d/mozilla.list

echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla

sudo apt update
sudo apt install firefox


# Because this is a fresh install we want to bypass the normal first
# boot experience and set biotrain.tv to be the homepage.

URL="https://biotrain.tv"

POLICY_DIR="/etc/firefox/policies"
POLICY_FILE="$POLICY_DIR/policies.json"

sudo mkdir -p "$POLICY_DIR"

sudo tee "$POLICY_FILE" > /dev/null <<EOF
{
  "policies": {
  "Preferences": {
      "datareporting.policy.firstRunURL": {
        "Value": "",
        "Status": "locked"
      }
    },
    "DontCheckDefaultBrowser": true,
    "DisableProfileImport": true,
    "OverrideFirstRunPage": "",
    "OverridePostUpdatePage": "",
    "Homepage": {
      "URL": "$URL",
      "StartPage": "homepage"
    }
  }
}
EOF
