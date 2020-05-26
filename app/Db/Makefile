TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

#----------------------------------------------------
#  Optimization of db files using dbst (DEFAULT: NO)
#DB_OPT = YES

#
# The naming convention here is used by templated IOCs based on N_CHAN
# Templates are named based on the component, w/ PDU as the top and
# zero or more components such as outlets and sensors 
#
# To add support for a new PDU type, create templates for each component
# To add support for a new N_CHAN variant, add *_$(N_CHAN).sub* files
#    and build them w/ new DB, ARCHIVE, and REQ lines below.
#

#----------------------------------------------------
# Create and install (or just install)
# databases, templates, substitutions like this

# Built from substitution files
DB += poe-inj.db
#DB += ict.db
#DB += ict24VbusA.db
#DB += ict24VbusB.db
#DB += ict48VbusA.db
#DB += ict48VbusB.db

#IOCRELEASE_DB += iocRelease.db

#----------------------------------------------------
# Create and install (or just install)
# Archive files, templates, substitutions like this
#
#ARCHIVE += ictIoc.archive
#ARCHIVE += ictPdu.archive

#----------------------------------------------------
# Create and install (or just install)
# Autosave request files, templates, substitutions like this
#
#REQ	+=  ictIoc.req
#REQ	+=  ictPdu.req

# Nothing to build for autosave, just install from $AUTOSAVE/db
#DB_INSTALLS += $(AUTOSAVE)/db/save_restoreStatus.db
#DB_INSTALLS += $(IOCADMIN)/db/iocSoft.db
#DB_INSTALLS += $(IOCADMIN)/db/devIocInfo.db

#install:	showme

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

showme:
	@echo DBDEPENDS_FILES=$(DBDEPENDS_FILES)
	@echo DBDDEPENDS_FILES=$(DBDDEPENDS_FILES)

