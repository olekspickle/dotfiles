#!/bin/bash

# a bunch of dev audio stuff for compiling plugins and DAWs
sudo apt install -y gperf intltool python3 sassc \
    libavahi-gobject-dev  libbluetooth-dev  liblo-dev  libtag1-dev \
    libboost-dev  libboost-iostreams-dev  libboost-thread-dev  \
    libeigen3-dev libgtk-3-dev libgtkmm-3.0-dev \
    liblilv-dev liblrdf0-dev libsndfile1-dev libfftw3-dev  \
    libarhive-dev libpulse-dev libjack-dev lv2-dev vamp-plugin-sdk \
    librubberband-dev libaubio-dev libusb-dev

# LMMS specific
sudo apt install -y  qtbase5-private-dev \
    libqt5svg5-dev sudo apt install liblist-moreutils-perl \
    libxcb-util-dev libxcb-keysyms1-dev libxcb-icccm4-dev

