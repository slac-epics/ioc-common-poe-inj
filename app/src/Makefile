TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#==================================================
# Build an IOC support library

# build an ioc application

PROD_IOC_Linux = ict
# ict.dbd will be created and installed
DBD += ict.dbd

# ict.dbd will be made up from these files:
ict_DBD +=	base.dbd
ict_DBD +=	iocAdmin.dbd
ict_DBD +=	asSupport.dbd
ict_DBD +=	devSnmp.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
ict_SRCS += ict_registerRecordDeviceDriver.cpp
ict_SRCS_DEFAULT += ictMain.cpp

# Add locally compiled object code
#ict_SRCS += dbSubExample.c

# Add any needed libraries
ict_LIBS += autosave
ict_LIBS += devIocStats
ict_LIBS += devSnmp
ict_LIBS += $(EPICS_BASE_IOC_LIBS)

USR_LIBS	+= netsnmp
SYS_LIBS	+= crypto
netsnmp_DIR  = $(NET_SNMP)/lib
#USR_SYS_LDFLAGS	+= -L$(NET_SNMP)/lib

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

