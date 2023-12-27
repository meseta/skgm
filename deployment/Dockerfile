FROM meseta/gmrunner_base:v1.2.0

WORKDIR /root
COPY skgm.AppImage entrypoint.sh ./
RUN chmod +x skgm.AppImage entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["./skgm.AppImage", "--appimage-extract-and-run"]
