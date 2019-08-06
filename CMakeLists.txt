cmake_minimum_required(VERSION 2.8.3)
project(Gmapping)

#设置软件的版本
set(GMAPPING_MAJOR_VERSION 0)
set(GMAPPING_MINOR_VERSION 1)
set(GMAPPING_PATCH_VERSION 0)
set(GMAPPING_VERSION
  ${GMAPPING_MAJOR_VERSION}.${GMAPPING_MINOR_VERSION}.${GMAPPING_PATCH_VERSION})

# Offer the user the choice of overriding the installation directories
set(INSTALL_LIB_DIR lib CACHE PATH "Installation directory for libraries")
set(INSTALL_BIN_DIR bin CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDE_DIR include CACHE PATH
  "Installation directory for header files")



#默认安装路径是/usr/local，因而GmappingConfig.cmake是安装在/usr/local/lib/cmake/gmapping下
if(WIN32 AND NOT CYGWIN)
  set(DEF_INSTALL_CMAKE_DIR CMake)
else()
  set(DEF_INSTALL_CMAKE_DIR lib/cmake/gmapping)
endif()
set(INSTALL_CMAKE_DIR ${DEF_INSTALL_CMAKE_DIR} CACHE PATH
  "Installation directory for CMake files")



# Make relative paths absolute (needed later on)
foreach(p LIB BIN INCLUDE CMAKE)
  set(var INSTALL_${p}_DIR)
  if(NOT IS_ABSOLUTE "${${var}}")
    set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
  endif()
endforeach()

message("${INSTALL_INCLUDE_DIR}")


# set up include-directories
include_directories(
  "${PROJECT_SOURCE_DIR}"   # to find foo/foo.h
  "${PROJECT_BINARY_DIR}")  # to find foo/config.h




## Specify additional locations of header files
## Your package locations should be listed before other locations
include_directories(include)

#SUBDIRS=utils sensor log configfile scanmatcher gridfastslam gui

#此处，可以将所有的库文件打包成为一个整体的库，也可以对每个进行单独打包
#前者文件大小会大一点，但是不用在使用时具体区分依赖哪个具体的库，而是直接link这个，但后者文件会小一点
#但是用后者单独编译某些小库时候可能存在相互依赖关系，因而也要对编译出来的库设置target_link_libraries，而不仅仅是可执行的文件需要

set(GMAPPING_LIBRARIES_SRC  utils/stat.cpp
                            utils/movement.cpp
                            sensor/sensor_base/sensor.cpp
                            sensor/sensor_base/sensorreading.cpp
                            sensor/sensor_odometry/odometrysensor.cpp
                            sensor/sensor_odometry/odometryreading.cpp
                            sensor/sensor_range/rangesensor.cpp
                            sensor/sensor_range/rangereading.cpp
                            sensor/sensor_range/rangesensor.cpp
                            sensor/sensor_range/rangereading.cpp
                            log/configuration.cpp
                            log/carmenconfiguration.cpp
                            log/sensorlog.cpp
                            log/sensorstream.cpp
                            configfile/configfile.cpp
                            scanmatcher/smmap.cpp
                            scanmatcher/scanmatcher.cpp
                            scanmatcher/scanmatcherprocessor.cpp
                            scanmatcher/eig3.cpp
                            gridfastslam/gridslamprocessor_tree.cpp
                            gridfastslam/motionmodel.cpp
                            gridfastslam/gridslamprocessor.cpp
                            gridfastslam/gfsreader.cpp)

add_library(Gmapping ${GMAPPING_LIBRARIES_SRC})



add_executable(autoptr_test
  utils/autoptr_test.cpp)

add_executable(log_test
  log/log_test.cpp)
add_executable(log_plot
  log/log_plot.cpp)
add_executable(scanstudio2carmen
  log/scanstudio2carmen.cpp)
add_executable(rdk2carmen
  log/rdk2carmen.cpp)
target_link_libraries(log_test Gmapping)
target_link_libraries(log_plot Gmapping)
target_link_libraries(scanstudio2carmen Gmapping)
target_link_libraries(rdk2carmen Gmapping)


add_executable(configfile_test
  configfile/configfile_test.cpp)
target_link_libraries(configfile_test Gmapping)


add_executable(scanmatch_test
  scanmatcher/scanmatch_test.cpp)
add_executable(icptest
  scanmatcher/icptest.cpp)
target_link_libraries(scanmatch_test Gmapping)
target_link_libraries(icptest Gmapping)

add_executable(gfs2log
  gridfastslam/gfs2log.cpp)
add_executable(gfs2rec
  gridfastslam/gfs2rec.cpp)
add_executable(gfs2neff
  gridfastslam/gfs2neff.cpp)
target_link_libraries(gfs2log Gmapping)
target_link_libraries(gfs2rec Gmapping)
target_link_libraries(gfs2neff Gmapping)


#############
## Install ##
#############


## Mark executable scripts (Python etc.) for installation
## in contrast to setup.py, you can choose the destination
# install(PROGRAMS
#   scripts/my_python_script
#   DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
# )

## Mark executables and/or libraries for installation
#install(TARGETS utils autoptr_test sensor_base sensor_odometry sensor_range log log_test log_plot scanstudio2carmen rdk2carmen configfile configfile_test scanmatcher scanmatch_test icptest gridfastslam gfs2log gfs2rec gfs2neff
install(TARGETS Gmapping
  EXPORT GmappingExport
  ARCHIVE DESTINATION /usr/lib/gmapping
  LIBRARY DESTINATION /usr/lib/gmapping
  RUNTIME DESTINATION /usr/bin

)

## Mark cpp header files for installation
install(DIRECTORY include/gmapping
  DESTINATION ${INSTALL_INCLUDE_DIR}
  FILES_MATCHING PATTERN "*.h*"
  PATTERN ".svn" EXCLUDE
)

# The interesting stuff goes here
# ===============================

# Add all targets to the build-tree export set

#export(TARGETS utils autoptr_test sensor_base sensor_odometry sensor_range log log_test log_plot scanstudio2carmen rdk2carmen configfile configfile_test scanmatcher scanmatch_test icptest gridfastslam gfs2log gfs2rec gfs2neff
#  FILE "${PROJECT_BINARY_DIR}/GmappingTargets.cmake" )

install(EXPORT GmappingExport DESTINATION ${INSTALL_CMAKE_DIR} FILE GmappingTargets.cmake)


# Export the package for use from the build-tree
# (this registers the build-tree with a global CMake-registry)
export(PACKAGE Gmapping)

# Create the GmappingConfig.cmake and GmappingConfigVersion files
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}"
   "${INSTALL_INCLUDE_DIR}")


# ... for the build tree
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")


configure_file(GmappingConfig.cmake.in
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/GmappingConfig.cmake" @ONLY)

## ... for both
configure_file(GmappingConfigVersion.cmake.in
  "${PROJECT_BINARY_DIR}/GmappingConfigVersion.cmake" @ONLY)

## Install the GmappingConfig.cmake and GmappingConfigVersion.cmake
install(FILES
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/GmappingConfig.cmake"
  "${PROJECT_BINARY_DIR}/GmappingConfigVersion.cmake"
  DESTINATION "${INSTALL_CMAKE_DIR}")

#message("#########################")
#message("${INSTALL_CMAKE_DIR}")
#message("#########################")

#############
## Testing ##
#############

## Add gtest based cpp test target and link libraries
# catkin_add_gtest(${PROJECT_NAME}-test test/test_openslam_gmapping.cpp)
# if(TARGET ${PROJECT_NAME}-test)
#   target_link_libraries(${PROJECT_NAME}-test ${PROJECT_NAME})
# endif()

## Add folders to be run by python nosetests
# catkin_add_nosetests(test)
