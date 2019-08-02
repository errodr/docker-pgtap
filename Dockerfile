FROM alpine:3.9
MAINTAINER Andreas Wålm <andreas@walm.net>
MAINTAINER Ludovic Claude <ludovic.claude@chuv.ch>

ENV DOCKERIZE_VERSION=v0.6.1

RUN apk add --no-cache --update curl wget postgresql-client postgresql-dev git openssl \
      build-base make perl perl-dev bash \
    && wget -O /tmp/dockerize.tar.gz https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz \
    && chown root:root /usr/local/bin/dockerize \
    && apk del wget \
    && rm -rf /var/cache/apk/* /tmp/*

# install pg_prove
RUN cpan TAP::Parser::SourceHandler::pgTAP

# install pgtap
ENV PGTAP_VERSION v1.0.0
RUN git clone git://github.com/theory/pgtap.git \
    && cd pgtap && git checkout tags/$PGTAP_VERSION \
    && make

COPY docker/*.sh /
RUN chmod +x /*.sh

WORKDIR /

ENV DATABASE="" \
    HOST=db \
    PORT=5432 \
    USER="postgres" \
    PASSWORD="" \
    TESTS="/test/*.sql"

ENTRYPOINT ["/test.sh"]
CMD [""]

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="hbpmip/pgtap" \
      org.label-schema.description="pgTAP - Unit testing for PostgreSQL" \
      org.label-schema.url="https://github.com/LREN-CHUV/docker-pgtap" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="https://github.com/LREN-CHUV/docker-pgtap" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version="$VERSION" \
      org.label-schema.vendor="LREN CHUV" \
      org.label-schema.license="Apache2.0" \
      org.label-schema.docker.dockerfile="Dockerfile" \
      org.label-schema.schema-version="1.0"
