# /opt/block-ufw.sh
#!/usr/bin/env bash
echo "ufw was called inside the container – aborting" >&2
# Optional: drop a marker file in the watched directory
[ -d /watch ] && touch /watch/ufw_called
# Non-zero exit to trip `set -e` in the installer
exit 1