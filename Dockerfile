FROM debian:jessie

LABEL maintainer "opsxcq@strm.sh"

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl gcc gnupg python python-pip python-crypto \
    python-gst-1.0 gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools && \
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
        Mopidy-Notifier \
        Mopidy-TuneIn \
        Mopidy-Plex \
        Mopidy-BeetsLocal \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --system --uid 666 -M --shell /usr/sbin/nologin music && \
    mkdir -p /home/music/.config/mopidy/ && \
    mkdir /output

COPY mopidy.conf /home/music/.config/mopidy/mopidy.conf

RUN chown -R music:music /home/music /output

USER music

EXPOSE 6680
EXPOSE 6600

VOLUME /music
VOLUME /downloaded

ENTRYPOINT ["mopidy"]
