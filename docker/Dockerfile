### 1. stage: create build image
FROM ciceron/ada-awa:latest AS wi2wic-build

ENV BUILD_PREFIX /usr/src/wi2wic

# Install build dependencies
RUN mkdir -p /usr/src \
   && export ADA_PROJECT_PATH=/usr/share/gpr \
   && cd /usr/src \
   && git clone https://github.com/stcarrez/wi2wic.git wi2wic \
   && cd wi2wic \
   && ./configure --prefix=/usr \
   && make -s \
   && make -s install

### 2. stage: create production image

FROM ubuntu:bionic AS wi2wic

ENV INSTALL_PREFIX /usr/local
ENV BUILD_PREFIX /usr/src/wi2wic

RUN apt-get update && \
    apt-get install -y libaws17.2.2017

COPY --from=wi2wic-build ${BUILD_PREFIX}/bin/ ${INSTALL_PREFIX}/bin/
COPY --from=wi2wic-build ${BUILD_PREFIX}/web/ ${INSTALL_PREFIX}/web/
COPY --from=wi2wic-build ${BUILD_PREFIX}/wi2wic.properties ${INSTALL_PREFIX}/

# CLI
EXPOSE 8080

WORKDIR ${INSTALL_PREFIX}
CMD ${INSTALL_PREFIX}/bin/wi2wic-server
