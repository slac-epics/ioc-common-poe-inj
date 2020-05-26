TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#==================================================
# Build an IOC support library

# build an ioc application

PROD_IOC_Linux = poe-inj
# poe-inj.dbd will be created and installed
DBD += poe-inj.dbd

# poe-inj.dbd will be made up from these files:
poe-inj_DBD +=	base.dbd
poe-inj_DBD +=	iocAdmin.dbd
poe-inj_DBD +=	asSupport.dbd
poe-inj_DBD +=	devSnmp.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
poe-inj_SRCS += poe-inj_registerRecordDeviceDriver.cpp
poe-inj_SRCS_DEFAULT += poe-injMain.cpp

# Add locally compiled object code
#poe-inj_SRCS += dbSubExample.c

# Add any needed libraries
poe-inj_LIBS += autosave
poe-inj_LIBS += devIocStats
poe-inj_LIBS += devSnmp
poe-inj_LIBS += $(EPICS_BASE_IOC_LIBS)

USR_LIBS	+= netsnmp
SYS_LIBS	+= crypto
netsnmp_DIR  = $(NET_SNMP)/lib
#USR_SYS_LDFLAGS	+= -L$(NET_SNMP)/lib

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

