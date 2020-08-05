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


