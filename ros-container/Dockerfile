FROM ros:melodic-ros-base-bionic

# Rotate the ROS apt key in case the one baked into the old image has expired
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654 || true

RUN apt-get update && apt-get install -y --no-install-recommends \
        ros-melodic-desktop-full \
        python-catkin-tools \
        python-rosdep \
        build-essential \
        git \
        nano \
        iputils-ping \
        net-tools \
        iproute2 \
        zsh \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc \
    && echo "[ -f /catkin_ws/devel/setup.bash ] && source /catkin_ws/devel/setup.bash" >> /root/.bashrc

# Oh My Zsh (unattended: don't switch shell or launch zsh during build)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && sed -i 's/^plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' /root/.zshrc \
    && echo "source /opt/ros/melodic/setup.zsh" >> /root/.zshrc \
    && echo "[ -f /catkin_ws/devel/setup.zsh ] && source /catkin_ws/devel/setup.zsh" >> /root/.zshrc

WORKDIR /catkin_ws
CMD ["zsh"]
