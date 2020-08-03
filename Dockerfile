FROM ubuntu:20.04

ENV TIMEZONE=America/New_York \
    DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y python3-pip software-properties-common supervisor unzip curl xvfb wget rsync net-tools && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y wine64 wine32 lib32gcc1 && \
    pip3 install python-valve && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install winetricks
ADD https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks /usr/bin/winetricks
RUN chmod +x /usr/bin/winetricks

RUN apt update \
    && apt install -y x11vnc strace cabextract \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . ./

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
    && echo $TIMEZONE > /etc/timezone \
    && chmod +x /entrypoint.sh \
    && cd /usr/bin/ \
    && chmod +x astroneer_controller steamcmd_setup

EXPOSE 8777

VOLUME ["/astroneer"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord"]