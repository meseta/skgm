FROM meseta/gmrunner_base:v1.2.0

WORKDIR /root
COPY entrypoint.sh ./

RUN curl -L https://github.com/meseta/skgm/releases/download/v1.0.0/skgm.AppImage -o ./skgm.AppImage
RUN chmod +x skgm.AppImage entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["./skgm.AppImage", "--appimage-extract-and-run"]
