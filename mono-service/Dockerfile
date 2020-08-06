FROM ubuntu

WORKDIR /root

#Reduce error messages on docker build
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

###################################
#Set up the repository to load mono
# See here https://www.mono-project.com/download/stable/#download-lin
#Allow packages to be found
RUN apt-get update -qq
#Reduce error messages on docker build and upgrade
RUN apt-get install apt-utils -qq

RUN apt-get upgrade -qq

#Utilities needed for docker installation to work 
#  gettext-base has envsubst
#  expect is used to handle the input to opensim
RUN apt-get install gettext-base expect wget unzip wait-for-it -qq

#Utilities djp3 needs temporarily in the image for debugging this Dockerfile 
RUN apt-get install vim tree -qq

#Things needed for key management
RUN apt-get install gnupg ca-certificates -qq

#Key needed to install mono 
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list

#Install mono with https ability
RUN apt-get install mono-devel ca-certificates-mono -qq

#Verify mono
COPY check-mono /root/check-mono 
RUN mono --version
RUN yes | certmgr -ssl smtps://smtp.gmail.com:465
RUN mono-csc check-mono/hello.cs
RUN mono check-mono/hello.exe
RUN csharp -e 'new System.Net.WebClient ().DownloadString ("https://www.nuget.org")' >> /dev/null


#Get ready to load and configure opensim
#RUN wget -q "http://metaverseink.com/download/diva-r09110.zip"
COPY "diva-r09110.zip" "diva-r09110.zip"
RUN unzip -q diva-r09110.zip 

#Download (or COPY) universal campus
COPY universal-campus /root/universal-campus
WORKDIR /root/universal-campus
#RUN wget -q -O universal_campus_01_0.7.3_03022012.oar http://uc.onikenkon.com/counter1/link_counter.php?url=../universal_campus_01_0.7.3_03022012.oar 
COPY "universal-campus/universal_campus_01_0.7.3_03022012.oar" "universal_campus_01_0.7.3_03022012.oar"
#RUN wget -q -O universal_campus_02_0.7.3_03022012.oar http://uc.onikenkon.com/counter1/link_counter.php?url=../universal_campus_02_0.7.3_03022012.oar
COPY "universal-campus/universal_campus_02_0.7.3_03022012.oar" "universal_campus_02_0.7.3_03022012.oar"
#RUN wget -q -O universal_campus_03_0.7.3_03022012.oar http://uc.onikenkon.com/counter1/link_counter.php?url=../universal_campus_03_0.7.3_03022012.oar
COPY "universal-campus/universal_campus_03_0.7.3_03022012.oar" "universal_campus_03_0.7.3_03022012.oar"
#RUN wget -q -O universal_campus_04_0.7.3_03022012.oar http://uc.onikenkon.com/counter1/link_counter.php?url=../universal_campus_04_0.7.3_03022012.oar
COPY "universal-campus/universal_campus_04_0.7.3_03022012.oar" "universal_campus_04_0.7.3_03022012.oar"

COPY "universal-campus/OSAvatarsSpring2011.iar" "OSAvatarsSpring2011.iar"
RUN cp *.oar /root/diva-r09110/bin
RUN cp *.iar /root/diva-r09110/bin/Library

#Set up for launching
COPY launch /root/launch

EXPOSE 9000/tcp
EXPOSE 9000/udp
EXPOSE 9001/udp
EXPOSE 9002/udp
EXPOSE 9003/udp

WORKDIR /root/launch
CMD ["/root/launch/launch.sh"]
#Just keep the container running for now
#CMD tail -f /dev/null
