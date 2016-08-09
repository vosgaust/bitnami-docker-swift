FROM gcr.io/stacksmith-images/ubuntu-buildpack:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

USER root

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install extra packages
RUN apt-get update && \
    apt-get install -y clang libedit2 libicu52 libsqlite3-dev libxml2 && \
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

RUN harpoon initialize tomcat

RUN bitnami-pkg install python-2.7.12rc1-0 --checksum 2c56021761411358b949fa0c962d61875d70f5b092fc937dceea1b52ce8440d5
ENV PATH=/opt/bitnami/python/bin:$PATH

# Swift module
RUN bitnami-pkg install swift-3.0-PREVIEW-4-0 --checksum 5a68b54f9c861f889268cfdb821f4ab4af06e95f87d16aef87236a8667b25bbc
ENV PATH=/opt/bitnami/swift/bin:$PATH

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

# Swift template
ENV BITNAMI_APP_NAME=swift \ 
    BITNAMI_IMAGE_VERSION=3.0-PREVIEW-4

EXPOSE 8181

# Start Tomcat to interact with Eclipse che
LABEL che:server:8181:ref=swift che:server:8181:protocol=http
CMD harpoon start --foreground tomcat
