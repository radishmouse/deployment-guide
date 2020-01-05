# Creating an EC2 instance

Go to https://aws.amazon.com/console/

Click the "My Account" menu in the upper right and choose "AWS Management Console":

![](/images/01-aws-home-page.png)

Log in using the email and password for your account:

![](/images/02-aws-login-page.png)

You will be taken to the management console landing page:

![](/images/03-aws-mgmt-console.png)

Click the "Services" menu in the upper left. A list of the many AWS services will appear.

Click "EC2" (in the upper left of the services list):

![](/images/04-aws-services.png)

You will be taken to the EC2 management page:

![](/images/05-ec2-home-page.png)

## Launch a new instance

Scroll down on the EC2 management page and find the "Launch instance" button:

![](/images/06-ec2-launch-button-1.png)

Choose the "Launch instance" option from the dropdown

![](/images/07-ec2-launch-button-2.png)

You will see a list of Operating System images that can be installed. Scroll until you see "Ubuntu Server 18.04LTS" 

![](/images/08-ec2-image-list.png)

Click the "Select" button on the far right.

On the next page, click the "Review and Launch" button in the lower right.

![](/images/09-e2c-instance-type.png)

(Leave the selection on "Free tier eligible")

You will be taken to a summary of options for your instance.


### Customize the Security group

Scroll down until you see the section labeled "Security Groups":

![](/images/10-ec2-review.png)

Click the "Edit security groups" link on the right.

On this page, click the "Add Rule" button on the left, just below the table.

![](/images/11-ec2-configure-security-group.png)

After clicking "Add Rule", and empty rule will be added to the table:

![](/images/12-ec2-add-security-group.png)

Click the button labeled "Custom TCP" and choose "HTTP" from the dropdown menu:

![](/images/13-ec2-http-security-rule.png)

Then, click the "Review and Launch" button in the lower right.

You will be taken to the review page again:

![](/images/14-review-launch.png)

Click the "Launch" button in the lower right.

## Create and download the access key

You should be prompted to "Select an existing key pair or create a new key pair".

Choose "Create a new key pair" from the menu.

![](/images/15-keypair.png)

Give it a name like "ec2-20200105" - that is, name it with the service you're accessing and the current date. (You may end up creating and managing multiple servers, and you'll want to be able know which keys go with which server.)

Then *make sure* you click the "Download Key Pair".

Then, click the "Launch" button.

You should see that your server launch is pending:

![](/images/16-launched-pending.png). 

Click the link to the ID of your instance.

You will be taken to the list of running instances:

![](/images/17-instance-list.png)

## Connect to your instance via `ssh`

You will need to connect to your instance using SSH.

### Move the `.pem` keyfile and change the permissions

Move the keys from your downloads folder to your `~/.ssh` directory on your computer:

```sh
mv ~/Downloads/*.pem ~/.ssh
```

Restrict the permissions so that they can be used securely:

```sh
chmod 600 ~/.ssh/*.pem
```

### (Optional) Create an alias

Edit your bash startup file (either `~/.bashrc` or `~/.bash_profile` ).

In the AWS instance listing, click the "Connect" button to get the connection command:

![](/images/18-connect-to-instance.png)

Copy this connection command and paste into your bash startup file.

Edit the line so that it follows this format:

```sh
alias ec2="ssh -i ~/.ssh/ec-20200105.pem ubuntu@ec2-18-221-108-104.us-east-2.compute.amazonaws.com"
```

Specifically:

- remove the quotes from the name of the `.pem` file
- provide an absolute path to the `.pem` file
- put the command in a string by wrapping it in quotes
- set the string to an alias, such as `ec2`

![](/images/19-setting-alias.png)

Save your bash startup file, close your terminal tab/window, and open a new one.


### Connect for the first time

In the terminal, run the connection command (either by typing it out or by using the alias you created).

It should ask you if you want to continue connecting. Type `"yes"` and press enter.

![](/images/20-first-ssh-connection.png)

Upon successful login, you should see a prompt showing that you are the `ubuntu` user on the EC2 server:

![](/images/21-first-login.png)

## Update the system

The first task when setting up a Linux server is to update the system software.

Run the following command to do that:

```sh
sudo apt update && sudo apt upgrade -y
```

![](/images/22-system-update.png)

You may be prompted to update certain configuration files or keep the existing ones.

You should press the `Enter` key to keep the existing ones.

After the upgrade finishes, reboot the system:

```sh
sudo reboot
```

After a couple of minutes, log back in using the connection command or by typing your alias.

# Software installation

Your server is capable of running many Node.js applications.

You will need three pieces of software:

- `nvm` will install Node.js
- `pm2` will run your Node.js applications automatically
- `nginx` will make sure that you can run more than one Node.js application

## Install `nvm`

Use this command to install `nvm`:

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
```

Either log out and log back in, or copy and paste the shell commands output after installing `nvm`.


### Install LTS version of Node.js

To install the latest stable version of Node.js, run this command:

```sh
nvm install --lts
```


## Install `pm2`

`pm2` is a Node.js program. You can install it globally like so:

```sh
npm install -g pm2
```

## Install `nginx`

Install `nginx` using the `apt` command:

```sh
sudo apt install nginx
```
# Create SSH Keys for communicating with Github

In order for you to access code on your github account, it is best to create SSH keys (as you did with your laptop).

## Generate `ssh` keys

Run this command to generate a new key. Press `Enter` when prompted. (Do not change the file paths and do not enter a passphrase.)

```sh
ssh-keygen -t ed25519
```

![](/images/23-ssh-keygen.png)

## Add keys to Github

### Get the public key from the EC2 server

To retrieve the key, run the following command in the terminal that is logged into your EC2 instance:

```sh
cat ~/.ssh/id_ed25519.pub
```

![](/images/24-ssh-keygen-2.png)

Copy the output (which you'll paste into github in the next step).

![](/images/25-ssh-keygen-3.png)


### Create a new key on github

Click your profile icon in the upper right, then choose the "Settings" menu item:

![](/images/26-add-key-github-1.png)

On the left hand menu, find the "SSH and GPG keys" link:

![](/images/27-add-key-github-2.png)

You will be taken to a listing of SSH keys associated with your account. Click the "New SSH key" button in the upper right:

![](/images/28-add-key-github-3.png)

Enter a title for your key (using the same name as the key itself) and paste in the public key you copied from the terminal:

![](/images/29-add-key-github-4.png)


Now, you can clone and run Node.js applications on your server.
