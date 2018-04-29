# jupyter notebook with jupyter-scala
# https://github.com/jupyter-scala/jupyter-scala

FROM jupyter/base-notebook

MAINTAINER kzmake <kazu.0516.k0n0f@gmail.com>

# -----------------------------------------------------------------------------
# Const
# -----------------------------------------------------------------------------

# Version of jupyter-scala
ENV JUPYTER_SCALA_VERSION 0.4.2

# Version of scala
ENV SCALA_VERSION 2.12.2

# Version of sbt
ENV SBT_VERSION 1.1.4

# -----------------------------------------------------------------------------
# Install depenencies
# -----------------------------------------------------------------------------

USER root

RUN apt update \
  && apt install -y curl \
  && apt install -y openjdk-8-jdk \
  && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/openjdk-8
ENV PATH ${PATH}:${JAVA_HOME}/bin

# -----------------------------------------------------------------------------
# Download and install jupyter-scala
# https://github.com/jupyter-scala/jupyter-scala
# -----------------------------------------------------------------------------

# download and install sbt
RUN curl -sL --retry 5 "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | tar -xz -C "/tmp/" \
  && mv "/tmp/sbt" "/opt/sbt-${SBT_VERSION}" \
  && chmod +x "/opt/sbt-${SBT_VERSION}/bin/sbt"

ENV PATH ${PATH}:/opt/sbt-${SBT_VERSION}/bin/

# switch user
USER $NB_USER

# download and install jupyter-scala
RUN curl -sL --retry 5 "https://github.com/jupyter-scala/jupyter-scala/archive/v${JUPYTER_SCALA_VERSION}.tar.gz" \
  | tar -xz -C "/tmp/" \
  && chmod +x "/tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}/jupyter-scala"
  #&& mv "/tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}" "/opt/jupyter-scala-${JUPYTER_SCALA_VERSION}" \

# build jupyter-scala for scala
RUN cd "/tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}" && \
  /opt/sbt-${SBT_VERSION}/bin/sbt ++${SCALA_VERSION} publishLocal

# install kernel for scala
RUN cd /tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}/ \
  && sed -i 's/\(SCALA_VERSION=\)\([2-9]\.[0-9][0-9]*\.[0-9][0-9]*\)\(.*\)/\1${SCALA_VERSION}\3/' jupyter-scala \
  && ./jupyter-scala --id scala --name "Scala v${SCALA_VERSION}" --force
  
RUN rm -r /tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}/

RUN rm -r /home/$NB_USER/.sbt/*
RUN rm -r /home/$NB_USER/.ivy2/*
RUN rm -r /home/$NB_USER/.ivy2/.sbt*
RUN rm -r /home/$NB_USER/.coursier/*

WORKDIR /home/$NB_USER/work
