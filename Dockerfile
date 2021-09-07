FROM lsiobase/alpine:3.14
LABEL org.opencontainers.image.description "Docker image of jrudess' StreamDVR app."

ARG HEALTHCHECKS_ID

ENV STREAMDVR_VERSION=0.14 \
    YOUTUBEDL_VERSION=2021.06.06 \
    STREAMLINK_VERSION=2.4.0 \
    YT_DLP_VERSION=2021.09.02 \
    HOME="/app/.home"

RUN \
 echo "**** install dependencies ****" && \
 apk add --no-cache \
	curl \
	nodejs-current \
	npm \
	python3 \ 
	py3-pip \
	py3-setuptools \
	ca-certificates \
	bash \
	git \
	build-base \
	libgomp \
	ffmpeg && \
 echo "**** install packages ****" && \
 	pip3 install youtube-dl==${YOUTUBEDL_VERSION} streamlink==${STREAMLINK_VERSION} yt-dlp==${YT_DLP_VERSION} && \
	git clone https://github.com/back-to/generic.git /tmp/generic && \
  mkdir -p /app/.home/.local/share/streamlink/ && \
  mv /tmp/generic/plugins /app/.home/.local/share/streamlink/ && \
 echo "**** install streamdvr ****" && \
  wget -qO- https://github.com/jrudess/streamdvr/archive/v${STREAMDVR_VERSION}.tar.gz | tar -xvz -C /tmp && \
  mv /tmp/streamdvr-${STREAMDVR_VERSION}/* /app/ && cd /app && \ 
	npm ci --only=production && \
 echo "**** cleaning up ****" && \
	npm cache clean --force && \
  apk del git build-base && \
  rm -rf /tmp/*

COPY /root /

WORKDIR /app

VOLUME /app/config /app/capturing /app/captured

HEALTHCHECK --interval=300s --timeout=15s --start-period=10s \
            CMD curl -L https://hc-ping.com/${HEALTHCHECKS_ID}
