sudo apt-get install python3 build-essential curl cmake \
    && ./install_images_related.sh \
    && ./install_psql.sh \
    && ./install_fonts.sh \
    && ./install_node.sh \
    && ./install_rust.sh \
    && sudo snap install obs-studio code
