#!/bin/sh
echo "Running minica with IP ${MY_POD_IP}"
./minica -ip-addresses ${MY_POD_IP}

echo "Copying files to volume..."
cp /${MY_POD_IP}/* /ssl