/*
 * merge_video_bag.cpp
 *
 *  Created on: Oct 19, 2012
 *      Author: jelfring
 */

// ROS
#include <ros/ros.h>

// OpenCv
#include "cv.h"
#include "highgui.h"

// For transforming ROS/OpenCV images
#include <cv_bridge/cv_bridge.h>
#include <sensor_msgs/image_encodings.h>

// Messages
#include "sensor_msgs/Image.h"
#include <std_msgs/Bool.h>
#include <std_msgs/Float64.h>
#include <rosgraph_msgs/Clock.h>

// Bag files
#include <rosbag/bag.h>
#include <rosbag/view.h>

// YAML
#include "yaml-cpp/yaml.h"

// File operations
#include <fstream>
#include <libgen.h> // for using function 'dirname'

// Boost
#include <boost/foreach.hpp>
#include <boost/filesystem.hpp>
#include "boost/format.hpp"


using namespace std;

int main( int argc, char** argv ) {

    if (argc != 2) {
        std::cout << "Please give yaml file as argument." << std::endl;
        exit(-1);
    }

    bool publish_clock = true;

    std::string filename = argv[1];

    std::cout << filename << std::endl;

    std::ifstream fin(filename.c_str());
    if (fin.fail()) {
        ROS_ERROR("Could not open %s.", filename.c_str());
        exit(-1);
    }

    // dirname can modify what you pass it
    char* filename_copy = strdup(filename.c_str());
    string bag_dir = string(dirname(filename_copy));
    free(filename_copy);

    cout << bag_dir << endl;

    // Default values
    std::string bag_in_name = "";

    // load file names from yaml file
    YAML::Parser parser(fin);
    YAML::Node doc;
    parser.GetNextDocument(doc);
    try {
        doc["bag"] >> bag_in_name;
    } catch (YAML::InvalidScalar) {
        ROS_ERROR("The input file does not contain a bag tag or is invalid.");
        exit(-1);
    }

    // Check input
    if (bag_in_name == "") {
        ROS_ERROR("No input bag file defined!");
        return -1;
    }

    if (bag_in_name[0] != '/') {
        bag_in_name = bag_dir + "/" + bag_in_name;
    }

    const YAML::Node* n_videos = doc.FindValue("videos");
    if (!n_videos) {
        ROS_ERROR("The input file does not contain a video tag or is invalid.");
        exit(-1);
    }

    std::map<std::string, cv::VideoCapture*> topic_to_video_capture;

    for (YAML::Iterator it_n_video = n_videos->begin(); it_n_video != n_videos->end(); ++it_n_video) {
        std::string video_filename;
        std::string video_topic;

        try {
            (*it_n_video)["file"] >> video_filename;
            (*it_n_video)["topic"] >> video_topic;
        } catch (YAML::InvalidScalar) {
            ROS_ERROR("Invalid video specification: should contain 'file' and 'topic'.");
            exit(-1);
        }

        if (video_filename[0] != '/') {
            video_filename = bag_dir + "/" + video_filename;
        }

        cv::VideoCapture* video_capture = new cv::VideoCapture(video_filename);

        if (!video_capture->isOpened()) {
            ROS_ERROR("Unable to open video: %s", video_filename.c_str());
            return 0;
        } else ROS_INFO("Opened video %s for topic %s", video_filename.c_str(), video_topic.c_str());

        topic_to_video_capture[video_topic] = video_capture;
    }

	// Load input bag file
	rosbag::Bag bag_in;
    bag_in.open(bag_in_name, rosbag::bagmode::Read);
	ROS_INFO("Opened %s", bag_in_name.c_str());

	// Get topics and time from input bag file
    rosbag::View view(bag_in);

    cv::Mat rgb_frame;
    cv_bridge::CvImagePtr rgb_img_ptr(new cv_bridge::CvImage);
    sensor_msgs::ImagePtr rgb_img;

    cv::Mat depth_frame;
    cv_bridge::CvImagePtr depth_img_ptr(new cv_bridge::CvImage);
    sensor_msgs::ImagePtr depth_img;

    // Initialize node
    ros::init(argc, argv, "rosbag_video_play");
    ros::NodeHandle nh;

    std::map<std::string, ros::Publisher> topic_to_publisher;

    ros::Publisher pub_clock;
    if (publish_clock) {
        pub_clock = nh.advertise<rosgraph_msgs::Clock>("/clock", 10, false);
    }

    bool time_diff_initialized = false;
    ros::Duration time_diff_bag_real;

	// Loop over messages and write topics to output bag file
	BOOST_FOREACH(rosbag::MessageInstance const m, view) {

        if (!time_diff_initialized) {
            time_diff_bag_real = ros::Time(ros::WallTime::now().toSec()) - m.getTime();
            time_diff_initialized = true;
        }

        if (m.getTopic().find("/_trigger") != std::string::npos) {

            std_msgs::BoolConstPtr img_rgb_trigger = m.instantiate<std_msgs::Bool>();
            std_msgs::Float64ConstPtr img_depth_trigger = m.instantiate<std_msgs::Float64>();

            std::string image_topic = m.getTopic();
            image_topic.replace(image_topic.end() - 9, image_topic.end(), "");

            std::map<std::string, cv::VideoCapture*>::iterator it_vc = topic_to_video_capture.find(image_topic);
            if (it_vc == topic_to_video_capture.end()) {
                ROS_ERROR("Image topic %s was not specified in YAML file.", image_topic.c_str());
                exit(-1);
            }
            cv::VideoCapture* video_capture = it_vc->second;

            if (img_rgb_trigger) {
                (*video_capture) >> rgb_frame;

                if( rgb_frame.empty()) {
                    ROS_ERROR("Unexpected end of video!");
                }

                // Add image, frame and encoding to the image message
                rgb_img_ptr->image = rgb_frame;
                rgb_img = rgb_img_ptr->toImageMsg();
                rgb_img->header.frame_id = "/openni_rgb_optical_frame";
                rgb_img->header.stamp = m.getTime();
                rgb_img->encoding = "bgr8";

                std::map<std::string, ros::Publisher>::iterator it_publisher = topic_to_publisher.find(image_topic);
                ros::Publisher pub;

                if (it_publisher == topic_to_publisher.end()) {
                     pub = nh.advertise<sensor_msgs::Image>(image_topic, 10, false);
                     topic_to_publisher[image_topic] = pub;
                } else {
                    pub = it_publisher->second;
                }
                ros::WallTime::sleepUntil(ros::WallTime((m.getTime() + time_diff_bag_real).toSec()));
                pub.publish(rgb_img);

            } else if (img_depth_trigger) {
                (*video_capture) >> depth_frame;

                if(depth_frame.empty()) {
                    ROS_ERROR("Unexpected end of depth video!");
                }

                cv::Mat depth_mat(depth_frame.rows, depth_frame.cols, CV_32FC1);

                for(int y = 0; y < depth_frame.rows; y++) {
                    for(int x = 0; x < depth_frame.cols; x++) {
                        unsigned char dist_char = depth_frame.at<cv::Vec3b>(y, x)[0];
                        float distance = (float)dist_char / 255 * img_depth_trigger->data;
                        depth_mat.at<float>(y, x) = distance;
                    }
                }

                // Add image, frame and encoding to the image message
                depth_img_ptr->image = depth_mat;
                depth_img = depth_img_ptr->toImageMsg();
                depth_img->header.frame_id = "/openni_rgb_optical_frame";
                depth_img->header.stamp = m.getTime();
                depth_img->encoding = "32FC1";

                std::map<std::string, ros::Publisher>::iterator it_publisher = topic_to_publisher.find(image_topic);
                ros::Publisher pub;

                if (it_publisher == topic_to_publisher.end()) {
                     pub = nh.advertise<sensor_msgs::Image>(image_topic, 10, false);
                     topic_to_publisher[image_topic] = pub;
                } else {
                    pub = it_publisher->second;
                }

                ros::WallTime::sleepUntil(ros::WallTime((m.getTime() + time_diff_bag_real).toSec()));
                pub.publish(depth_img);

            } else {
                ROS_ERROR("Unknown trigger topic: %s", m.getTopic().c_str());
            }
        } else {
            // any other message type

            std::map<std::string, ros::Publisher>::iterator it_publisher = topic_to_publisher.find(m.getTopic());
            ros::Publisher pub;
            if (it_publisher == topic_to_publisher.end()) {
                ros::AdvertiseOptions opts = ros::AdvertiseOptions(m.getTopic(), 10, m.getMD5Sum(), m.getDataType(), m.getMessageDefinition());
                pub = nh.advertise(opts);
                topic_to_publisher[m.getTopic()] = pub;
            } else {
                pub = it_publisher->second;
            }

            ros::WallTime::sleepUntil(ros::WallTime((m.getTime() + time_diff_bag_real).toSec()));
            pub.publish(m);
        }

        if (publish_clock) {
            rosgraph_msgs::Clock clock_msg;
            clock_msg.clock = m.getTime();
            pub_clock.publish(clock_msg);
        }

        // Stop if user interrupted or if ROS core is no longer available
        if (!ros::ok()) {
            break;
        }

	}

    for (std::map<std::string, cv::VideoCapture*>::iterator it_vc = topic_to_video_capture.begin(); it_vc != topic_to_video_capture.end(); ++it_vc) {
        delete it_vc->second;
    }

	bag_in.close();
    ROS_INFO("Finished playing");

	return 0;

}
