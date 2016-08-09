## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami-bitnami-docker-swift .
##
## RUNNING
##   $ docker run -p 8181:8181 bitnami-bitnami-docker-swift
##
## CONNECTING
##   Lookup the IP of your active docker host using:
##     $ docker-machine ip $(docker-machine active)
##   Connect to the container at DOCKER_IP:8181
##     replacing DOCKER_IP for the IP of your active docker host

FROM gcr.io/stacksmith-images/ubuntu-buildpack:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

# Install related packages
RUN apt-get update && \
    apt-get install -y clang libicu-dev icu-devtools uuid-dev libedit-dev libxml2-dev libsqlite3-dev libncurses5-dev openssl libssl-dev curl && \
    apt-get clean
	
# Install related packages
RUN bitnami-pkg install python-2.7.12rc1-0 --checksum 2c56021761411358b949fa0c962d61875d70f5b092fc937dceea1b52ce8440d5

# Swift module
RUN bitnami-pkg install swift-3.0-PREVIEW-4-0 --checksum 5a68b54f9c861f889268cfdb821f4ab4af06e95f87d16aef87236a8667b25bbc

ENV PATH=/opt/bitnami/python/bin:$PATH
ENV PATH=/opt/bitnami/swift/bin:$PATH

RUN chown -R bitnami:bitnami /opt/bitnami/swift

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

# Swift template
ENV BITNAMI_APP_NAME=swift \
    BITNAMI_IMAGE_VERSION=3.0-DEVELOPMENT-SNAPSHOT-2016-07-25

COPY rootfs/ /

# The extra files that we bundle should use the Bitnami User
# so the entrypoint does not have any permission issues
RUN chown -R bitnami:bitnami /app_template

USER bitnami

WORKDIR /app
EXPOSE 8181

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["swift", "app", "start"]
#CMD python -m SimpleHTTPServer 8181
