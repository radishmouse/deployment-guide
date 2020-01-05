# Deploying a Node.js Project

Follow these steps for each Node.js project you want to deploy.

## Clone your project

Go to the github page for one of your Node.js repos.

Click the "Clone" button and make sure it shows "Clone with SSH"

![](/images/30.clone-with-ssh.png)

On your EC2 instance, clone your project. Since this is the first time the server is communicating with github.com, it will prompt you for permission. Type "yes":

![](/images/31-clone-project.png)

`cd` into your project directory.


### Install dependencies

Install any dependencies for your Node.js project:

```sh
npm install
```

![](/images/32-npm-install.png)

### Manually run project

First, you'll want to make sure you can run your Node.js application at all. This will not make it accessible in a browser, but it will show you if there are any errors (like missing dependencies).

```sh
node index.js
```

## `nginx` configuration

## Edit the `nginx` configuration file

Use this command to edit the `nginx` configuration file:

```sh
sudo nano /etc/nginx/sites-available/default
```

The nano text editor will show you the contents of the file:

![](/images/33-nginx-1.png)


### Find the `server` block

Use the arrow keys to scroll down in the file.

Scroll until you see the `server` block. 

![](/images/34-nginx-2.png)

Continue scrolling until you find the next section of uncomment lines.

### Comment out unneeded lines

Using the `#` symbol, you will comment out three lines:

- the line starting with the word "root"
- the line starting with the word "index"
- the line starting with "try_files"

![](/images/35-nginx-3.png)

### Add the connection to your Node.js application:

Inside the `location` block, add a `proxy_pass` directive:

```
proxy_pass http://localhost:3000;
```

![](/images/36-nginx-4.png)

### Save the file and exit

Nano expects keyboard commands to save and exit:

- Press `Ctrl+X`
- Press `Y`
- Press `Enter`

![](/images/37-nano-save.png)

You should be back in the bash prompt.

## Test the configuration file

Make sure the configuration is readable by `nginx`:

```sh
sudo nginx -t
```

It should report that the syntax is ok.

![](/images/38-nginx-test.png)

## Restart the `nginx` service

Use the following command to restart `nginx` (which makes it reload its configuration file):

```sh
sudo service nginx restart
```

![](/images/39-nginx-restart.png)

If all goes well, there should be no output.

You're almost there!

## Make your Node.js project run automatically

To make sure that your Node.js program runs without you having to log in to start it, you'll use the `pm2` program to do that for you.


### Run your project code with `pm2`

Use `pm2` to start your code. You will provide a name (with no spaces) so that you can tell your Node.js apps apart in `pm2`'s list of projects:


```sh
pm2 start index.js --name my-project-name
```

You should see a table showing the status of your Node.js program.

![](/images/40-pm2-process-list.png)


### Get startup command

The last steps are to make sure that `pm2` runs your project when the server starts.

Run the following command to get a startup command:

```sh
pm2 startup
```

It will print out a command that you will copy and paste:

![](/images/44-pm2-startup2.png)

### Save process list

Run the following command to save the startup list:

```sh
pm2 save
```

![](/images/45-pm2-save.png)

## Confirm `pm2` and `nginx` configuration

In the AWS console, get the public address of your EC2 server:

![](/images/41-copy-public-address.png)

Paste the address into your browser. You should see that your Node.js application is running:

![](/images/46-success.png)

### Reboot

To make absolutely sure that everything is working, reboot the server:

```sh
sudo reboot
```

Then, wait a minute or two.

### Reload the web page

At this point you should be able to reload your web page and see that your Node.js program is (still) running.


