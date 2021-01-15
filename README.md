
# Walkthrough

- [How to create an EC2 Instance](ec2-general-setup.md)
- [How to deploy a simple Node.js project](deploy-node-project.md)


---

# The big picture

![](/images/overview.png)

Running your Node/Express app with PostgreSQL on your AWS EC2 server involves installing and configuring the following:

- A custom domain, purchased from a service like [namecheap.com](namecheap.com)
- Ports `80` and `443` open on your EC2 instance's firewall
- An SSL certificate that encrypts the traffic between your app and the client (browser)
- The `nginx` http server that can route traffic to different express apps or static sites based on the *domain name*
- `node` and `npm` so that you can install dependencies and run your Node.js code
- `pm2`, which runs your express app automatically when the server boots (so you don't have to be logged in to run it manually)
- The PostgreSQL database engine

Finally, you'll need an ssh key so that you can securely `git clone` your project from GitHub.

## The short(er) version

### Purchase and configure a domain

You can register a domain for less than $4/year.

If using namecheap.com, go to your list of domains and click the "manage" button for your domain.

Click the tab labeled "Advanced DNS"

In another browser tab, log into the AWS control panel, go to the details page for your EC2 instance, and locate the "IPv4 Public address"

Copy this address.

On the namecheap Advanced DNS page for your domain:

- click the trash can icon for the two placeholder entries
- click "Add new record"
- choose "A record" for the "Type"
- Put the "@" symbol in the "Host" field
- Paste the IPv4 public address into the "Value" field
- Choose "5 min" for the TTL
- Click the green check mark


### Open ports 80 and 443

Go to your instance details and click the "Security" tab.

Click any of the links in the "Security groups" section

Click "Edit inbound rules"

Click "Add rule"

Choose "HTTP" from the dropdown for the "Type" and "Anywhere" from the dropdown for the "Source"

Click "Add rule" again

Choose "HTTPS" from the dropdown for the "Type" and "Anywhere" from the dropdown for the "Source"

Click "Save rules"


### Update the system software and reboot

`ssh` into your EC2 server and then run this command to update the system.


```sh
sudo apt update && sudo apt upgrade -y
```

After a few minutes, the system will be updated.

Reboot with:

```sh
sudo reboot
```

You'll be disconnected from the server while it reboots (which should take less than 60 seconds)

### Install `nginx`

`ssh` into the server again and run the following command to install `nginx`:

```sh
sudo apt install nginx
```

#### Configure `nginx`

Download the example config and copy it to the nginx configuration directory:

```sh
curl -O "https://raw.githubusercontent.com/radishmouse/deployment-guide/master/nginx-config.txt"
sudo cp nginx-config.txt /etc/nginx/sites-available/default
```

Edit the file with `nano` and replace:

- the server name
- the port that your express app normally listens at (if not port 3000)

In `nano`, press the following keyboard shortcuts to save and exit:

- Ctrl X
- Y
- Enter


#### Test the configuration

```sh
sudo ngninx -t
```

If it says that everything's OK, then run:

```sh
sudo service nginx restart
```

### Run the PostgreSQL installation script

```sh
curl -O "https://raw.githubusercontent.com/radishmouse/deployment-guide/master/setup-psql.sh"
chmod +x setup-psql.sh
./setup-psql.sh
```

#### Create the database that you'll use with your live express app

```sh
createdb name-of-your-db
```

### Clone your Express app

#### Generate an SSH key
Generate an ssh key pair so your server can identify itself to GitHub. (Skip this step if you already generated keys previously. Check with `ls -la .ssh` to see if there are any files like "id_somethingsomething.pub")

```sh
ssh-keygen -t ed25519
```

Press enter through all of the prompts.

Then print the public key to the terminal:

```sh
cat .ssh/id_ed25519.pub
```

Copy this line.

#### Add the SSH key to your GitHub profile

Go to GitHub.com in your browser.

Click your profile in the upper right and click "Settings" from the menu.

On the left hand menu, choose "SSH and GPG keys"

In the upper right, click "New SSH key"

- Provide a Title (e.g., "AWS EC2 instance")
- Paste into the "Key" field
- Click "Add SSH key"

#### Clone the code to the AWS server

Go to your project page and click the "Code" button.

Make sure to choose "SSH" for the kind of clone address

Copy the clone address

In the terminal (logged into AWS), `git clone` your project

#### Install dependencies

```sh
npm install
```

#### Create a .env file

- fill out the DB_NAME (using the database name you created with `createdb` after installing PostgreSQL)
- add a SESSION_SECRET (if your app uses sessions) - this can be random letters and numbers


#### Run any migrations or seeders for your app

```sh
npx sequelize db:migrate
npx sequelize db:seed:all
```

#### Try running your application

```sh
npm run dev
```

(Or `node index.js` if you're not using nodemon)

In your browser, go to your IPv4 Public Address. 

You should see your Express app running!


### Run your app with `pm2`

Make sure you have `pm2` by running `which pm2`.

If you don't have it, run `npm install -g pm2` (to install it globally).

Start your app with `pm2`:

```sh
pm2 start index.js --name MyAwesomeProject
```

(Customize the `--name` so that you can tell which app is which when you run multiple Express apps on this server)

Tell `pm2` that you want to run this app when the server starts:

```sh
pm2 startup
```

This will print a very long line that begins with `sudo`. Copy this line and paste it into the terminal.

Tell `pm2` to save its current configuration:

```sh
pm2 save
```

### Install and run certbot

```sh
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --nginx
```

You will be prompted for:

- your email (so that you can receive alerts)
- terms of service (say "Y" for yes)
- if you want to receive emails from them ("N" for no)
- what domains to install a certificate for (press "Enter" to accept any/all)


After it finishes, you should be able to visit your domain in the browser and it should be protected by an SSL certificate. (Look for the lock icon in the URL bar.)

### Celebrate

:tada: You're awesome :tada:

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
