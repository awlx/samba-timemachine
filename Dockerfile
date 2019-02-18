FROM alpine:latest

RUN apk add --update \
    samba-common-tools \
    samba-server \
    shadow \
    bash \
    && rm -rf /var/cache/apk/*

ADD samba.conf /etc/samba/smb.conf
RUN /usr/bin/testparm -s

EXPOSE 445/tcp
ENV BACKUPDIR /backups

ADD entrypoint /entrypoint
RUN chmod 0755 /entrypoint

ENTRYPOINT ["/entrypoint"]
