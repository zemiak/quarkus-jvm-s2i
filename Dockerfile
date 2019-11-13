# quarkus-s2i
FROM openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
LABEL maintainer="zemiak <zemiak@gmail.com>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building Quarkus Apps on top of JDK8" \
      io.k8s.display-name="quarkus-jvm-s2i 1.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,quarkus,jvm,s2i"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
RUN yum -y install java-1.8.0-openjdk-devel && \
    mkdir -p /usr/local/maven/ && \
    cd /usr/local/maven && \
    curl -L http://tux.rainside.sk/apache/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.tar.gz >/tmp/maven.tgz && \
    tar -xzf /tmp/maven.tgz && \
    rm -f /tmp/maven.tgz && \
    mv apache-maven-3.6.2/* . && \
    rmdir apache-maven-3.6.2 && \
    chmod +x /usr/local/maven/bin/*
ENV PATH=$PATH:/usr/local/maven/bin/

# TODO (optional): Copy the builder files into /opt/app-root


# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i
RUN chmod +x /usr/libexec/s2i/* && ls -l /usr/libexec/s2i/*

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
