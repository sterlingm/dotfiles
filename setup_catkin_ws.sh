
mkdir -p ~/ros_workspace/src
cd ~/ros_workspace/src
catkin_init_workspace
cd ..
catkin_make
source devel/setup.bash



mkdir -p ~/ros_packages/src
catkin_init_workspace
cd ..
catkin_make
source devel/setup.bash


