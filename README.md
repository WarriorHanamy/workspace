# Docker Environment for Isaac Simulation

This repository provides Docker configurations for Isaac Sim and IsaacLab robotics development environments.

## Docker Images

### 1. isaacsim5.dockerfile (Default)

**Purpose**: Production-ready environment with Isaac Sim 5.1.0 and IsaacLab 2.3.1

**Version Compatibility**:
- Isaac Sim: 5.1.0
- IsaacLab: 2.3.1 (from local `./IsaacLab` directory)
- Base Image: `nvcr.io/nvidia/isaac-sim:5.1.0`

**Features**:
- Pre-configured with IsaacLab from local directory
- Optimized cache directories for persistence
- Aliases for `python`, `pip`, `isaaclab`, and `tensorboard`
- Just command runner integration
- Ready for MasterRacing project development

### 2. daibo.dockerfile

**Purpose**: Development environment with Isaac Sim 4.5.0 and IsaacLab 2.1.0

**Version Compatibility**:
- Isaac Sim: 4.5.0
- IsaacLab: 2.1.0 (cloned from GitHub)
- Base Image: `nvcr.io/nvidia/isaac-sim:4.5.0`

**Features**:
- Clones IsaacLab v2.1.0 from official repository
- Includes dependency installation
- ROS 2 support with FastRTPS
- Suitable for development with older Isaac Sim versions

### 3. rover.dockerfile

**Purpose**: Experimental environment for rover-specific applications

**Version Compatibility**:
- Isaac Sim: 5.1.0
- IsaacLab: 2.3.0 (intended)
- Base Image: `nvcr.io/nvidia/isaac-sim:5.1.0`

**Note**: This file appears to be incomplete and may need additional configuration.

## Quick Start

### Using the Default Environment (isaacsim5)

```bash
# Build the Docker image
just build-sim

# Run the container
just run-sim

# Execute into the running container
just exec-sim

# Stop and remove the container
just stop-sim
```

### Using the Daibo Environment

```bash
# Build the daibo image
just db

# Run the container
just dr

# Execute into the container
just de

# Stop the container
just ds
```

## Important: Use IsaacSim Native Python

⚠️ **Strong Recommendation**: Always use IsaacSim's native Python environment instead of creating virtual environments or using system Python.

### Why Use IsaacSim Native Python?

1. **Precompiled Dependencies**: Isaac Sim comes with pre-compiled Python packages optimized for physics simulation
2. **GPU Integration**: Native Python has proper CUDA and GPU driver integration
3. **Binary Compatibility**: Physics engines and rendering libraries are linked against the bundled Python
4. **Performance**: Avoids compatibility issues and ensures optimal performance

### How to Use Native Python

The Docker images provide convenient aliases that point to IsaacSim's native Python:

```bash
# Inside the container, use these aliases:
python script.py          # Uses IsaacSim's native Python
pip install package       # Installs into IsaacSim's Python environment
isaaclab --help          # IsaacLab command line tool
tensorboard --logdir=logs  # Tensorboard with IsaacSim Python
```

### What to Avoid

❌ **DO NOT** create virtual environments:
```bash
# Avoid these commands:
python -m venv myenv
source myenv/bin/activate
conda create -n myenv
```

❌ **DO NOT** use system Python:
```bash
# Avoid direct system Python usage:
/usr/bin/python3
python3.12 # Ubuntu24.04 comes with Python 3.12
```

## Volume Persistence

The Docker configurations use persistent volumes to cache:

- Isaac Sim kit cache
- Python package cache (pip)
- GPU compute cache
- Omniverse logs and data
- IsaacLab build artifacts

This prevents re-downloading large dependencies and speeds up container startup.

## Development Workflow

1. **Use the default isaacsim5.dockerfile** for new projects
2. **Mount your project directories** when running containers
3. **Always use the provided Python aliases** instead of creating virtual environments
4. **Leverage the persistent cache volumes** for faster iteration
