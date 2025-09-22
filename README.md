※車椅子班用のパッケージです．

事前にnvidia graphics driver, docker engine, vscode, nvidia docker container toolkitをインストールする．

# 導入手順
1. Docker fileに必要なsrcファイルをNASから取得し，Dockerfile内に追加してください．

2. Docker fileをbuild: 
```
~$ docker build . -t ubuntu_22_04
```

3. dockerコンテナの作成:
```
~$ docker run -itd --privileged   -e DISPLAY=unix${DISPLAY}   -v /tmp/.X11-unix:/tmp/.X11-unix   --net=host   --gpus=all   -e NVIDIA_DRIVER_CAPABILITIES=all --name ubuntu_ros2_gazebo_22_04   ubuntu_22_04
```

4. コンテナ内でのシミュレーションの起動:
```
~$ ros2 launch connection_wheelchair connection_wheelchair.launch.py
```
