cmake_minimum_required(VERSION 2.4.6)
include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)

# Set the build type.  Options are:
#  Coverage       : w/ debug symbols, w/o optimization, w/ code-coverage
#  Debug          : w/ debug symbols, w/o optimization
#  Release        : w/o debug symbols, w/ optimization
#  RelWithDebInfo : w/ debug symbols, w/ optimization
#  MinSizeRel     : w/o debug symbols, w/ optimization, stripped binaries
#set(ROS_BUILD_TYPE RelWithDebInfo)
set(ROS_BUILD_TYPE Debug)

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

# to show include files in Qt Creator
file(GLOB_RECURSE HEADER_FILES include/*.h)

rosbuild_add_library(wire                  

                        src/WorldModelROS.cpp
                        src/models/FixedState.cpp
                        
                        src/core/datatypes.cpp
                        src/core/ClassModel.cpp
                        src/core/Property.cpp
                        src/core/Evidence.cpp
                        src/core/EvidenceSet.cpp
                        src/core/PropertySet.cpp

                        src/storage/SemanticObject.cpp
                        src/storage/ObjectStorage.cpp
                        src/storage/KnowledgeDatabase.cpp

                        src/util/ObjectModelParser.cpp

                        src/logic/Assignment.cpp
                        src/logic/AssignmentSet.cpp
                        src/logic/AssignmentMatrix.cpp
                        src/logic/Hypothesis.cpp
                        src/logic/HypothesesTree.cpp
                        ${HEADER_FILES}
)

target_link_libraries(wire tinyxml)

rosbuild_add_executable(wire_server src/world_model.cpp) 
target_link_libraries(wire_server wire)

rosbuild_add_executable(dummy_publisher src/dummy_evidence_publisher.cpp) 
