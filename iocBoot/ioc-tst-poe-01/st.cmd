#!/afs/slac.stanford.edu/g/pcds/vol2/users/bhill/git-wa/ioc/common/poe-inj-git/bin/rhel7-x86_64/ict

# Run common startup commands for linux soft IOC's
< $(IOC_COMMON)/All/pre_linux.cmd

< envPaths
epicsEnvSet( "IOCNAME",      "ioc-tst-poe-01" )
epicsEnvSet( "ENGINEER",     "sgess" )
epicsEnvSet( "LOCATION",     "?" )
epicsEnvSet( "IOCSH_PS1",    "$(IOCNAME)> " )
epicsEnvSet( "IOC_PV",       "IOC:TST:POE:01" )
epicsEnvSet( "IOCTOP",       "/afs/slac.stanford.edu/g/pcds/vol2/users/bhill/git-wa/ioc/common/poe-inj-git" )
epicsEnvSet( "BUILD_TOP",    "/afs/slac.stanford.edu/g/pcds/vol2/users/bhill/git-wa/ioc/common/poe-inj-git/children/build" )
epicsEnvSet( "MIBDIRS",	  "$(IOCTOP)/mibs:/usr/share/snmp/mibs:/reg/g/pcds/package/net-snmp-5.7.2/share/snmp/mibs" )

cd( "$(IOCTOP)" )

# Set Max array size
epicsEnvSet( "EPICS_CA_MAX_ARRAY_BYTES", "20000000" )

# Register all support components
dbLoadDatabase("dbd/ict.dbd")
ict_registerRecordDeviceDriver(pdbbase)

# Add local mib directory
add_mibdir( "/usr/share/snmp/mibs" )
add_mibdir( "$(IOCTOP)/mibs" )

# Debug settings
SNMP_DEV_DEBUG( 1 )
SNMP_DRV_DEBUG( 1 )

# Each SNMP query message could query multi variables.
# This number needs to be the minimum one of all your agents
snmpMaxVarsPerMsg( 60 )

# Load soft ioc related record instances
dbLoadRecords( "db/iocSoft.db",				"IOC=$(IOC_PV)" )
dbLoadRecords( "db/iocRelease.db",			"IOC=$(IOC_PV)" )

# Configure the ICT
dbLoadRecords( "db/ict.db", "HOST=plv-tst-pdu-01,PRE=TST:POE:01" )
dbLoadRecords( "db/ict24VbusA.db", "HOST=plv-tst-pdu-01,PRE=TST:POE:01" )
dbLoadRecords( "db/ict48VbusB.db", "HOST=plv-tst-pdu-01,PRE=TST:POE:01" )
epicsEnvSet( "DEV_INFO", "DEV=TST:POE:01,IOC=$(IOC_PV),IOCNAME=$(IOCNAME)" )
epicsEnvSet( "DEV_INFO", "$(DEV_INFO),COM_TYPE=snmp,COM_PORT=plv-tst-pdu-01" )
dbLoadRecords( "db/devIocInfo.db",			"$(DEV_INFO)" )


read_mib( "$(IOCTOP)/mibs/SNMPv2-SMI.txt" )  # These must be before Snmp2cWalk!
read_mib( "$(IOCTOP)/mibs/SNMPv2-TC.txt" )
read_mib( "$(IOCTOP)/mibs/ict_distribution_series_mib.mib" )
Snmp2cWalk("plv-tst-pdu-01", "write", "ICT-MIB::deviceModel", 95, 2.0)

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