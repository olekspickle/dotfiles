#!/bin/bash

set -euo pipefail; shopt -s failglob # safe mode 

# psql
echo "Installing postgresql..." \
    && sudo apt-get install -y wget ca-certificates \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
    && sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' \
    && sudo apt-get update \
    && sudo apt-get install -y postgresql postgresql-contrib \
    && echo "PostgreSQL installed. Current version is: " \
    && psql --version
