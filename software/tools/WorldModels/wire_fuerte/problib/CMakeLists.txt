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
rosbuild_genmsg()
#uncomment if you have defined services
#rosbuild_gensrv()

#common commands for building c++ executables and libraries
#target_link_libraries(${PROJECT_NAME} another_library)
#rosbuild_add_boost_directories()
#rosbuild_link_boost(${PROJECT_NAME} thread)

# To find eigen:
#find_package(Eigen REQUIRED)
#include_directories(${Eigen_INCLUDE_DIRS})
#list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
#include_directories(${EIGEN_INCLUDE_DIRS})

# to show include files in Qt Creator
file(GLOB_RECURSE INCLUDE_FILES include/*.h)

rosbuild_add_library(problib src/pdfs/PDF.cpp
                             src/pdfs/Gaussian.cpp
                             src/pdfs/Uniform.cpp
                             src/pdfs/Mixture.cpp
                             src/pdfs/Hybrid.cpp
                             src/pdfs/PMF.cpp
                             src/conversions.cpp
                             ${INCLUDE_FILES}
                             
)
#target_link_libraries(problib armadillo)

rosbuild_add_executable(problib_test src/test.cpp)
target_link_libraries(problib_test problib rt)

#target_link_libraries(example ${PROJECT_NAME})
