# d2-docker
This repository is designed to set up an OpenSimulator world with very little
configuration work.  It is based on the d2 distribution from [here](https://github.com/diva/d2/wiki/Installation).  With good ubuntu command-line skills you should be able to get it up and running in 20 minutes... most of which is waiting for mono to build and the world to be imported.

# tl;dr
### first time startup
1. Clone the repo
2. Edit .env
3. `docker-compose build` (maybe 10 min on the first run.)
4. `docker-compose up` (maybe 5 min without UC, 20 min with UC)
5. `docker exec -it <mono_docker_image> bash`
  1. `mono OpenSim.exe` (this remains running while the world is up)
6. connect with client viewer (e.g., Firestorm)

### shutdown
1. in the `mono OpenSim.exe` process `shutdown`
2. `docker-compose down`

### subsequent runs
1. `docker-compose up`
2. `docker exec -it <mono_docker_image> bash`
  1. `mono OpenSim.exe` (this remains running while the world is up)
3. connect with client viewer

# Not tl;dr
## First things
We begin with a machine running Ubuntu 20.04 server edition.

`sudo apt install aptitude curl`

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

Now [install docker-compose](https://docs.docker.com/compose/install/)

`sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`

`sudo chmod +x /usr/local/bin/docker-compose`

if it works then:

`docker-compose --version`

should yield something like

*docker-compose version 1.26.2, build eefe0d31*

More info on docker-compose can be found [here](https://docs.docker.com/compose/gettingstarted/)


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
5. Universal Campus
	1. A beautiful pre built world that makes set up take much longer on the first run, DP_UNIVERSAL_CAMPUS=true

## Build the world

From the root directory that contains the docker-compose.yml file run:

`docker-compose build --no-cache`

This will take several minutes as all the software is downloaded tested and
built. Roughly what it is doing is following the instructions for the diva/d2
installation located [here](https://github.com/diva/d2/wiki/Installation)
The longest part is a bunch of mono precompiling steps.  At the point at which I created the build there were 8 things mono precompiled.  After precompiling there is a test of the mono system ("Hello Mono World")

Then when that is complete, you can do the two-step launch process

Step 1.

`docker-compose up` (maybe 5 min without UC, 20 min with UC)

This launches 3 containers
1. An admin container for looking at the db ("adminer")
2. A database container ("db")
3. The mono container that runs OpenSim ("mono")

This takes a long time (~20 min) on the first run because it has to import the virtual campus.  Also because of the way OpenSim writes to the console, the output is all over the place and hard to read although the time stamps are usually legible.  Running a top process on the host machine will help to see that mono is, in fact, doing something (e.g., flushing the models to the database, compiling in world scripts).  When it is complete you should see `Launch Script Complete` but the container will not release control (intentionally) until the containers are such down.

Step 2.

Now that the system has been initialized you can start it up again such that it is ready to have participants.

You'll need to find the docker container running mono from a different terminal session on the host machine, to do that run:

`docker ps`

And look for the CONTAINER ID that has "mono" in the IMAGE name.  In my list it is the first CONTAINER ID listed.  It will be different each time the containers are spun up, but will look something like "b5568e5afcdf"  Use that ID to start a terminal in the mono container (replace "b5568e5afcdf" with your ID):

`docker exec -it b5568e5afcdf bash`

You should be in /root/diva-r09110/bin directory and can run:

`mono OpenSim.exe` 

First time startup you will have to wait for all the scripts to be started before clients can log in.  At the point that I built this there were 2014 scripts in the Universal Campus to start.  Clients can log in after you have gotten the feedback "LOGINS ENABLED".  This session will leave a prompt open to interact with the administrative interface of the world.

## Shutting down the world

To cleanly shutdown the world without losing the content, you need to first run

`shutdown`

in the OpenSim process

Once that is complete you can `exit` the container and then on the host machine run `docker-compose down` to shut everything down.  Next time you start with `docker-compose up` the system will be brought back up with the existing content and then you can enter the container and run `mono OpenSim.exe` to enable log ins.  Subsequent startups should take about 30 seconds until you see "LOGINS ENABLED"


## Manage the world

You might want to set the default avatars by gender. Info on that is [here](https://github.com/diva/d2/wiki/Wifi)

You might want to change the logos in universal Campus.  Info on that is [here](http://uc.onikenkon.com/instruction_manual_v1.2.pdf)


# References
or how I made this stuff work
## d2
1. The basics for installing the d2 distribution are [here](https://github.com/diva/d2/wiki/Installation)
2. the d2-distribution is [here](http://metaverseink.com/Downloads.html)
3. information on the account management system called "Wifi" is [here](https://github.com/diva/d2/wiki/Wifi)
## docker stuff
1. information on [docker-compose](https://docs.docker.com/compose/gettingstarted/)
## Open simulator
1. information on OpenSimulator [inventory archives](http://opensimulator.org/wiki/Inventory_Archives)
## Universal Campus
1. universal campus instructions parts are outdated, but start [here](http://universalcampus.igb.uci.edu/)
2. last updates to universal campus are at [oni kenkon creations](http://uc.onikenkon.com/)
  1. how to change the flags in universal campus [instructoins](http://uc.onikenkon.com/instruction_manual_v1.2.pdf)
3. Hints on how to load Universal Campus in latest OpenSim are [here](http://www.metaverseink.com/blog/d2/new-in-0-8-profiles-and-variable-sized-regions/)


# Resources
## opensim models
1. from [outworldz] (https://www.outworldz.com/)

	   







