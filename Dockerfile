FROM abh1nav/java7

MAINTAINER Abhinav Ajgaonkar <abhinav316@gmail.com>

RUN apt-get update && \
    apt-get -qy install sysstat && \
    apt-get clean

# Download and extract Cassandra
RUN \
  mkdir /opt/cassandra; \
  wget -O - http://www.us.apache.org/dist/cassandra/2.1.3/apache-cassandra-2.1.3-bin.tar.gz \
  | tar xzf - --strip-components=1 -C "/opt/cassandra";

# Download and extract DataStax OpsCenter Agent
RUN \
  mkdir /opt/agent; \
  wget -O - http://downloads.datastax.com/community/datastax-agent-5.1.0.tar.gz \
  | tar xzf - --strip-components=1 -C "/opt/agent";

ADD	. /src

# Copy over daemons
RUN	\
	cp /src/cassandra.yaml /opt/cassandra/conf/; \
    mkdir -p /etc/service/cassandra; \
    cp /src/cassandra-run /etc/service/cassandra/run; \
    mkdir -p /etc/service/agent; \
    cp /src/agent-run /etc/service/agent/run

# Expose ports
# JMX, transport, secure transport, thrift, client, OpsCenter agent
EXPOSE 7199 7000 7001 9160 9042 61621

WORKDIR /opt/cassandra

CMD ["/sbin/my_init"]

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
