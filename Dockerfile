FROM debian:latest
ENV ts3_version=3.0.12.3
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qqy bzip2 wget && \
    apt-get clean && \
    rm -rf /var/lib/apt

WORKDIR /opt
RUN wget --progress=dot -e dotbytes=50K http://dl.4players.de/ts/releases/${ts3_version}/teamspeak3-server_linux_amd64-${ts3_version}.tar.bz2 2>&1 |grep --line-buffered -o "[0-9]*%" |xargs -L1 echo -e "fetching TS3 server ${ts3_version}:"
RUN tar xjf teamspeak3-server_linux_amd64-${ts3_version}.tar.bz2 && rm teamspeak3-server_linux_amd64-${ts3_version}.tar.bz2

WORKDIR /opt/teamspeak3-server_linux_amd64
RUN ln -s /data/logs logs
RUN ln -s /data/files files
RUN ln -s /data/ts3server.sqlitedb ts3server.sqlitedb
RUN ln -s /data/query_ip_whitelist.txt query_ip_whitelist.txt
RUN ln -s /data/query_ip_blacklist.txt query_ip_blacklist.txt
CMD ["/opt/teamspeak3-server_linux_amd64/ts3server_minimal_runscript.sh", "inifile=/data/ts3server.ini"]
