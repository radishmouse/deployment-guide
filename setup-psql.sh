#!/bin/bash

echo "Installing postgresql"
sudo apt update && sudo apt install -y postgresql

USER=$(whoami)
PSQL_VERSION=$(psql --version | awk '{print $3}' | awk -F. '{print $1}')
PSQL_CONFIG="/etc/postgresql/$PSQL_VERSION/main/pg_hba.conf"

echo "Creating user $USER"
sudo su - postgres -c "psql -c 'create role $USER; alter user $USER with createdb superuser login;'"
echo "Updating configuration file $PSQL_CONFIG"
sudo sed -i '/^host/ s/md5/trust/' "$PSQL_CONFIG"

echo "Restarting postgresql"
sudo service postgresql restart

echo "Finished!"