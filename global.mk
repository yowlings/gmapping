### You should not need to change anything below.
LINUX=1
MACOSX=0

# Compilers
CC=gcc
CXX=g++

# Paths
MAPPING_ROOT=/home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping
LIBDIR=/home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping/lib
BINDIR=/home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping/bin

# Build tools
PRETTY=/home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping/build_tools/pretty_compiler
MESSAGE=/home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping/build_tools/message
TESTLIB=/home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping/build_tools/testlib

# QT support
MOC=moc-qt3
QT_LIB=-lqt-mt
QT_INCLUDE=-I/usr/include/qt3

# ARIA support
ARIA_LIB=
ARIA_INCLUDE=


# # KDE support
# KDE_LIB=
# KDE_INCLUDE=
# UIC=

# Generic makefiles
MAKEFILE_GENERIC=/home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping/build_tools/Makefile.generic-shared-object
MAKEFILE_APP=/home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping/build_tools/Makefile.app
MAKEFILE_SUBDIRS=/home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping/build_tools/Makefile.subdirs


# Flags
CPPFLAGS+=-DLINUX -I/home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping 
CXXFLAGS+=
LDFLAGS+= -Xlinker -rpath /home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping/lib
CARMENSUPPORT=0
ARIASUPPORT=0



include /home/roc/ros_kinetic_ws/doni_ws/src/openslam_gmapping/manual.mk

