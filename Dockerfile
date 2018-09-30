FROM debian:experimental

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --yes install \
        samba=2:4.9.1+dfsg-1 \
        samba-vfs-modules=2:4.9.1+dfsg-1 \
	samba-common-bin=2:4.9.1+dfsg-1 \
	samba-common=2:4.9.1+dfsg-1 \
	samba-libs=2:4.9.1+dfsg-1 \
	libwbclient0=2:4.9.1+dfsg-1 \
	python-samba=2:4.9.1+dfsg-1 \
    && rm -rf /var/lib/apt/lists/*

ADD samba.conf /etc/samba/smb.conf
RUN /usr/bin/testparm -s

EXPOSE 445/tcp
ENV BACKUPDIR /backups

ADD entrypoint /entrypoint
RUN chmod 0755 /entrypoint

ENTRYPOINT ["/entrypoint"]
