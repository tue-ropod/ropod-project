cmake_minimum_required(VERSION 2.4.6)
include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)

# Set the build type.  Options are:
#  Coverage       : w/ debug symbols, w/o optimization, w/ code-coverage
#  Debug          : w/ debug symbols, w/o optimization
#  Release        : w/o debug symbols, w/ optimization
#  RelWithDebInfo : w/ debug symbols, w/ optimization
#  MinSizeRel     : w/o debug symbols, w/ optimization, stripped binaries
#set(ROS_BUILD_TYPE RelWithDebInfo)

rosbuild_init()

#set the default path for built executables to the "bin" directory
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
#set the default path for built libraries to the "lib" directory
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)

#uncomment if you have defined messages
#rosbuild_genmsg()
#uncomment if you have defined services
#rosbuild_gensrv()

#common commands for building c++ executables and libraries
#rosbuild_add_library(${PROJECT_NAME} src/example.cpp)
#target_link_libraries(${PROJECT_NAME} another_library)
#rosbuild_add_boost_directories()
#rosbuild_link_boost(${PROJECT_NAME} thread)
#rosbuild_add_executable(example examples/example.cpp)
#target_link_libraries(example ${PROJECT_NAME})

rosbuild_download_test_data(https://roboticssrv.wtb.tue.nl/svn/data/recorded/rosbags/world_model_tutorials/demo01.tar.gz data/demo01.tar.gz b87ae83fdd8eee9c0dcfbb81074474db)
rosbuild_download_test_data(https://roboticssrv.wtb.tue.nl/svn/data/recorded/rosbags/world_model_tutorials/demo02.tar.gz data/demo02.tar.gz c7b73565d908227e3e00b084986309d1)
rosbuild_download_test_data(https://roboticssrv.wtb.tue.nl/svn/data/recorded/rosbags/world_model_tutorials/demo03.tar.gz data/demo03.tar.gz 76906155deb8fccfeb76ff089341dd86)
rosbuild_download_test_data(https://roboticssrv.wtb.tue.nl/svn/data/recorded/rosbags/world_model_tutorials/demo04.tar.gz data/demo04.tar.gz 4a79460232bd8605a53cc764a5024c71)
rosbuild_download_test_data(https://roboticssrv.wtb.tue.nl/svn/data/recorded/rosbags/world_model_tutorials/demo05.tar.gz data/demo05.tar.gz acfd06ccc5293599dbf4d274af78c22e)
rosbuild_download_test_data(https://roboticssrv.wtb.tue.nl/svn/data/recorded/rosbags/world_model_tutorials/demo_amigo.tar.gz data/demo_amigo.tar.gz a74e18691918c8a50f6896c486c8e8be)

rosbuild_untar_file(data/demo01.tar.gz data/demo01 tests)
rosbuild_untar_file(data/demo02.tar.gz data/demo02 tests)
rosbuild_untar_file(data/demo03.tar.gz data/demo03 tests)
rosbuild_untar_file(data/demo04.tar.gz data/demo04 tests)
rosbuild_untar_file(data/demo05.tar.gz data/demo05 tests)
rosbuild_untar_file(data/demo_amigo.tar.gz data/demo_amigo tests)

rosbuild_add_executable(generate_evidence src/generate_evidence.cpp)
rosbuild_add_executable(get_world_state src/get_world_state.cpp)
