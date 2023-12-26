FROM meseta/gmrunner_base:v1.1.0

WORKDIR /workdir
COPY skgm.AppImage .
RUN chmod +x skgm.AppImage

EXPOSE 5000

CMD ["./skgm.AppImage", "--appimage-extract-and-run"]
