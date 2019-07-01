
# Setup the ROS environment variables

# Set the distribution and source the ROS system workspace
export ROS_DISTRO=melodic
source /opt/ros/${ROS_DISTRO}/setup.bash

# Source my personal workspace(s)
export ROS_WORKSPACE=~/ros_workspace
source ~/ros_packages/devel/setup.bash
source ${ROS_WORKSPACE}/devel/setup.bash


# ROS port is always 11311
export ROS_PORT=11311

# Set the hostname of this machine to the variable ROS_HOSTNAME and ROS_IP
export ROS_HOSTNAME=192.168.1.122
export ROS_IP=${ROS_HOSTNAME}

# Set the IP of the machine running roscore
export ROS_MASTER_IP=192.168.1.122

#==========================
# Local testing
# Comment out if using multiple machines
#export ROS_HOSTNAME=127.0.0.1
#export ROS_IP=127.0.0.1
#export ROS_MASTER_IP=127.0.0.1
#==========================

# Set the master uri variable
export ROS_MASTER_URI=http://${ROS_MASTER_IP}:${ROS_PORT}
export ROSLAUNCH_SSH_UNKNOWN=1

# Set the turtlebot3 model
export TURTLEBOT3_MODEL=waffle_pi

# Set turtlebot 2 variables
#export TURTLEBOT_BASE=create
#export TURTLEBOT_STACKS=circle
#export TURTLEBOT_3D_SENSOR=kinect
#export TURTLEBOT_SERIAL_PORT=/dev/ttyUSB0
