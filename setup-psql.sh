sudo apt update && sudo apt install -y postgresql

sudo su - postgres -c "psql -c 'create role ubuntu; alter user ubuntu with createdb superuser login;'"

sudo sed -i '/^host/ s/md5/trust/' /etc/postgresql/10/main/pg_hba.conf

sudo service postgresql restart

