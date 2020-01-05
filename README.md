


- [Node.js on Ubuntu](node-js.md)


-----

# Creating and configuring an EC2 instance (aka server) from the management console web page

- log in at https://aws.amazon.com/console/
- Go to Services -> EC2
- Launch a new instance
- Choose (free tier) Ubuntu 18.04 LTS
- Review & launch
- Configure security group ("punching a hole in the firewall")
    - add rule
    - choose HTTP
- Launch
- Create new keypair 
    - name with current date, download key pair
- Launch for real!

# Logging in with SSH

```sh
mv ~/Downloads/*.pem ~/.ssh/ # move the downloaded pem to your .ssh folder
chmod 600 ~/.ssh/*.pem       # lock down permissions
```

## Creating an alias (for convenience)

- Find your instance information
- Click blue square, click "connect"
- Copy the connection string
- `code ~/.bashrc` or `code ~/.bash_profile`
    - Paste and replace the quotes

## Logging in for the first time

- Open new terminal tab or window
- type name of alias and press enter
- when prompted, type `yes` and press enter

# Update system software

```sh
sudo apt update && sudo apt upgrade -y
sudo reboot
```

After a minute or two, run your alias again to log back in.

# Creating an SSH key for use with Github

```sh
ssh-keygen -t ed25519
```


-----

# Q & A

## What's AWS?

- Amazon
- Web
- Services

It's Amazon.com's server ecosystem that they sell as a service.

## Why do we use AWS?

It looks great on your resume.

And it's similar to Google Cloud and Microsoft Azure.

## What is EC2?

Elastic
Compute
Cloud

It's a "virtual" computer - it's a program that thinks it's a whole computer.

## How is that different from S3?

It's a program that thinks it's a thumb drive.

There's no terminal, and no fun.

## What's Linux?

It's the operating system that runs most servers on the internet.

## What's an Operating System?

It's a program that can run other programs.

It can manage the hardware in addition to running programs.

## Why do we use Linux?

Because it looks good on your resume.

Also, it's fun.

## What's Ubuntu?

It's a "flavor" of Linux.

## What's a firewall?

It's a program that protects your network ports from h4x0rz.

## What's an instance?

This is a single EC2 server.

## How do we access our instance?

We'll use ssh to log in remotely.

## What's SSH?

It lets you log in to a remote computer and it gives you a bash shell.

## What's `sudo`?

It lets you run programs as the administrator.

By default, the version of Ubuntu Linux on AWS is preconfigured to let you use `sudo`.

## What's `apt`?

It gives you access to something like an "app store", but for an Ubuntu Linux computer.

## What's `nginx`?

It's "air traffic control" for when you want to run multiple sites (or Node.js apps) on a single server.

## What's `nano`?

It's a terminal-based text editor.

## What's `pm2`?

It runs your Node.js programs for you when the server starts up.


