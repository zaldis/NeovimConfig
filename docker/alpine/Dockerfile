FROM alpine:latest AS base

RUN apk --no-cache add \
    autoconf \
    automake \
    build-base \
    cmake \
    ninja \
    coreutils \
    curl \
    gettext-tiny-dev \
    git \
    libtool \
    pkgconf \
    unzip

RUN git clone https://github.com/neovim/neovim.git

ARG VERSION=master
RUN cd neovim && git checkout ${VERSION} && make CMAKE_BUILD_TYPE=RelWithDebInfo install

RUN apk --no-cache add \
    fd  \
    ctags \
    ripgrep \
    git

RUN curl -s https://raw.githubusercontent.com/zaldis/NeovimConfig/main/scripts/setup.sh | bash

WORKDIR /neovim
