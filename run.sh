#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

# Pick a container engine: honour $ENGINE, else prefer podman, else docker
ENGINE="${ENGINE:-$(command -v podman >/dev/null 2>&1 && echo podman || echo docker)}"
command -v "$ENGINE" >/dev/null 2>&1 || { echo "Neither podman nor docker found."; exit 1; }

if [ "$ENGINE" = podman ] && ! podman compose version >/dev/null 2>&1 && ! command -v podman-compose >/dev/null 2>&1; then
    echo "podman needs a compose provider: install podman-compose (or docker-compose)."; exit 1
fi
compose() {
    if [ "$ENGINE" = podman ] && ! podman compose version >/dev/null 2>&1; then
        podman-compose "$@"
    else
        "$ENGINE" compose "$@"
    fi
}

[ -f .env ] || { cp .env.example .env; echo "Created .env - edit ROS_IP and ROS_MASTER_URI, then re-run."; exit 1; }
mkdir -p catkin_ws/src

# allow GUI apps (rviz, rqt)
xhost +local:docker >/dev/null 2>&1 || true
xhost "+SI:localuser:$(id -un)" >/dev/null 2>&1 || true

compose build
compose run --rm ros "${@:-zsh}"
