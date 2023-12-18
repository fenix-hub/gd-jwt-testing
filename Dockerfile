FROM alpine:3.19.0

# Environment Variables
ENV GODOT_VERSION "4.2"
ENV OS "stable_linux"
ENV GODOT_ARCHITECTURE "x86_64"
ENV ARCHIVE_FORMAT "zip"
ENV GODOT_FULLNAME "Godot_v${GODOT_VERSION}-${OS}.${GODOT_ARCHITECTURE}"

# Specify versions
ARG GLIBC_VERSION=2.28-r0

# Allow this to run Godot with specified glibc version
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && apk add --no-cache --force-overwrite glibc-${GLIBC_VERSION}.apk \
    && rm -f glibc-${GLIBC_VERSION}.apk

# Work in a temp directory to download Godot and add the binary to PATH
RUN mkdir /tmp/godot
WORKDIR /tmp/godot

# Download Godot
RUN wget -q https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/${GODOT_FULLNAME}.${ARCHIVE_FORMAT} \
    && unzip ${GODOT_FULLNAME}.${ARCHIVE_FORMAT} \
    && mv ${GODOT_FULLNAME} /usr/local/bin/godot \
    && rm -f ${GODOT_FULLNAME}.${ARCHIVE_FORMAT}

# Move to a test directory to execute the test suite project
RUN mkdir /test && \
    rm -f -R /tmp/godot
WORKDIR /test

CMD ["godot", "--headless", "--version"]