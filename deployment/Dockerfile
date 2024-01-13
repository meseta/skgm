FROM meseta/gmrunner_base:v1.2.0

# Remove old entrypiont
RUN /root/entrypoint.sh

# copy new entrypoint
WORKDIR /usr/local/bin
COPY entrypoint.sh ./

# get SKGM
RUN curl -L https://github.com/meseta/skgm/releases/download/v1.1.1/skgm.AppImage -o ./skgm.AppImage
RUN chmod +x skgm.AppImage entrypoint.sh

# Add unpriviliged user
RUN groupadd --gid 1000 skgm && adduser --uid 1000 --gid 1000 --disabled-password --gecos "" skgm

USER skgm
RUN mkdir -p /home/skgm/.config/skgm
WORKDIR /home/skgm

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/bin/skgm.AppImage", "--appimage-extract-and-run"]
