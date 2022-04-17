FROM lsiobase/alpine:3.15
LABEL org.opencontainers.image.description "Docker image of jrudess' StreamDVR app."

ARG HEALTHCHECKS_ID

ENV YOUTUBEDL_VERSION=2021.12.17 \
    STREAMLINK_VERSION=3.2.0 \
    YT_DLP_VERSION=2022.04.08 \
    HOME="/app/.home"

RUN \
 echo "**** install dependencies ****" && \
 apk add --no-cache \
	curl \
	nodejs-current \
	npm \
	python3 \ 
	python3-dev \
	py3-pip \
	py3-setuptools \
	ca-certificates \
	bash \
	git \
	build-base \
	libgomp \
	libxslt-dev \
	libxml2-dev \
	dos2unix \
	ffmpeg

RUN \
 echo "**** install packages ****" && \
 	pip3 install youtube-dl==${YOUTUBEDL_VERSION} streamlink==${STREAMLINK_VERSION} yt-dlp==${YT_DLP_VERSION} && \
	git clone https://github.com/back-to/generic.git /tmp/generic && \
  	mkdir -p /app/.home/.local/share/streamlink/ && \
  	mv /tmp/generic/plugins /app/.home/.local/share/streamlink/

RUN \
 echo "**** install streamdvr ****" && \
  	git clone https://github.com/vyneer/streamdvr /tmp/streamdvr && \
  	mv /tmp/streamdvr/* /app/ && cd /app && \ 
	npm ci --only=production

RUN \
 echo "**** install the w3-upload script ****" && \
  	git clone https://github.com/vyneer/w3-upload /app/w3-upload && \
  	cd /app/w3-upload && npm ci --only=production

RUN \
 echo "**** cleaning up ****" && \
	npm cache clean --force && \
  	apk del git build-base && \
  	rm -rf /tmp/*

COPY /root /

RUN echo "**** converting crlf to lf just in case ****" && \ 
	dos2unix /etc/cont-init.d/30-base-config && \
	dos2unix /etc/services.d/streamdvr/run && \
	apk del dos2unix

WORKDIR /app

VOLUME /app/config /app/scripts/custom /app/capturing /app/captured

HEALTHCHECK --interval=300s --timeout=15s --start-period=10s \
            CMD curl -L https://hc-ping.com/${HEALTHCHECKS_ID}