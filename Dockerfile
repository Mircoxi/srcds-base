FROM debian:bookworm-slim

# Set environment variables
ENV DOTNET_VERSION=7.0.11
ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH="$DOTNET_ROOT:$PATH"

RUN set -x \
    # Add x86 architecture or srcds won't work.
    && dpkg --add-architecture i386  \
    # Update
    && apt-get update  \
    # Do a full upgrade of all packages
    && apt-get full-upgrade \
    # Install required dependencies for srcds, spcomp, and getting .NET
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    lib32z1 \
    lib32gcc-s1 \
    libncurses5:i386 \
    libbz2-1.0:i386 \
    libtinfo5:i386 \
    libcurl3-gnutls:i386 \
    libstdc++6:i386 \
    libcurl4-gnutls-dev:i386 \
    libtcmalloc-minimal4:i386 \
    libc6:i386 \
    unzip \
    # Add srcds user and such
    && useradd -ms /bin/bash -u 1000 srcds

# Retrieve .NET Runtime
RUN dotnet_version=7.0.11 \
    && curl -fSL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$dotnet_version/dotnet-runtime-$dotnet_version-linux-x64.tar.gz \
    && dotnet_sha512='110db17f1bc9e5577488e7f5425c6c639851af68c8d7dd17b0616469755c27d3c8a78ab01aaab13ed4849c676230bfeef9113f1dc4cda34c5be7aa1d199e7d57' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p $DOTNET_ROOT \
    && tar -oxzf dotnet.tar.gz -C $DOTNET_ROOT \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Verify the installation
#RUN dotnet --info

# Get DepotDownloader
RUN wget https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_2.5.0/DepotDownloader-linux-x64.zip \
    && mkdir /usr/share/depotdownloader \
    && unzip DepotDownloader-linux-x64.zip -d /usr/share/depotdownloader \
    && ln -s /usr/share/depotdownloader/DepotDownloader /usr/bin/depotdownloader \
    && chmod +x /usr/bin/depotdownloader \
    && rm DepotDownloader-linux-x64.zip

#RUN depotdownloader
# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


LABEL \
  maintainer="Jess Stingray <jess@mircoxi.com>" \
  org.opencontainers.image.title="SRCDS Base" \
  org.opencontainers.image.description="Base srcds image" \
  org.opencontainers.image.vendor="Mircoxi" \
  org.opencontainers.image.authors="Jess Stingray <jess@mircoxi.com>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.url="https://mircoxi.com/" \
  org.opencontainers.image.source="https://github.com/Mircoxi/srcds-base/" \
  org.opencontainers.image.documentation="https://github.com/Mircoxi/srcds-base/blob/main/README.md" \
  org.opencontainers.image.revision="master" \
  org.opencontainers.image.version="latest"
