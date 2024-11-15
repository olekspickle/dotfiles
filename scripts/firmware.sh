#!/bin/bash

# update firmware on a device
sudo fwupdmgr get-devices
sudo fwupdmgr get-updates
sudo fwupdmgr update
