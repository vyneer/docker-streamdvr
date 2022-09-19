Docker image of jrudess' [StreamDVR](https://github.com/jrudess/streamdvr) app.
This is intended for vyneer.me Destiny vod archive thingy.
### Usage
```
docker run --name=streamdvr \
-v /path/to/scripts:/app/scripts/custom \
-v /path/to/config:/app/config \
-v /path/to/capturing:/app/capturing \
-v /path/to/captured:/app/captured \
-v /path/to/ipfs-db.db:/app/ipfs-db.db \
ghcr.io/vyneer/streamdvr:latest
```

### Docker Compose
```
version: "3"
services:
  streamdvr:
    container_name: streamdvr
    image: ghcr.io/vyneer/streamdvr:latest
    restart: on-failure
    volumes:
      - /path/to/scripts:/app/scripts/custom
      - /path/to/config:/app/config
      - /path/to/capturing:/app/capturing
      - /path/to/captured:/app/captured
      - /path/to/ipfs-db.db:/app/ipfs-db.db
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
```

### Notes
* This image was completely rewritten on May 3, 2021 to use LinuxServer.io's base image so that permissions properly work.
* If you want your changes to persist, include a copy of the config folder and bind mount it to the app at /app/config. 

### Changelog:
* **September 19th, 2022** Package updates: Alpine 3.16, yt-dlp 2022.09.01, streamlink 5.0.0.
* **April 18th, 2022** Package updates: Alpine 3.15, youtube-dl 2021.12.17, yt-dlp 2022.04.08, streamdvr (my fork, at least for now) gets pulled directly from GitHub. Add the ability to add custom scripts. Add the w3-upload script.
* **August 2nd, 2021** Package updates: StreamDVR v0.14, Alpine 3.14, youtube-dl 2021.06.06 & streamlink 2.3.0
* **May 3rd, 2021:** Rebase image to LinuxServer.io's Alpine image for customizable permissions.
* **November 24, 2020:** Upgrade packages: Alpine 3.12, youtube-dl 2020.11.24, streamlink 1.7.0. Added healthcheck via [healthchecks.io](https://healthchecks.io/).
* **January 22, 2020:** Upgrade to Alpine 3.11. Upgraded packages: ffmpeg 4.2.1, streamlink 1.3.0, youtube-dl 2020.01.15.
* **November 8, 2019:** Upgrade ffmpeg to 4.1.4; Upgrade node to v13;
* **May 22, 2019:** Upgrade ffmpeg to 4.1.3; Add tags for release/commit versions.
* **April 23, 2019:** Rebase to Alpine 3.9; Update StreamDVR version.
* **December 10, 2018:** Update ffmpeg to v4.0.
* **November 25, 2018:** Update dependencies, cleanup image.
* **October 30, 2018:** Initial release.
