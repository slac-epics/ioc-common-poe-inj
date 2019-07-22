#!$$IOCTOP/bin/$$TARGET_ARCH/Leviton

# Run common startup commands for linux soft IOC's
< $(IOC_COMMON)/All/pre_linux.cmd

< envPaths
epicsEnvSet( "IOCNAME",      "$$IOCNAME" )
epicsEnvSet( "ENGINEER",     "$$ENGINEER" )
epicsEnvSet( "LOCATION",     "$$LOCATION" )
epicsEnvSet( "IOCSH_PS1",    "$(IOCNAME)> " )
epicsEnvSet( "IOC_PV",       "$$IOC_PV" )
epicsEnvSet( "IOCTOP",       "$$IOCTOP" )
epicsEnvSet( "BUILD_TOP",    "$$TOP" )
epicsEnvSet( "MIBDIRS",	  "$(IOCTOP)/mibs:/usr/share/snmp/mibs:/reg/g/pcds/package/net-snmp-5.7.2/share/snmp/mibs" )

# MIB walk variables.  This is more than a little bit hacky.
epicsEnvSet("FIRST_MIB_Sentry_24", "Sentry3-MIB::systemVersion.0")
epicsEnvSet("MIB_CNT_Sentry_24", "261")
epicsEnvSet("FIRST_MIB_Sentry4_24", "Sentry4-MIB::st4SystemProductName.0")
epicsEnvSet("MIB_CNT_Sentry4_24", "580")
cd( "$(IOCTOP)" )

# Set Max array size
epicsEnvSet( "EPICS_CA_MAX_ARRAY_BYTES", "$$IF(MAX_ARRAY,$$MAX_ARRAY,20000000)" )

# Register all support components
dbLoadDatabase("dbd/Leviton.dbd")
Leviton_registerRecordDeviceDriver(pdbbase)

$$IF(SNMP_WALK)
$$ELSE(SNMP_WALK)
# Add local mib directory
add_mibdir( "/usr/share/snmp/mibs" )
add_mibdir( "$(IOCTOP)/mibs" )
$$ENDIF(SNMP_WALK)

# Debug settings
SNMP_DEV_DEBUG( $$IF(SNMP_DEV_DEBUG,$$SNMP_DEV_DEBUG,0) )
SNMP_DRV_DEBUG( $$IF(SNMP_DRV_DEBUG,$$SNMP_DRV_DEBUG,0) )

# Each SNMP query message could query multi variables.
# This number needs to be the minimum one of all your agents
snmpMaxVarsPerMsg( $$IF(SNMP_MAX_PER_QUERY,$$SNMP_MAX_PER_QUERY,30) )

# Load soft ioc related record instances
dbLoadRecords( "db/iocSoft.db",				"IOC=$(IOC_PV)" )
dbLoadRecords( "db/iocRelease.db",			"IOC=$(IOC_PV)" )

# Load pdu instances
$$LOOP(PDU)
dbLoadRecords( "db/$$(TYPE)Pdu_$$(N_CHAN).db", "HOST=$$HOST,PRE=$$NAME" )

epicsEnvSet( "DEV_INFO", "DEV=$$NAME,IOC=$(IOC_PV),IOCNAME=$(IOCNAME)" )
epicsEnvSet( "DEV_INFO", "$(DEV_INFO),COM_TYPE=snmp,COM_PORT=$$HOST" )
$$IF(WEB_URL)
epicsEnvSet( "DEV_INFO", "$(DEV_INFO),WEB_URL=$$WEB_URL" )
$$ENDIF(WEB_URL)
$$IF(CAPTAR)
epicsEnvSet( "DEV_INFO", "$(DEV_INFO),CAPTAR=$$CAPTAR" )
$$ENDIF(CAPTAR)
dbLoadRecords( "db/devIocInfo.db",			"$(DEV_INFO)" )

$$ENDLOOP(PDU)

$$IF(SNMP_WALK)
read_mib( "$(IOCTOP)/mibs/SNMPv2-SMI.txt" )  # These must be before Snmp2cWalk!
read_mib( "$(IOCTOP)/mibs/SNMPv2-TC.txt" )
read_mib( "$(IOCTOP)/mibs/Sentry3.mib" )
read_mib( "$(IOCTOP)/mibs/Sentry4.mib" )
$$LOOP(PDU)
Snmp2cWalk("$$HOST", "public", "$(FIRST_MIB_$$(TYPE)_$$N_CHAN)", $(MIB_CNT_$$(TYPE)_$$N_CHAN), 2.0)
$$ENDLOOP(PDU)
$$ENDIF(SNMP_WALK)


# Setup autosave
dbLoadRecords( "db/save_restoreStatus.db",	"P=$(IOC_PV):" )
set_savefile_path( "$(IOC_DATA)/$(IOC)/autosave" )
set_requestfile_path( "$(BUILD_TOP)/autosave" )
# Also look in the iocData autosave folder for auto generated req files
set_requestfile_path( "$(IOC_DATA)/$(IOC)/autosave" )
save_restoreSet_status_prefix( "$(IOC_PV):" )
save_restoreSet_IncompleteSetsOk( 1 )
save_restoreSet_DatedBackupFiles( 1 )
set_pass0_restoreFile( "autoSettings.sav" )
set_pass0_restoreFile( "$(IOC).sav" )
set_pass1_restoreFile( "autoSettings.sav" )
set_pass1_restoreFile( "$(IOC).sav" )

$$IF(SNMP_WALK)
$$ELSE(SNMP_WALK)
# Read the mib files
read_mib( "$(IOCTOP)/mibs/SNMPv2-SMI.txt" )
read_mib( "$(IOCTOP)/mibs/SNMPv2-TC.txt" )
read_mib( "$(IOCTOP)/mibs/ibootbar_v1.50.258.mib" )
read_mib( "$(IOCTOP)/mibs/LEVPDU1.txt" )
$$ENDIF(SNMP_WALK)

#
# Initialize the IOC and start processing records
#
iocInit()

write_mib_tree( "$(IOC_DATA)/$(IOC)/iocInfo/mib_tree.txt" )

# Create autosave files from info directives
makeAutosaveFileFromDbInfo( "$(IOC_DATA)/$(IOC)/autosave/autoSettings.req", "autosaveFields" )

# Start autosave backups
create_monitor_set( "autoSettings.req",  5,  "" )
create_monitor_set( "$(IOCNAME).req",    5,  "" )

# All IOCs should dump some common info after initial startup.
< $(IOC_COMMON)/All/post_linux.cmd

