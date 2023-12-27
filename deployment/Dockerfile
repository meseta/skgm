FROM meseta/gmrunner_base:v1.1.0

WORKDIR /workdir
COPY skgm.AppImage entrypoint.sh ./
RUN chmod +x skgm.AppImage entrypoint.sh

EXPOSE 5000

CMD ["./skgm.AppImage", "--appimage-extract-and-run"]
