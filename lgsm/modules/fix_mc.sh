#!/bin/bash
# LinuxGSM fix_mc.sh module
# Author: Atriarch Systems
# Website: https://linuxgsm.com
# Description: Resolves various issues with Minecraft Java Edition.
# Syncs the port and query port from LinuxGSM common.cfg to server.properties,
# since Minecraft Java does not accept a port CLI argument and reads exclusively
# from server.properties.

moduleselfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

# Fix: Sync server-port and query.port in server.properties from LinuxGSM port config.
# Minecraft Java Edition reads its bind port exclusively from server.properties.
# LinuxGSM sets "port" in common.cfg but this is only used for monitoring/display,
# not propagated to server.properties. Without this fix, MC binds to the default
# port (25565) while the container/K8s forwards to the allocated port.
if [ -n "${port}" ] && [ -f "${servercfgfullpath}" ]; then
	currentport=$(grep -s "^server-port=" "${servercfgfullpath}" | sed 's/server-port=//')
	if [ "${currentport}" != "${port}" ]; then
		fixname="server-port sync (${currentport} -> ${port})"
		fn_fix_msg_start
		sed -i "s/^server-port=.*/server-port=${port}/" "${servercfgfullpath}"
		fn_fix_msg_end
	fi
fi

if [ -n "${queryport}" ] && [ -f "${servercfgfullpath}" ]; then
	currentqueryport=$(grep -s "^query\.port=" "${servercfgfullpath}" | sed 's/query\.port=//')
	if [ "${currentqueryport}" != "${queryport}" ]; then
		fixname="query.port sync (${currentqueryport} -> ${queryport})"
		fn_fix_msg_start
		sed -i "s/^query\.port=.*/query.port=${queryport}/" "${servercfgfullpath}"
		fn_fix_msg_end
	fi
fi
