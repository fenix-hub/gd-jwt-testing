FROM alpine:latest

# Environment Variables
ENV GODOT_VERSION "4.2"
ENV OS "stable_linux"
ENV GODOT_ARCHITECTURE "x86_64"
ENV ARCHIVE_FORMAT "zip"
ENV GODOT_FULLNAME "Godot_v${GODOT_VERSION}-${OS}.${GODOT_ARCHITECTURE}"

# Updates and installs to the server
RUN apk update \
    && apk add --no-cache bash wget git ca-certificates

# Allow this to run Godot
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk \
    && apk add --no-cache --force-overwrite glibc-2.28-r0.apk \
    && rm -f glibc-2.28-r0.apk

# Work in a temp directory to download Godot and add the binary to PATH
RUN mkdir /tmp/godot
WORKDIR /tmp/godot

# Download Godot
RUN wget -q https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/${GODOT_FULLNAME}.${ARCHIVE_FORMAT} \
    && unzip ${GODOT_FULLNAME}.${ARCHIVE_FORMAT} \
    && mv ${GODOT_FULLNAME} /usr/local/bin/godot \
    && rm -f ${GODOT_FULLNAME}.${ARCHIVE_FORMAT}

RUN rm -R -f /var/cache/apk/*

# Move to a test directory to execute the test suite project
RUN mkdir /test
WORKDIR /test
RUN rm -f -R /tmp/godot

CMD ["godot", "--headless", "--version"]