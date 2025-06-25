#!/bin/bash
set -euo pipefail

SERVER_CONF_SRC="./my-server.conf"
CLIENT_CONF_SRC="./my-client.ovpn"
SERVER_CONF_DST="/etc/openvpn/server.conf"
CLIENT_CONF_DST="/etc/openvpn/my-client.ovpn"
FIREWALL_SCRIPT="./openvpn-fw.sh"  # Optional, see below

if [[ ! -f "$SERVER_CONF_SRC" || ! -f "$CLIENT_CONF_SRC" ]]; then
    echo "[!] Missing config files. Place my-server.conf and my-client.ovpn in this directory."
    exit 1
fi

echo "[*] Installing server config to $SERVER_CONF_DST"
sudo cp -f "$SERVER_CONF_SRC" "$SERVER_CONF_DST"
sudo chmod 600 "$SERVER_CONF_DST"
sudo chown root:root "$SERVER_CONF_DST"

echo "[*] Installing client config to $CLIENT_CONF_DST"
sudo cp -f "$CLIENT_CONF_SRC" "$CLIENT_CONF_DST"
sudo chmod 600 "$CLIENT_CONF_DST"
sudo chown root:root "$CLIENT_CONF_DST"

if [[ -f "$FIREWALL_SCRIPT" ]]; then
    echo "[*] Applying firewall rules."
    sudo bash "$FIREWALL_SCRIPT"
fi

echo "[*] Restarting OpenVPN server"
sudo systemctl restart openvpn@server

echo "[+] Done. Server and client configs deployed."
