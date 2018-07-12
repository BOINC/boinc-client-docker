#!/bin/bash

# Configure the GUI RPC
echo $BOINC_GUI_RPC_PASSWORD > /var/lib/boinc-client/gui_rpc_auth.cfg
echo $BOINC_REMOTE_HOST > /var/lib/boinc-client/remote_hosts.cfg

# Run BOINC. Full path needs for GPU support.
exec /usr/bin/boinc $BOINC_CMD_LINE_OPTIONS
