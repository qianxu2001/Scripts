#! /bin/bash

SCRIPT_URL="https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/installScript/master/install"
SCRIPT_NAME="omvinstall.sh"
SCRIPT_TEMP="$(mktemp)"

# script or cmd setup
cat >${SCRIPT_TEMP}<<EOF
FILE="/srv/salt/omv/deploy/watchdog/default.sls"

while true
do
	sleep 1
	[ -f "\$FILE" ] && break
done

sed -i "s/\({*runtimewatchdogsec = \)[[:digit:]]*\( %}\)/\18\2/g" \${FILE}
EOF

bash ${SCRIPT_TEMP} &

# script setup
rm -f ${SCRIPT_NAME}
wget -O ${SCRIPT_NAME} ${SCRIPT_URL}

sed -i -e "s/odroidn2/&|onecloud/" \
	-e "/network-manager/ s/^/#/" \
	-e "/systemd-resolved/ s/^/#/g" \
	-e "/resolv.conf/ s/^/#/g" ${SCRIPT_NAME}
\cp -f /boot/uInitrd{,.bak}
bash ${SCRIPT_NAME}
