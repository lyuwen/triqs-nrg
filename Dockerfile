FROM fulvwen/triqs:gcc-mpich

USER root

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libgsl-dev \
      libboost-dev \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

WORKDIR /tmp

RUN git clone https://github.com/TRIQS/nrgljubljana_interface nrgljubljana_interface.src && \
    mkdir nrgljubljana_interface.build && cd nrgljubljana_interface.build && \
    cmake ../nrgljubljana_interface.src -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX && \
    make  && make install && \
    rm -rf /tmp/nrgljubljana_interface.src /tmp/nrgljubljana_interface.build

ARG NB_USER=triqs
USER $NB_USER
WORKDIR /home/$NB_USER

RUN git clone --depth 1 https://github.com/TRIQS/nrgljubljana_interface

EXPOSE 8888
CMD ["jupyter","notebook","--ip","0.0.0.0"]
