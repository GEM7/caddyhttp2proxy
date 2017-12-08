FROM    alpine:latest

MAINTAINER	Adam	github.com/GEM7

ENV     DOMAIN		""	
ENV     CERT_DIR	/srv/docker/certs
ENV	WEB_DIR		/srv/docker/caddy
ENV	FILE_PATH	/share
ENV	AUTH_USER	""
ENV	AUTH_PATH	""	

RUN     buildDeps="curl unzip" && \
        set -x &&\
	mkdir -p $WEB_DIR && \
	mkdir -p $WEB_DIR$FILE_PATH	&& \
        mkdir -p $CERT_DIR && \
        mkdir -p /tmp/caddy && \
        apk add --no-cache curl unzip ca-certificates && \
        curl -sl -o /tmp/caddy/caddy_linux_amd64.tar.gz "https://caddyserver.com/download/linux/amd64?plugins=http.filemanager,http.forwardproxy&license=personal" && \
        tar -zxf /tmp/caddy/caddy_linux_amd64.tar.gz -C /tmp/caddy && \
        mv /tmp/caddy/caddy /usr/bin/ && \
        chmod +x /usr/bin/caddy && \
        rm -rf /tmp/caddy && \
        apk del --purge $buildDeps
        
VOLUME  $CERT_DIR
VOLUME	$WEB_DIR
VOLUME	$WEB_DIR$FILE_PATH

ADD	CaddyFile	/etc/CaddyFile
ADD	index.html	$WEB_DIR/index.html

EXPOSE  443

ENTRYPOINT	sed -i "s|DOMAIN|$DOMAIN|g"		/etc/CaddyFile	&&\
		sed -i "s|FILE_PATH|$FILE_PATH|g"	/etc/CaddyFile	&&\
		sed -i "s|WEB_DIR|$WEB_DIR|g"		/etc/CaddyFile	&&\
		sed -i "s|CERT_DIR|$CERT_DIR|g"		/etc/CaddyFile	&&\
		sed -i "s|AUTH_USER|$AUTH_USER|g"	/etc/CaddyFile	&&\
		sed -i "s|AUTH_PASS|$AUTH_PASS|g"	/etc/CaddyFile	&&\
		/usr/bin/caddy -conf /etc/CaddyFile
#CMD     ["-conf", "/etc/CaddyFile"]
