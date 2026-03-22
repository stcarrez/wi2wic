### 1. stage: create build image
FROM ciceron/alire-trixie AS wi2wic-build

ENV BUILD_PREFIX=/usr/src/wi2wic

# Install build dependencies
RUN mkdir -p /usr/src \
   && cd /usr/src \
   && rm -rf wi2wic \
   && git clone https://github.com/stcarrez/wi2wic.git wi2wic \
   && cd wi2wic \
   && alr --non-interactive index --update-all

RUN /usr/bin/alr toolchain --select gnat_native

RUN cd /usr/src/wi2wic \
   && ls -l \
   && alr --non-interactive update \
   && make -s \
   && make -s install

### 2. stage: create production image

FROM debian:trixie AS wi2wic

ENV INSTALL_PREFIX=/usr/local
ENV BUILD_PREFIX=/usr/src/wi2wic

RUN apt-get update \
    && apt-get install -y --no-install-recommends libssl3
COPY --from=wi2wic-build ${BUILD_PREFIX}/bin/ ${INSTALL_PREFIX}/bin/
COPY --from=wi2wic-build ${BUILD_PREFIX}/web/ ${INSTALL_PREFIX}/web/
COPY --from=wi2wic-build ${BUILD_PREFIX}/wi2wic.properties ${INSTALL_PREFIX}/

# CLI
EXPOSE 8080

WORKDIR ${INSTALL_PREFIX}
CMD ${INSTALL_PREFIX}/bin/wi2wic-server
