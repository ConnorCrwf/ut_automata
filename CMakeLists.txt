# Catkin User Guide: http://www.ros.org/doc/groovy/api/catkin/html/user_guide/user_guide.html
# Catkin CMake Standard: http://www.ros.org/doc/groovy/api/catkin/html/user_guide/standards.html
cmake_minimum_required(VERSION 2.8.3)
project(ut_automata)
# Load catkin and all dependencies required for this package
# TODO: remove all from COMPONENTS that are not catkin packages.
find_package(catkin REQUIRED COMPONENTS roscpp rosbag std_msgs geometry_msgs nav_msgs sensor_msgs serial tf amrl_msgs)

include_directories(include ${Boost_INCLUDE_DIR} ${catkin_INCLUDE_DIRS})
CMAKE_MINIMUM_REQUIRED(VERSION 3.1.0)

MESSAGE(STATUS "Compilers found: ${CMAKE_CXX_COMPILER_LIST}")
MESSAGE(STATUS "Using compiler: ${CMAKE_CXX_COMPILER}")
MESSAGE(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
MESSAGE(STATUS "Build Mode: ${CMAKE_BUILD_MODE}")
MESSAGE(STATUS "Arch: ${CMAKE_SYSTEM_PROCESSOR}")

SET(CMAKE_AUTOMOC ON)
SET(CMAKE_AUTORCC ON)
SET(CMAKE_AUTOUIC ON)

if(CMAKE_VERSION VERSION_LESS "3.7.0")
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
endif()

SET(CMAKE_CXX_FLAGS "-std=c++11 -march=native -Werror -Wall -Wno-stringop-truncation -Wno-deprecated-copy -g -rdynamic")

IF(${CMAKE_BUILD_TYPE} MATCHES "Release")
  MESSAGE(STATUS "Additional Flags for Release mode")
  SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -fopenmp -O3 -DNDEBUG")
ELSEIF(${CMAKE_BUILD_TYPE} MATCHES "Debug")
  MESSAGE(STATUS "Additional Flags for Debug mode")
  SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -g")
  SET(BUILD_SPECIFIC_LIBRARIES "")
ENDIF()

# INCLUDE($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)
# ROSBUILD_INIT()
# SET(ROS_BUILD_STATIC_LIBS true)
# SET(ROS_BUILD_SHARED_LIBS false)

find_package(Qt5 COMPONENTS Core Widgets Gui OpenGL WebSockets REQUIRED)
set(CMAKE_INCLUDE_CURRENT_DIR ON)


MESSAGE(STATUS "ROS-Overrride Build Type: ${CMAKE_BUILD_TYPE}")
MESSAGE(STATUS "CXX Flags: ${CMAKE_CXX_FLAGS}")
MESSAGE(STATUS "Build-Specific Libraries: ${BUILD_SPECIFIC_LIBRARIES}")

SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/submodules")

INCLUDE_DIRECTORIES(${PROJECT_BINARY_DIR})
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR})
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/src)
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/include)
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/submodules/config_reader/include)

# ROSBUILD_GENMSG()

ADD_SUBDIRECTORY(src/shared)
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/src/shared)

set(libs ${catkin_LIBRARIES} glog gflags amrl-shared-lib
    ${BUILD_SPECIFIC_LIBRARIES} X11 lua5.1 boost_system)

# node executable
IF(${CMAKE_BUILD_MODE} MATCHES "Hardware")
  MESSAGE(STATUS "Building hardware drivers")
  add_executable(vesc_driver
                          src/vesc_driver/vesc_driver_node.cpp
                          src/vesc_driver/vesc_driver.cpp
                          src/vesc_driver/vesc_interface.cpp
                          src/vesc_driver/vesc_packet.cpp
                          src/vesc_driver/vesc_packet_factory.cpp)
  target_link_libraries(vesc_driver ${libs})

  add_executable(gui
        src/gui/gui_main.cc
        src/gui/gui_mainwindow.cc
        src/gui/vector_display.cc
        ${GUI_MOC_SRCS})
  target_link_libraries(gui
        Qt5::Core
        Qt5::Gui
        Qt5::Widgets
        Qt5::OpenGL
        ${libs} ${OPENGL_LIBRARY} GL)

  add_executable(joystick
    src/joystick/joystick.cc
    src/joystick/joystick_driver.cc)
  target_link_libraries(joystick ${libs})
ENDIF()

MESSAGE(STATUS "Building simulator")

add_executable(simulator
    src/simulator/simulator.cc
    src/simulator/vector_map.cc
    src/simulator/simulator_main.cc)
target_link_libraries(simulator ${libs})

add_executable(websocket
    src/websocket/websocket_main.cc
    src/websocket/websocket.cc
)
target_link_libraries(websocket
    Qt5::Core
    Qt5::Gui
    Qt5::Widgets
    Qt5::WebSockets
    ${libs} ${OPENGL_LIBRARY} GL)
## Generate added messages and services with any dependencies listed here
#generate_messages(
#    #TODO DEPENDENCIES geometry_msgs std_msgs
#)

# catkin_package parameters: http://ros.org/doc/groovy/api/catkin/html/dev_guide/generated_cmake_api.html#catkin-package
# TODO: fill in what other packages will need to use this package
catkin_package(
    DEPENDS roscpp std_msgs geometry_msgs nav_msgs sensor_msgs serial tf amrl_msgs
    CATKIN_DEPENDS # TODO
    INCLUDE_DIRS # TODO include
    LIBRARIES # TODO
)