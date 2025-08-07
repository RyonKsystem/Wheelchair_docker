# Docker build the Docker file
docker build . -t ubuntu_22_04

# docker run 
docker run -itd --privileged   -e DISPLAY=unix${DISPLAY}   -v /tmp/.X11-unix:/tmp/.X11-unix   --net=host   --gpus=all   -e NVIDIA_DRIVER_CAPABILITIES=all --name ubuntu_ros2_gazebo_22_04   ubuntu_22_04

# ros2 launch
ros2 launch connection_wheelchair connection_wheelchair.launch.py

