# Walkthrough

- [How to create an EC2 Instance](ec2-general-setup.md)
- [How to deploy a simple Node.js project](deploy-node-project.md)


---


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

-----

# What and Why

## Overview

### How do you get a Node.js server running on your computer?

To run your Node.js server code locally, you needed:

- A terminal running bash
- Node.js (installed via nvm)
- The code (cloned from github)

Bash comes pre-installed, but to [install nvm](https://github.com/nvm-sh/nvm#install--update-script), you ran the following command:

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
```

To access your code, you needed to create an SSH key:

```sh
ssh-keygen -t ed25519
```

As a student, it's ok not to use a passphrase. As an employee of a company, you will *always* use a passphrase.

Take the defaults and then run the following to get the public version of the key. This is what you will add to your Github profile under [`Settings -> SSH and GPG Keys`](https://github.com/settings/keys)

```sh
cat ~/.ssh/id_ed25519.pub
```

### How would you keep a program running 24x7?

Real websites are running continuously. The code running on your laptop will be stopped any time you put your computer to sleep.

To keep your app running, you need to run it on a computer that never shuts off. These are commonly known as "servers" (because their sole purpose is to run server programs). 

This is why we deploy our code to Linux servers on AWS. Though there are other options, this combination is one of the most popular in the industry.

### How would you make your app available to other people?

You can buy a domain name (like `bestworstcat.com`), and then assign it to your server. You can then tell people to visit `http://bestworstcat.com`, to access your app.

### How would you run multiple node apps on your AWS server?

You can assign more than one domain name to a server. And in fact, you can buy one domain (`bestworstcat.com`) and configure it to have "subdomains", such as `www.bestworstcat.com`, `api.bestworstcat.com`, `lollolol.bestworstcat.com`.

Each of those domain names can be associated with different sites and apps running on the same server.

For this, you need a program that can "proxy" requests to different Node.js programs based on the domain name (or subdomain) being requested.

The most popular and flexible program that can do this is `nginx`.
