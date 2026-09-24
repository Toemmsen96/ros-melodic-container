#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

[ -f .env ] || { cp .env.example .env; echo "Created .env - edit ROS_IP and ROS_MASTER_URI, then re-run."; exit 1; }
mkdir -p catkin_ws/src

xhost +local:docker >/dev/null 2>&1 || true   # allow GUI apps (rviz, rqt)
docker compose build
docker compose run --rm ros "${@:-zsh}"
