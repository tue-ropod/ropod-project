/*
 * merge_video_bag.cpp
 *
 *  Created on: Oct 19, 2012
 *      Author: jelfring
 */

// ROS
#include <ros/ros.h>

// OpenCv
#include <opencv/cv.hpp>
#include <opencv2/highgui.hpp>

// For transforming ROS/OpenCV images
#include <cv_bridge/cv_bridge.h>
#include <sensor_msgs/image_encodings.h>

// Messages
#include "sensor_msgs/Image.h"
#include "tf/tfMessage.h"
#include "wire_msgs/WorldEvidence.h"
#include "sensor_msgs/CameraInfo.h"
#include <std_msgs/Bool.h>
#include <std_msgs/Float64.h>

// Bag files
#include <rosbag/bag.h>
#include <rosbag/view.h>

#include "yaml-cpp/yaml.h"

#include <fstream>

// Boost
#include <boost/foreach.hpp>
#include <boost/filesystem.hpp>
#include "boost/format.hpp"

int main( int argc, char** argv ) {

    if (argc < 2 || argc > 3) {
        std::cout << "Please give yaml file as argument." << std::endl;
        exit(-1);
    }

    std::string filename = argv[1];

    std::cout << filename << std::endl;

    std::ifstream fin(filename.c_str());
    if (fin.fail()) {
        ROS_ERROR("Could not open %s.", filename.c_str());
        exit(-1);
    }

    // Default values
    std::string bag_in_name = "";
    std::string bag_out_name = "final.bag";
    if (argc == 3) {
        bag_out_name = argv[2];
    }

    // load file names from yaml file
    YAML::Parser parser(fin);
    YAML::Node doc = YAML::Load(fin);

    try {
    	bag_in_name = doc["bag"].Tag();
    } catch (YAML::InvalidScalar) {
        ROS_ERROR("The input file does not contain a bag tag or is invalid.");
        exit(-1);
    }

    const YAML::Node n_videos = doc["videos"];
    if (!n_videos) {
        ROS_ERROR("The input file does not contain a video tag or is invalid.");
        exit(-1);
    }

    std::map<std::string, cv::VideoCapture*> topic_to_video_capture;

    for (YAML::const_iterator it_n_video = n_videos.begin(); it_n_video != n_videos.end(); ++it_n_video) {
        std::string video_filename;
        std::string video_topic;
        const YAML::Node& video = *it_n_video;

        try {
        	video_filename = video["file"].as<std::string>();
        	video_topic = video["topic"].as<std::string>();
          //(*it_n_video)["file"] >> video_filename;
          //(*it_n_video)["topic"] >> video_topic;
        } catch (YAML::InvalidScalar) {
            ROS_ERROR("Invalid video specification: should contain 'file' and 'topic'.");
            exit(-1);
        }

        cv::VideoCapture* video_capture = new cv::VideoCapture(video_filename);

        if (!video_capture->isOpened()) {
            ROS_ERROR("Unable to open video: %s", video_filename.c_str());
            return 0;
        } else ROS_INFO("Opened video %s for topic %s", video_filename.c_str(), video_topic.c_str());

        topic_to_video_capture[video_topic] = video_capture;
    }

    // Check input
	if (bag_in_name == "") {
		ROS_ERROR("No input bag file defined!");
		return -1;
	}

	// Load input bag file
	rosbag::Bag bag_in;
    bag_in.open(bag_in_name, rosbag::bagmode::Read);
	ROS_INFO("Opened %s", bag_in_name.c_str());

	// Create output bag file
	rosbag::Bag bag_out;
    bag_out.open(bag_out_name, rosbag::bagmode::Write);
	ROS_INFO("Created %s", bag_out_name.c_str());

	// Get topics and time from input bag file
    rosbag::View view(bag_in);

    cv::Mat rgb_frame;
    cv_bridge::CvImagePtr rgb_img_ptr(new cv_bridge::CvImage);
    sensor_msgs::ImagePtr rgb_img;

    cv::Mat depth_frame;
    cv_bridge::CvImagePtr depth_img_ptr(new cv_bridge::CvImage);
    sensor_msgs::ImagePtr depth_img;

	// Loop over messages and write topics to output bag file
	BOOST_FOREACH(rosbag::MessageInstance const m, view) {

		// Get data
		tf::tfMessageConstPtr transform = m.instantiate<tf::tfMessage>();
		wire_msgs::WorldEvidenceConstPtr evidence = m.instantiate<wire_msgs::WorldEvidence>();
        std_msgs::BoolConstPtr img_rgb_trigger = m.instantiate<std_msgs::Bool>();
        std_msgs::Float64ConstPtr img_depth_trigger = m.instantiate<std_msgs::Float64>();
        sensor_msgs::CameraInfoConstPtr cam_info = m.instantiate<sensor_msgs::CameraInfo>();

		// Tfs
        if (transform) {
            bag_out.write(m.getTopic(), m.getTime(), transform);
		}

		// World evidence
        if (evidence) {
            bag_out.write(m.getTopic(), m.getTime(), evidence);
		}

        if (cam_info) {
            bag_out.write(m.getTopic(), m.getTime(), cam_info);
        }

        if (m.getTopic().find("/_trigger") != std::string::npos) {
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

                // Write to bag file
                bag_out.write(image_topic, m.getTime(), rgb_img);
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

                // Write to bag file
                bag_out.write(image_topic, m.getTime(), depth_img);
            } else {
                ROS_ERROR("Unknown trigger topic: %s", m.getTopic().c_str());
            }
        }
	}

    for (std::map<std::string, cv::VideoCapture*>::iterator it_vc = topic_to_video_capture.begin(); it_vc != topic_to_video_capture.end(); ++it_vc) {
        delete it_vc->second;
    }

	bag_in.close();
	bag_out.close();
	ROS_INFO("Finished bag file");

	return 0;

}
