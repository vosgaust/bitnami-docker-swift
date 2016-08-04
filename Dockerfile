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
    apt-get install -y clang libicu-dev icu-devtools uuid-dev  && \
    apt-get clean
	
# Install related packages
RUN bitnami-pkg install python-2.7.11-3 --checksum 51d9ebc8a10e75f420c1af1321db321e20c45386a538932c78d5e0d74192aea5

# Swift module
RUN bitnami-pkg install swift-3.0-DEVELOPMENT-SNAPSHOT-2016-07-25-0 --checksum 5988b509d2dae24a9fd46fd31d3fe7df91f9a67978df07e2fe86bae447feffad

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
