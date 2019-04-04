# README

Build the docker container:

`docker build -t YOUR-CONTAINER-NAME https://raw.github.com/GregWellmanJr/ynab/master/Dockerfile`

## FAQ

### Wine cannot start x?

This seems to be a permissions issue on latest versions of Ubuntu, try:

`xhost +`
