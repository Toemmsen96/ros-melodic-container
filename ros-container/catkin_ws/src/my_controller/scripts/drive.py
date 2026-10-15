#!/usr/bin/env python
import rospy
from geometry_msgs.msg import Twist
from sensor_msgs.msg import LaserScan

def on_scan(msg):
    rospy.loginfo("closest obstacle: %.2f m", min(msg.ranges))

rospy.init_node("my_controller")
pub = rospy.Publisher("/cmd_vel", Twist, queue_size=10)
rospy.Subscriber("/scan", LaserScan, on_scan)

rate = rospy.Rate(10)
while not rospy.is_shutdown():
    cmd = Twist()
    cmd.linear.x = 0.1
    pub.publish(cmd)
    rate.sleep()
