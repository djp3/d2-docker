# d2-docker
This repository is designed to set up an OpenSimulator world with very little
configuration work.

## First things
We begin with a machine running Ubuntu 20.04 server edition.

`sudo apt install aptitude`

First step is to install docker.  Docker is a whole world.  You can learn about
it starting here: [Docker Get Started](https://docs.docker.com/get-started/).

`sudo aptitude install docker.io`

Confirm that it worked okay with

`docker --version`

which should reply with something like

`Docker version 19.03.8, build afacb8b7f0`

Whichever user you are logged in as needs to be added to the docker group.  For
me that is **djp3**, you should replace that with your username.

`sudo usermod -aG docker djp3`

Then you need to logout and login to your machine again to have that take
effect.

If everything is working then

`docker run hello-world`

should do some work that includes outputting *Hello from Docker!*

A more elaborate example:

`docker run -it ubuntu bash`

should give you a prompt in a docker container.  `exit` to quit it.

You can see all the images that you just created with

`docker ps -a`

You can clean everything up with:

`docker system prune -a`

Now I'm assuming that you have also cloned the [repository](https://github.com/djp3/d2-docker) that contains these instructions.

## Email setup

The installation assumes that you have an email account from which the server
can send out emails.  The best way to deal with this is to set up a gmail
account which will just be used for the server.  The server does not have the
highest level email security so creating a seperate burner account is advised.

Once you have it, then you need to create an app password for the server.

That can be done by using the browser interface to gmail and doing something
like:

Manage Account -> Security

and first turning on 2-factor authentication.  Once that is on you can do:

Manage Account -> Security -> Signing in to Google -> App Passwords

and create an app password for the OpenSimulator server.

## World set-up

Now you should edit the *.env* file in the repository to hold the values that
make sense to your installation.

A few notes on that.  In order to log in to your world it either needs a DNS
name or an ip address.  That goes in DP_EXTERNAL_NETWORK

That is for the computer network.  You world needs a name as well that is set by DP_WORLD_NAME

There are a handful of accounts:
1. The root user for the database.
	1. named "root"
	2. password is set by DP_DATABASE_ROOT_PASSWORD
2. A general user of the database.
	1. named "opensim"
	2. password is set by DP_DATABASE_USER_PASSWORD
3. An administrative user that sets up user accounts
	1. named "Wifi Admin"
	2. password is set by DP_WIFI_USER_PASSWORD
	3. needs an email. I recommend the burner email you created using a [plus sign](https://gizmodo.com/how-to-use-the-infinite-number-of-email-addresses-gmail-1609458192) and set by DP_WIFI_USER_EMAIL
4. A user that is the "owner" of the land in world
	1. Probably an actual user named DP_ESTATE_OWNER_FIRST DP_ESTATE_OWNER_LAST
	2. with password set by DP_ESTATE_OWNER_PASSWORD
	3. and email set by DP_ESTATE_OWNER_EMAIL

	   







