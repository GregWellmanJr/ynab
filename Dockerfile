FROM ubuntu:16.04

MAINTAINER Joe Phillips "phillijw@gmail.com"

# Let apt know that we will be running non-interactively.
ENV DEBIAN_FRONTEND noninteractive

# Install wget
RUN apt-get update; apt-get install -y wget

# Install apt-add-repository
RUN apt-get install -y software-properties-common python-software-properties apt-transport-https

# Setup i386 architecture
RUN dpkg --add-architecture i386; \
    wget -nc https://dl.winehq.org/wine-builds/Release.key; \
    apt-key add Release.key; \
    apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/

# Get the latest WINE
RUN apt-get update; apt-get install -y winehq-stable

# Set the locale and timezone.
RUN apt-get update; apt-get install -y locales tzdata
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN echo "America/Chicago" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Create a user inside the container, what has the same UID as your
# user on the host system, to permit X11 socket sharing / GUI Your ID
# is probably 1000, but you can find out by typing `id` at a terminal.
RUN apt-get update; apt-get install -y sudo
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/docker && \
    echo "docker:x:${uid}:${gid}:Docker,,,:/home/docker:/bin/bash" >> /etc/passwd && \
    echo "docker:x:${uid}:" >> /etc/group && \
    echo "docker ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/docker && \
    chmod 0440 /etc/sudoers.d/docker && \
    chown ${uid}:${gid} -R /home/docker

ENV HOME /home/docker
WORKDIR /home/docker

# Add the ynab installer to the image.
ADD ["http://www.youneedabudget.com/CDNOrigin/download/ynab4/liveCaptive/Win/YNAB%204_4.3.729_Setup.exe", "ynab_setup.exe"]

# When it is added via the dockerfile it is owned read+write only by root
RUN chown docker:docker ynab_setup.exe

USER docker
