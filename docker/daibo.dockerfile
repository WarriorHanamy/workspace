# syntax=docker/dockerfile:1.4

ARG ISAACSIM_BASE_IMAGE=nvcr.io/nvidia/isaac-sim
ARG ISAACSIM_VERSION=4.5.0

FROM ${ISAACSIM_BASE_IMAGE}:${ISAACSIM_VERSION} AS simulation

ARG ISAACSIM_ROOT_PATH=/isaac-sim
ARG ISAACLAB_PATH=/workspace/isaaclab
ARG DOCKER_USER_HOME=/root
ARG ISAACLAB_REPO=https://github.com/isaac-sim/IsaacLab.git
ARG ISAACLAB_REF=v2.1.0

ENV ISAACSIM_VERSION=${ISAACSIM_VERSION} \
    ISAACSIM_ROOT_PATH=${ISAACSIM_ROOT_PATH} \
    ISAACLAB_PATH=${ISAACLAB_PATH} \
    DOCKER_USER_HOME=${DOCKER_USER_HOME} \
    LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    RMW_IMPLEMENTATION=rmw_fastrtps_cpp \
    ISAACSIM_PATH=${ISAACLAB_PATH}/_isaac_sim \
    OMNI_KIT_ALLOW_ROOT=1 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=all


SHELL ["/bin/bash", "-c"]

USER root

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libglib2.0-0 \
    ncurses-term \
    wget \
    curl \
    gedit \
    tmux \
    software-properties-common 

RUN git clone --branch ${ISAACLAB_REF} --depth 1 ${ISAACLAB_REPO} ${ISAACLAB_PATH} && \
    rm -rf ${ISAACLAB_PATH}/.git

RUN chmod +x ${ISAACLAB_PATH}/isaaclab.sh

RUN ln -sf ${ISAACSIM_ROOT_PATH} ${ISAACLAB_PATH}/_isaac_sim

RUN ${ISAACLAB_PATH}/isaaclab.sh -p -m pip install --upgrade pip


RUN --mount=type=cache,target=/var/cache/apt \
    ${ISAACLAB_PATH}/isaaclab.sh -p ${ISAACLAB_PATH}/tools/install_deps.py apt ${ISAACLAB_PATH}/source

RUN mkdir -p ${ISAACSIM_ROOT_PATH}/kit/cache && \
    mkdir -p ${DOCKER_USER_HOME}/.cache/ov && \
    mkdir -p ${DOCKER_USER_HOME}/.cache/pip && \
    mkdir -p ${DOCKER_USER_HOME}/.cache/nvidia/GLCache && \
    mkdir -p ${DOCKER_USER_HOME}/.nv/ComputeCache && \
    mkdir -p ${DOCKER_USER_HOME}/.nvidia-omniverse/logs && \
    mkdir -p ${DOCKER_USER_HOME}/.local/share/ov/data && \
    mkdir -p ${DOCKER_USER_HOME}/Documents

RUN touch /bin/nvidia-smi && \
    touch /bin/nvidia-debugdump && \
    touch /bin/nvidia-persistenced && \
    touch /bin/nvidia-cuda-mps-control && \
    touch /bin/nvidia-cuda-mps-server && \
    touch /etc/localtime && \
    mkdir -p /var/run/nvidia-persistenced && \
    touch /var/run/nvidia-persistenced/socket

RUN --mount=type=cache,target=${DOCKER_USER_HOME}/.cache/pip \
    ${ISAACLAB_PATH}/isaaclab.sh --install

# RUN ${ISAACLAB_PATH}/_isaac_sim/python.sh -m pip install "numpy<2" --upgrade --no-cache-dir

RUN echo "export ISAACLAB_PATH=${ISAACLAB_PATH}" >> ${HOME}/.bashrc && \
    echo "alias isaaclab=${ISAACLAB_PATH}/isaaclab.sh" >> ${HOME}/.bashrc && \
    echo "alias python=${ISAACLAB_PATH}/_isaac_sim/python.sh" >> ${HOME}/.bashrc && \
    echo "alias python3=${ISAACLAB_PATH}/_isaac_sim/python.sh" >> ${HOME}/.bashrc && \
    echo "alias pip='${ISAACLAB_PATH}/_isaac_sim/python.sh -m pip'" >> ${HOME}/.bashrc && \
    echo "alias pip3='${ISAACLAB_PATH}/_isaac_sim/python.sh -m pip'" >> ${HOME}/.bashrc && \
    echo "alias tensorboard='${ISAACLAB_PATH}/_isaac_sim/python.sh ${ISAACLAB_PATH}/_isaac_sim/tensorboard'" >> ${HOME}/.bashrc && \
    echo "export TZ=$(date +%Z)" >> ${HOME}/.bashrc && \
    echo "shopt -s histappend" >> ${HOME}/.bashrc && \
    echo "PROMPT_COMMAND='history -a'" >> ${HOME}/.bashrc

VOLUME [ \
    "/isaac-sim/kit/cache", \
    "/root/.cache/ov", \
    "/root/.cache/pip", \
    "/root/.cache/nvidia/GLCache", \
    "/root/.nv/ComputeCache", \
    "/root/.nvidia-omniverse/logs", \
    "/root/.local/share/ov/data", \
    "/workspace/isaaclab/docs/_build", \
    "/workspace/isaaclab/logs", \
    "/workspace/isaaclab/data_storage" \
]

WORKDIR /workspace

ENTRYPOINT ["/bin/bash"]
