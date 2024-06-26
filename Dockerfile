FROM alpine:3.20.1

# Environment Variables
ENV GODOT_VERSION "4.2"
ENV OS "stable_linux"
ENV GODOT_ARCHITECTURE "x86_64"
ENV ARCHIVE_FORMAT "zip"
ENV GODOT_FULLNAME "Godot_v${GODOT_VERSION}-${OS}.${GODOT_ARCHITECTURE}"
ENV GODOT_JWT_BRANCH "main-godot4"
ENV OUTPUT_PATH "/test/output"

# Specify versions
ARG GLIBC_VERSION=2.28-r0
ARG GIT_VERSION=2.43.0-r0

# Allow this to run Godot with specified glibc version

RUN apk update \
    && apk add --no-cache git=${GIT_VERSION} \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
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

COPY src/ src/

RUN wget -q https://github.com/fenix-hub/godot-engine.jwt/archive/refs/heads/${GODOT_JWT_BRANCH}.zip \
    && unzip ${GODOT_JWT_BRANCH}.zip \
    && mv godot-engine.jwt-${GODOT_JWT_BRANCH}/addons src/ \
    && rm -f ${GODOT_JWT_BRANCH}.zip

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]