
#setup the ROS environment variables
export ROS_DISTRO=indigo
source /opt/ros/${ROS_DISTRO}/setup.bash

#source the catkin workspace setup
source ~/ros_workspace/devel/setup.bash

# Add other ROS packages to ROS_PACKAGE_PATH
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:~/ros_packages/src


# Setup the ROS network variables
export ROS_PORT=11311

#export ROS_IP=192.168.1.103

#==========================
#Local testing
export ROS_IP=127.0.0.1
#==========================

export ROS_MASTER_URI=http://${ROS_IP}:${ROS_PORT}
export ROSLAUNCH_SSH_UNKNOWN=1
