### 1. stage: create build image
FROM ciceron/gnat-bookworm AS wi2wic-build

ENV BUILD_PREFIX /usr/src/wi2wic

RUN apt-get update \
    && apt-get install -y --no-install-recommends libssl-dev

RUN cd /tmp \
    && wget -O alr.zip https://github.com/alire-project/alire/releases/download/v2.0.1/alr-2.0.1-bin-x86_64-linux.zip \
    && unzip alr.zip \
    && mv bin/alr /usr/bin \
    && rm alr.zip

# Install build dependencies
RUN mkdir -p /usr/src \
   && cd /usr/src \
   && rm -rf wi2wic \
   && git clone https://github.com/stcarrez/wi2wic.git wi2wic \
   && cd wi2wic \
   && alr --non-interactive index --update-all

RUN cd /usr/src/wi2wic \
   && ls -l \
   && alr --non-interactive update \
   && make -s \
   && make -s install

### 2. stage: create production image

FROM debian:bookworm AS wi2wic

ENV INSTALL_PREFIX /usr/local
ENV BUILD_PREFIX /usr/src/wi2wic

RUN apt-get update \
    && apt-get install -y --no-install-recommends libssl3
COPY --from=wi2wic-build ${BUILD_PREFIX}/bin/ ${INSTALL_PREFIX}/bin/
COPY --from=wi2wic-build ${BUILD_PREFIX}/web/ ${INSTALL_PREFIX}/web/
COPY --from=wi2wic-build ${BUILD_PREFIX}/wi2wic.properties ${INSTALL_PREFIX}/

# CLI
EXPOSE 8080

WORKDIR ${INSTALL_PREFIX}
CMD ${INSTALL_PREFIX}/bin/wi2wic-server
