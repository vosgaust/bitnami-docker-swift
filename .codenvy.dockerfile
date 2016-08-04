FROM gcr.io/stacksmith-images/ubuntu-buildpack:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install extra packages
RUN apt-get update && \
    apt-get install -y clang libicu-dev icu-devtools uuid-dev  && \
    apt-get clean

ENV BITNAMI_IMAGE_VERSION=8.0.35-r1 \
    BITNAMI_APP_NAME=tomcat \
    BITNAMI_APP_USER=tomcat

# Install related packages
RUN bitnami-pkg install java-1.8.0_91-0 --checksum 64cf20b77dc7cce3a28e9fe1daa149785c9c8c13ad1249071bc778fa40ae8773
ENV PATH=/opt/bitnami/java/bin:$PATH
RUN bitnami-pkg unpack tomcat-8.0.35-0 --checksum d86af6bade1325215d4dd1b63aefbd4a57abb05a71672e5f58e27ff2fd49325b
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH
ENV TOMCAT_HOME=/opt/bitnami/$BITNAMI_APP_NAME
RUN bitnami-pkg install python-2.7.11-3 --checksum 51d9ebc8a10e75f420c1af1321db321e20c45386a538932c78d5e0d74192aea5
ENV PATH=/opt/bitnami/python/bin:$PATH

# Swift module
RUN bitnami-pkg install swift-3.0-DEVELOPMENT-SNAPSHOT-2016-07-25-0 --checksum 5988b509d2dae24a9fd46fd31d3fe7df91f9a67978df07e2fe86bae447feffad
ENV PATH=/opt/bitnami/swift/bin:$PATH

RUN chown -R bitnami:bitnami /opt/bitnami

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

LABEL che:server:8181:ref=swift che:server:8181:protocol=http

# Swift template
ENV BITNAMI_APP_NAME=swift \
    BITNAMI_IMAGE_VERSION=3.0-DEVELOPMENT-SNAPSHOT-2016-07-25

EXPOSE 8181

# Initialize Tomcat to interact with Eclipse che
RUN harpoon initialize tomcat
CMD ["harpoon", "start", "--foreground", "tomcat"]
