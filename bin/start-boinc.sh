#!/bin/bash

# Configure the GUI RPC
echo $BOINC_GUI_RPC_PASSWORD > /var/lib/boinc/gui_rpc_auth.cfg
echo $BOINC_REMOTE_HOST > /var/lib/boinc/remote_hosts.cfg

# Run BOINC. Full path needs for GPU support.
exec /usr/bin/boinccmd $BOINC_CMD_LINE_OPTIONS
