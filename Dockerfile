FROM resin/rpi-raspbian

ENV DEBIAN_FRONTEND noninteractive
ENV WEBPASSWD changeme

RUN apt-get update && \
    apt-get install -yq pdns-server pdns-backend-sqlite3 && \
    apt-get clean && \
    apt-get -yq autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/powerdns/pdns.d/pdns.simplebind.conf

EXPOSE 53/udp 53/tcp 80

CMD /usr/sbin/pdns_server --daemon=no --allow-recursion=172.17.0.0/24 --disable-axfr=yes --local-address=0.0.0.0 --launch=gsqlite3 --webserver=yes --webserver-address=0.0.0.0 --webserver-port=80 --webserver-password=${WEBPASSWD} --experimental-json-interface --experimental-api-key=${WEBPASSWD} "$@"
