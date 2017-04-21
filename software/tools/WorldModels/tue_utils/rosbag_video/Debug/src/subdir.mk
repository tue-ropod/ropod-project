################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/bag_to_video.cpp \
../src/play.cpp \
../src/video_to_bag.cpp 

OBJS += \
./src/bag_to_video.o \
./src/play.o \
./src/video_to_bag.o 

CPP_DEPS += \
./src/bag_to_video.d \
./src/play.d \
./src/video_to_bag.d 


# Each subdirectory must supply rules for building sources it contributes
src/bag_to_video.o: ../src/bag_to_video.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross G++ Compiler'
	g++ -I/opt/ros/kinetic/include -I/home/ropod/ropod-project/software/tools/WorldModels/wire/wire_msgs/msg_gen/cpp/include -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"src/bag_to_video.d" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/play.o: ../src/play.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross G++ Compiler'
	g++ -I/opt/ros/kinetic/include -I/home/ropod/ropod-project/software/tools/WorldModels/wire/ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"src/play.d" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross G++ Compiler'
	g++ -I/opt/ros/kinetic/include -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


