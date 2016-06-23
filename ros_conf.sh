
#setup the ROS environment variables
export ROS_DISTRO=kinetic
source /opt/ros/${ROS_DISTRO}/setup.bash

export ROS_WORKSPACE=~/ros_workspace

#source the catkin workspace setup
source ${ROS_WORKSPACE}/devel/setup.bash
source ~/ros_packages/devel/setup.bash

export ROS_WORKSPACE=~/ros_workspace

# Setup the ROS network variables
export ROS_PORT=11311

export ROS_IP=192.168.1.101

export ROS_MASTER_IP=192.168.1.101

#==========================
#Local testing
export ROS_IP=127.0.0.1
export ROS_MASTER_IP=127.0.0.1
#==========================

export ROS_MASTER_URI=http://${ROS_MASTER_IP}:${ROS_PORT}
export ROSLAUNCH_SSH_UNKNOWN=1


#export TURTLEBOT_BASE=create
#export TURTLEBOT_STACKS=circle
#export TURTLEBOT_3D_SENSOR=kinect
export TURTLEBOT_SERIAL_PORT=/dev/ttyUSB0
