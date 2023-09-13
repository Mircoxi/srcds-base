# Mircoxi's SRCDS Base

This is a simple base image to build upon for SRCDS based games.

The containers are based on Debian Bookworm. [DepotDownloader](https://github.com/SteamRE/DepotDownloader) is included 
to download the server you want, and a `srcds` user has been created to run them. .NET 7.0 is included to be able to 
run DepotDownloader, and all i386 dependencies for srcds are preinstalled. 

The directory `home/srcds/sourcemod` contains the latest builds of MetaMod and SourceMod, at image build time. This can
be copied into the folder of whatever game you intend to install after running `depotdownloader`. This is unconfigured,
and you'll need to add your own plugins and admin definitions. 

### Usage

Simply use the latest image as a base in your Dockerfile. Example:

```dockerfile
FROM ghcr.io/mircoxi/srcds-base:latest

USER srcds

RUN depotdownloader -app 232250 -os linux -osarch 32 -max-downloads 8 -dir ~/tf2
RUN mv ~/sourcemod/* ~/tf2/
```

The Dockerfiles for pre-built images are below.

### Pre-built images

I've pre-made images for the following games, that you can use at your leisure. Just hit the link to go to the repo for
it and grab the image.

- Coming soon