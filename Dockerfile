FROM ubuntu:22.04
#FROM nvidia/opengl:base-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN apt update -y \
&& apt upgrade -y \
&& apt install -y \
   curl \
   git \
   gnupg \
   nano \
   vim \
   openssh-server \
   sudo \
   tzdata \
   udev \
   xserver-xorg \
&& locale \ 
# check for UTF-8 
&& sudo apt update -y && sudo apt install locales -y \
&& sudo locale-gen ja_JP ja_JP.UTF-8 \
&& sudo update-locale LC_ALL=ja_JP.UTF-8 LANG=ja_JP.UTF-8 \
&& export LANG=ja_JP.UTF-8 \
&& locale \ 
# verify settings
&& sudo apt install software-properties-common -y \
&& sudo add-apt-repository universe \
&& sudo apt update -y && sudo apt install curl -y \
&& sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null \
&& sudo apt update \
&& sudo apt install ros-humble-desktop -y \
&& sudo apt install ros-dev-tools -y \
&& echo "source /opt/ros/humble/setup.bash"  >> ~/.bashrc \
&& sudo apt install python3-colcon-common-extensions python3-rosdep -y \
&& sudo rosdep init \ 
&& rosdep update 

RUN mkdir -p ~/ros2_ws/src \
&& cd ~/ros2_ws/ \
&& colcon build --symlink-install --cmake-clean-cache \
&& sudo apt install gazebo -y \
&& sudo apt install ros-humble-gazebo-* -y  \
&& sudo apt install ros-humble-rqt-* -y \
&& echo 'source /usr/share/gazebo/setup.sh' >> ~/.bashrc 
# wheelchair file import
COPY ./src/ /root/ros2_ws/src/

#Install Dependent Packages
RUN cd ~/ \
&& git clone https://github.com/robotics-upo/lightsfm.git \
&& cd lightsfm \
&& make \
&& sudo make install \
&& sudo apt install ros-humble-diagnostic-updater \
&& sudo apt update \
&& sudo apt install libpcap-dev ros-humble-rmw-cyclonedds-cpp -y \
&& echo 'source ~/ros2_ws/install/setup.bash' >> ~/.bashrc 

#colcon build
RUN . /root/ros2_ws/install/setup.sh \ 
&& . /opt/ros/humble/setup.sh \
&& cd ~/ros2_ws/ \
&& colcon build --packages-select velodyne_description \
&& . /root/ros2_ws/install/setup.sh \
&& colcon build --symlink-install \
&& echo 'export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:\
$(ros2 pkg prefix electric_wheelchair)/share/electric_wheelchair/models:\
$(ros2 pkg prefix create_world)/share/create_world/models:\
$(ros2 pkg prefix gazebo_sfm_plugin)/share/gazebo_sfm_plugin/media/models' >> ~/.bashrc \
&& echo 'export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH' >> ~/.bashrc \
&& echo 'export ROS_DOMAIN_ID=11' >> ~/.bashrc \
&& echo 'export FASTDDS_BUILTIN_TRANSPORTS=UDPv4' >> ~/.bashrc \
&& echo 'export ROS_LOCALHOST_ONLY=1' >> ~/.bashrc \
&& echo 'export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp' >> ~/.bashrc

CMD ["/bin/bash"]
