# samba-timemachine-docker

This is a docker container that contains SAMBA and is configured to provide Apple "Time Capsule" like backups.

To use the docker container do the following (it uses the mountpoint /backups to store your backups):

```
docker pull awlnx/samba-timemachine
docker run -d -t \
    -v /backups/timemachine:/backups:z \
    -p 10445:445 \
    --name timemachine \
    --restart unless-stopped awlnx/samba-timemachine 
```

Note that due to the use of port 10445 this container can be run along side a normal SAMBA service.

There is a single user called `timemachine` with a random password generated at startup (you see it with `docker logs timemachine`). By default USERID and GROUPID are set to 1311 which maybe conflicts with your running system. The default name of the share is "Data."

Set the environment variables USER, USERID, GROUPID, PASS,  AND/OR SHARENAME to override. A quota for each computer's backup can be set, in MB, with the TMSIZE environment variable.

```
docker run -d -t  \
    -e USER=test \
    -e PASS=test123 \
    -e USERID=1000 \
    -e GROUPID=1000 \
    -e SHARENAME=myshare \
    -e TMSIZE=1024000 \
    -v /backups:/backups:z \
    -p 10445:445 \
    --name timemachine \
    --restart unless-stopped awlnx/samba-timemachine
```

The container only runs smbd to find it on the network the best way is avahi (mDNS) there is an example service file included. This can be copied to /etc/avahi/services/timemachine.service or run in a container.

Make sure to change the name of the share in the timemachine.service file to the same as yourh SHARENAME:
e.g. change "Data" to "myshare":

```
	<txt-record>dk0=adVN=Data,adVF=0x82</txt-record>
```

Further information about the share name and flags can be found here (https://openwrt.org/docs/guide-user/services/nas/netatalk_configuration#zeroconf_advertising) and here (http://netatalk.sourceforge.net/wiki/index.php/Bonjour_record_adisk_adVF_values)

You can find the Repo on Github (https://github.com/awlx/samba-timemachine)

This thing was inspired by https://hub.docker.com/r/timjdfletcher/samba-timemachine/
