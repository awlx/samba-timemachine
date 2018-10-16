FROM debian:experimental

ENV SAMBA_VERSION "2:4.9.1+dfsg-1"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --yes install \
        samba="$SAMBA_VERSION" \
        samba-vfs-modules="$SAMBA_VERSION" \
	samba-common-bin="$SAMBA_VERSION" \
	samba-common="$SAMBA_VERSION" \
	samba-libs="$SAMBA_VERSION" \
	libwbclient0="$SAMBA_VERSION" \
	python-samba="$SAMBA_VERSION" \
    && rm -rf /var/lib/apt/lists/*

ADD samba.conf /etc/samba/smb.conf
RUN /usr/bin/testparm -s

EXPOSE 445/tcp
ENV BACKUPDIR /backups

ADD entrypoint /entrypoint
RUN chmod 0755 /entrypoint

ENTRYPOINT ["/entrypoint"]
