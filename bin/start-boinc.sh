#!/bin/bash
if [ ! -z "${CC_CONFIG}" ]; then echo $CC_CONFIG > /var/lib/boinc/cc_config.xml; fi

# Configure the GUI RPC
echo $BOINC_GUI_RPC_PASSWORD > /var/lib/boinc/gui_rpc_auth.cfg
echo $BOINC_REMOTE_HOST > /var/lib/boinc/remote_hosts.cfg

# Run BOINC. Full path needs for GPU support.
exec /usr/bin/boinc $BOINC_CMD_LINE_OPTIONS
