
Before staring, make sure you sign up for a free AWS account.

# The goal

We need to deploy a Node.js application so that it is publicly accessible on the internet. To do so, we'll set up a Linux server on AWS.

# Terminology

## AWS

Amazon rents access to its server ecosystem. This ecosystem is known as the Amazon Web Services. 

There are dozens of kinds of services available on AWS, ranging from storage to databases to virtual computers.

## EC2

The AWS service that provides virtual computers is the Elastic Compute Cloud, or EC2.

## instance

Amazon refers to a single EC2 server as an instance.


# Creating an EC2 instance

## Launch a new instance

- click buttons (Ubuntu 18 LTS)
- open HTTP port
- download keys
- launch

## Connect to your instance via `ssh`

- move the keys `mv ~/Downloads/*.pem ~/.ssh`
- lock down permissions with `chmod 600 ~/.ssh/*.pem`
- (optional) create an alias
- connect for first time (confirm with 'yes')

## Update the system

- `sudo apt update`
- `DEBIAN_FRONTEND=noninteractive sudo apt upgrade -y`
- `sudo reboot`

# Software installation

## Install `nginx`

```sh
sudo apt install nginx
```

## Install `nvm`

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
```

Either log out and log back in, or copy and paste the shell commands output after installing `nvm`.

### Install LTS version of Node.js

# Clone and run your project

## Generate `ssh` keys

```sh
ssh-keygen -t ed25519
```

## Add keys to Github

On github.com, click on your profile icon in the upper right. Choose `Settings`. On the Settings page, locate the `SSH and GPG Keys` item in the left hand menu. Click `Add New Key`. Give your new key a title with the current date.

To retrieve the key, run the following command in the terminal that is logged into your EC2 instance:

```sh
cat ~/.ssh/id_ed25519.pub
```

Copy and paste the output into the text box on github.com.

## Clone your project

- Make sure to select "Clone with SSH"
- cd into your project directory

## Install dependencies

```sh
npm install
```

## Manually run project

```sh
node index.js
```

# `nginx` configuration

## Edit the `nginx` configuration file

```sh
sudo nano /etc/nginx/sites-available/default
```

Find the `server` block

- comment out the `root` directive

Find the `location` block inside the `server` block.

- comment out the `tryfiles` directive

Add the following line:

```
proxy_pass http://localhost:3000
```

- Press `Ctrl+X`
- Press `Y`
- Press `Enter`

## Test the configuration file

```sh
sudo nginx -t
```

It should report that the syntax is ok.

## Restart the `nginx` service

```sh
sudo service nginx restart
```

If all goes well, there should be no output.

You're almost there!

# Make your Node.js project run automatically

To make sure that your Node.js program runs without you having to log in to start it, you'll use the `pm2` program to do that for you.

## Install `pm2`

```sh
npm install -g pm2
```

## Run your project code with `pm2`

```sh
cd ~/project-directory
pm2 start index.js --name my-project-name
```
You should see a table showing the status of your Node.js program.

## Get startup command

```sh
pm2 startup
```

Copy and paste the command it prints

## Save process list

```sh
pm2 save
```

# Confirm `pm2` and `nginx` configuration


## Reboot

```sh
sudo reboot
```

Wait a minute or two, then log back in via ssh.

Check that the server rebooted by running `uptime`. You should see something like this:

(show that it's around 0 minutes of uptime)


## Reload the web page

At this point you should be able to reload your web page and see that your Node.js program is running.

# Troubleshooting
