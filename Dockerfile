FROM debian:jessie

LABEL maintainer "opsxcq@strm.sh"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl gcc gnupg python python-pip python-crypto \
    python-gst-1.0 \
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools && \
    curl -L https://apt.mopidy.com/mopidy.gpg | apt-key add - && \
    curl -L https://apt.mopidy.com/mopidy.list -o /etc/apt/sources.list.d/mopidy.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mopidy mopidy-soundcloud mopidy-spotify

RUN curl -L https://bootstrap.pypa.io/get-pip.py | python - && \
    pip install -U six && \
    pip install \
        Mopidy-Iris \
        Mopidy-GMusic \
        pyasn1 \
        Mopidy-YouTube \
        Mopidy-Spotify \
        cffi \
        Mopidy-TuneIn \
        Mopidy-BeetsLocal \
        Mopidy-Local-Images


# Install beets to be used as a backend for mopidy
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget curl locales \
    python2.7-dev python-pip python-virtualenv libffi-dev libssl-dev \
    beets \
    imagemagick \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Setup beets configuration and plugins
RUN pip install discogs-client pyechonest pylast \
                python-mpd beets discogs-client \
                pyechonest pylast \
                pyOpenSSL ndg-httpsclient pyasn1

# Aditional modules for beets plugins
RUN pip install beautifulsoup4 BeautifulSoup

# Install extra plugins for beets
COPY beets-plugins/* /usr/local/lib/python2.7/dist-packages/beetsplug/

# Install extra plugins for mopidy
COPY mopidy-beets/* /usr/local/lib/python2.7/dist-packages/mopidy_beetslocal/

# User configuration
RUN useradd --system --uid 666 -M --shell /usr/sbin/nologin music && \
    mkdir -p /home/music/.config/mopidy/ && \
    mkdir -p /home/music/.config/beets/ && \
    mkdir /output /music

COPY mopidy.conf /home/music/.config/mopidy/mopidy.conf
COPY beets.yaml /home/music/.config/beets/config.yaml
RUN chown -R music:music /home/music /output /music

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Runtime configuration
USER music

EXPOSE 6680
EXPOSE 6600

VOLUME /music
VOLUME /downloaded
WORKDIR /music

ENTRYPOINT ["mopidy"]
