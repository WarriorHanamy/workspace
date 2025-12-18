ARG ISAAC_SIM_VERSION = 5.1.0
FROM nvcr.io/nvidia/isaac-sim:${ISAAC_SIM_VERSION}

# Set default RUN shell to bash
SHELL ["/bin/bash", "-c"]

ARG ISAAC_SIM_PATH = /isaac-sim
ARG ISAAC_LAB_VERSION = 2.3.0
# Set environment variables
ENV LANG=C.UTF-8 
ENV DEBIAN_FRONTEND=noninteractive
ENV ISAAC_LAB_PATH=/workspace/isaac_lab
ENV ISAAC_SIM_PATH=${ISAAC_SIM_PATH}

# Install dependencies and remove cache
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    curl \
    git \
    libglib2.0-0 \
    ncurses-term && \
    apt -y autoremove && apt clean autoclean && \
    rm -rf /var/lib/apt/lists/*



# Install this Isaac Lab and SKRL
RUN git clone --branch ${ISAACLAB_REF} --depth 1 ${ISAACLAB_REPO} ${ISAACLAB_PATH} && \
    rm -rf ${ISAACLAB_PATH}/.git
RUN export ISAACSIM_PATH="${HOME}/isaacsim" && \
    export ISAACSIM_PYTHON_EXE="${ISAACSIM_PATH}/python.sh"
# Clone and install Cosmos Tokenizer
RUN apt-get update && apt-get install -y git-lfs ffmpeg 
RUN chmod +x ${ISAACLAB_PATH}/isaaclab.sh
RUN ln -sf ${ISAAC_SIM_PATH} ${ISAACLAB_PATH}/_isaac_sim
RUN ${ISAACLAB_PATH}/isaaclab.sh -p -m pip install --upgrade pip


RUN echo "alias isaaclab=${ISAAC_LAB_PATH}/isaaclab.sh" >> ${HOME}/.bashrc && \
    echo "alias python=${ISAAC_SIM_PATH}/python.sh" >> ${HOME}/.bashrc && \
    echo "alias python3=${ISAAC_SIM_PATH}/python.sh" >> ${HOME}/.bashrc && \
    echo "alias pip='${ISAAC_SIM_PATH}/python.sh -m pip'" >> ${HOME}/.bashrc && \
    echo "alias pip3='${ISAAC_SIM_PATH}/python.sh -m pip'" >> ${HOME}/.bashrc && \
    echo "alias tensorboard='${ISAAC_SIM_PATH}/python.sh ${ISAAC_SIM_PATH}/tensorboard'" >> ${HOME}/.bashrc

# RUN ${ISAAC_SIM_PATH}/python.sh -m pip install open3d pymeshlab gdown termcolor prettytable hidapi opencv-python wandb

# Set working directory
WORKDIR ${ROVER_LAB_PATH}
