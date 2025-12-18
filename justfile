build-sim:
    docker build -f docker/isaacsim5.dockerfile \
    --network=host \
    -t lab2.3-sim5.1:v0 .


run-sim:
    docker run --name lab2.3-sim5.1 -itd --privileged --gpus all --network host \
    --entrypoint bash \
    --runtime=nvidia \
    -e ACCEPT_EULA=Y -e PRIVACY_CONSENT=Y \
    -e DISPLAY -e QT_X11_NO_MITSHM=1 \
    -v $HOME/.Xauthority:/root/.Xauthority \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/docker/isaac-sim5.1/cache/kit:/isaac-sim/kit/cache:rw \
    -v ~/docker/isaac-sim5.1/cache/ov:/root/.cache/ov:rw \
    -v ~/docker/isaac-sim5.1/cache/pip:/root/.cache/pip:rw \
    -v ~/docker/isaac-sim5.1/cache/glcache:/root/.cache/nvidia/GLCache:rw \
    -v ~/docker/isaac-sim5.1/cache/computecache:/root/.nv/ComputeCache:rw \
    -v ~/docker/isaac-sim5.1/logs:/root/.nvidia-omniverse/logs:rw \
    -v ~/docker/isaac-sim5.1/data:/root/.local/share/ov/data:rw \
    -v ~/docker/isaac-sim5.1/documents:/root/Documents:rw \
    -v ${HOME}/workspace/.git:/workspace/.git \
    -v ${HOME}/workspace/MasterRacing:/workspace/MasterRacing \
    lab2.3-sim5.1:v0

exec-sim:
    docker exec -it lab2.3-sim5.1 /bin/bash

stop-sim:
    docker stop lab2.3-sim5.1 || true && \
    docker rm lab2.3-sim5.1 || true
db:
    docker build -f docker/daibo.dockerfile \
    --build-arg ISAACSIM_VERSION=4.5.0 \
    --build-arg ISAACLAB_REPO=https://github.com/isaac-sim/IsaacLab.git \
    --build-arg ISAACLAB_REF=v2.1.0 \
    --network=host --progress=plain \
    -t daibo:v0 .
    
dr:
    docker run --name daibo -itd --privileged --gpus all --network host \
    --entrypoint bash \
    -e ACCEPT_EULA=Y -e PRIVACY_CONSENT=Y \
    -e DISPLAY -e QT_X11_NO_MITSHM=1 \
    -v $HOME/.Xauthority:/root/.Xauthority \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/docker/isaac-sim4.5/cache/kit:/isaac-sim/kit/cache:rw \
    -v ~/docker/isaac-sim4.5/cache/ov:/root/.cache/ov:rw \
    -v ~/docker/isaac-sim4.5/cache/pip:/root/.cache/pip:rw \
    -v ~/docker/isaac-sim4.5/cache/glcache:/root/.cache/nvidia/GLCache:rw \
    -v ~/docker/isaac-sim4.5/cache/computecache:/root/.nv/ComputeCache:rw \
    -v ~/docker/isaac-sim4.5/logs:/root/.nvidia-omniverse/logs:rw \
    -v ~/docker/isaac-sim4.5/data:/root/.local/share/ov/data:rw \
    -v ~/docker/isaac-sim4.5/documents:/root/Documents:rw \
    -v ${HOME}/workspace/.git:/workspace/.git \
    -v ${HOME}/workspace/MasterRacing:/workspace/MasterRacing \
    daibo:v0


de:
    docker exec -it daibo /bin/bash


ds:
    docker stop daibo || true && \
    docker rm daibo || true

run-isaac-sim-solo:
    docker run --name isaac-sim --entrypoint bash -it --gpus all -e "ACCEPT_EULA=Y" --rm --network=host \
        -e "PRIVACY_CONSENT=Y" \
        -v ~/docker/isaac-sim5.1/cache/main:/isaac-sim/.cache:rw \
        -v ~/docker/isaac-sim5.1/cache/computecache:/isaac-sim/.nv/ComputeCache:rw \
        -v ~/docker/isaac-sim5.1/logs:/isaac-sim/.nvidia-omniverse/logs:rw \
        -v ~/docker/isaac-sim5.1/config:/isaac-sim/.nvidia-omniverse/config:rw \
        -v ~/docker/isaac-sim5.1/data:/isaac-sim/.local/share/ov/data:rw \
        -v ~/docker/isaac-sim5.1/pkg:/isaac-sim/.local/share/ov/pkg:rw \
        nvcr.io/nvidia/isaac-sim:5.1.0  
# 1234 is isaac-sim user uid
exec-isaac-sim-solo:
    docker exec -it isaac-sim /bin/bash

alias rd := run-sim
alias b := build-sim
alias e := exec-sim
alias s := stop-sim
alias ri := run-isaac-sim-solo
alias ei := exec-isaac-sim-solo
