FROM registry.access.redhat.com/ubi8/ubi:8.0

LABEL maintainer="Your Name <your@email.com>" \
    io.k8s.description="Uma imagem para compilação de aplicações Maven escritas com o OpenJDK 11" \
    io.k8s.display-name="OpenJDK 11 S2I Builder" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="java,openjdk,maven,s2i,builder,jdk,spring,vertx,vert.x,wildfly" \
    io.openshift.s2i.scripts-url="/usr/libexec/s2i"

ENV JAVA_HOME="/opt/openjdk11" \
    MAVEN_HOME="/opt/maven" \
    PATH="$PATH:/opt/maven/bin:/opt/openjdk11/bin"

WORKDIR /opt
RUN yum update -y && \
    yum install -y wget curl tar && \
    wget https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz && \
    wget https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz && \
    tar xvzf openjdk-11.0.2_linux-x64_bin.tar.gz && \
    tar xvzf apache-maven-3.6.3-bin.tar.gz && \
    mv apache-maven-3.6.3 /opt/maven && \
    mv jdk-11.0.2 /opt/openjdk11 && \
    chown -R 1001:0 /opt && \
    chmod -R g=u /opt

COPY ./s2i/bin/ /usr/libexec/s2i

USER 1001
EXPOSE 8080
CMD ["/usr/libexec/s2i/usage"]
