
# One repo or two?

I recommend two repos, but cloned inside a single (non-git) directory, like so:

```
capstone-project
  /backend
    /.git
    index.js
    package.json
    README.md
  /front-end
    /.git
    /public
    /src
    package.json
    README.md
```

Note that only `capstone-project` does not have a `.git` folder, meaning it isn't a git repo.


You'll run your React dev server and your express server separately, at the same time.

# Testing with `ngrok`

`ngrok` is a free program that gives you a publicly accessible address that points to your local computer.

- Sign up (via github) for an account and download it from https://ngrok.com/download
- Unzip it and copy it from Downloads to your `/usr/local/bin` directory
  - `sudo cp ~/Downloads/ngrok /usr/local/bin`
  - `sudo chmod +x /usr/local/bin/ngrok`
- Run it to provide a public URL you can access from your phone (or another computer) `ngrok http 3000`

Example uses:

- testing your front-end on your phone without deploying 
- connecting your front-end (running on your machine) to your team member's backend (running on their machine)

# React

## Front-end static files (images)

These go in the `/public` folder.

Example: if you have `/public/images/logo.png`, your JSX would have this:

```
<img src="/images/logo.png" />
```

## Proxy Ajax requests to the backend

Add this line to your `package.json`:

```
proxy: 'http://localhost:4000'
```

(Obviously, change the port number to match the one your backend is listening on.)


Your API calls should look like this:

```
const todos = await axios({
  url: '/api/todos'
}).then(r => r.data);
```

After modifying `package.json`, you have to stop the react dev server and start it again.
After that, create-react-app dev server will proxy the Ajax call to/from your backend.

## Proxying to another machine

You can combine this with using `ngrok` if you want your React app to send Ajax requests to a teammate's backend (and they're not on the same network as you).

```
proxy: 'https://6014d41c.ngrok.io'
```

# Express

## Put all your secret info in `.env`

- API keys
- ports
- session secret

### Create a `.env.dist` that lists out all the keys

And it should be part of your repo.

### How do I get the `.env` values onto the server?

Copy from VS Code on your machine an paste into nano on the server:

```
ec2
cd capstone-backend
nano .env
```

## Prefix your Express API

- put `/api` at the beginning of each your route paths
- Or: use an `express.Router` and give it the `/api` prefix

## Set up express to serve static files

Use the static middleware:

```
app.use(express.static('public'));
```

Add this as the *last* route of your app (or `express.Router`):

```
// Handles any requests that don't match previous ones
app.get('*', (req,res) =>{
    res.sendFile(path.join(__dirname + '/public/index.html'));
});
```

### Alternatively, set up `nginx` to serve the contents of `public` for you.




# Deploying

## Build the React app (on your machine, *not on EC2*)

```
npm run build
```

## Copy the `build` directory to your express app's `public` folder

```
cp -R build/* ../backend/public
```

## Or: just modify the `package.json`

```
  "scripts": {
    "build:prod": "npm run build && cp -R build/* ../backend/public",
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test --env=jsdom",
    "eject": "react-scripts eject"
  }
```


## Add and commit the changes to the backend

```
cd ../backend
git add public
git commit -am "adds the production version of react front-end"
git push
```

## If deploying for the first time

Follow the guide on deploying a Node.js app. When you start it with `pm2`, make sure to specify a port

```
git clone capstone-backend
cd capstone-backend
PORT=3456 pm2 start index.js --name my-capstone-app
```

## If updating 

Pull down the changes on the EC2 server and restart `pm2`

```
cd capstone-backend
git pull
pm2 restart my-capstone-app
```

## Debugging express

### Try running it by hand and watch the console

```
pm2 stop my-capstone-app
PORT=3456 node index.js
```

### Or: leave it running and watch the logs

```
pm2 logs
```
