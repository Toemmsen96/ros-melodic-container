# ROS Melodic Container

A Docker setup for running ROS Melodic (Ubuntu 18.04) on a modern host, e.g. to talk to a robot that still runs Melodic. It includes the full desktop install (rviz, rqt, Gazebo), `catkin-tools`, and a zsh shell with Oh My Zsh.

## Features

- Based on `ros:melodic-ros-base-bionic` with `ros-melodic-desktop-full`
- Host networking, so the container shares your PC's IPs and can reach the robot's `roscore`
- X11 forwarding for GUI tools (rviz, rqt, ...)
- Your workspace lives in `./catkin_ws` on the host and is mounted at `/catkin_ws`
- ROS is sourced automatically in bash and zsh, including `/catkin_ws/devel/setup.*` once built

## Requirements

- Docker with the Compose plugin
- An X11 session (or XWayland) for GUI applications
- `xhost` on the host (used by `run.sh`)

## Quick start

```bash
./run.sh
```

On the first run this creates `.env` from `.env.example` and exits. Edit `.env`, then run it again:

```bash
./run.sh            # builds the image and opens a zsh shell
./run.sh bash       # or run another command / shell
```

## Configuration

Set these in `.env`:

| Variable         | Description                                                                              |
| ---------------- | ---------------------------------------------------------------------------------------- |
| `ROS_IP`         | Your PC's IP on the robot's network (find it with `ip -4 addr`)                          |
| `ROS_MASTER_URI` | Where `roscore` runs: `http://<robot-ip>:11311`, or `http://localhost:11311` for local   |

## Working with catkin

Put your packages in `catkin_ws/src` on the host, then inside the container:

```bash
cd /catkin_ws
rosdep install --from-paths src --ignore-src -r -y
catkin build
source devel/setup.zsh
```

## Files

- `Dockerfile`: image definition
- `docker-compose.yml`: container, network, display and volume settings
- `run.sh`: helper that creates `.env`, allows X11 access, builds and starts the container
- `.env.example`: template for the environment settings

## Troubleshooting

- **GUI apps don't open:** make sure `DISPLAY` is set on the host and that `xhost +local:docker` succeeded.
- **Can't see robot topics:** check that `ROS_IP` is your PC's address on the robot's network and that `ROS_MASTER_URI` points to the robot.
