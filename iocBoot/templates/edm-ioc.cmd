#! /bin/bash

# Setup the common directory env variables
if [ -e /reg/g/pcds/pyps/config/common_dirs.sh ]; then
	source /reg/g/pcds/pyps/config/common_dirs.sh
else
	source /afs/slac/g/pcds/config/common_dirs.sh
fi

export IOC_PV=$$IOC_PV
export HUTCH=$$HUTCH

# Setup edm environment
source $SETUP_SITE_TOP/epicsenv-cur.sh
pushd $$RELEASE

# Launch edm
$$IF(TOP_SCREEN)
export TOP_SCREEN=$$TOP_SCREEN
edm -x -eolc	\
	-m "IOC=$$IOC_PV"	\
	-m "HUTCH=$$HUTCH"	\
	${TOP_SCREEN}  &

$$ELSE(TOP_SCREEN)

$$LOOP(PDU)
export TOP_SCREEN=`echo LevScreens/emb-$$(TYPE)_$$(N_CHAN).edl | sed -e s/Sentry4/Sentry/`
edm -x -eolc	\
	-m "IOC=$$IOC_PV"	\
	-m "HUTCH=$$HUTCH"	\
	-m "PRE=$$NAME"	\
	${TOP_SCREEN}  &
$$ENDLOOP(PDU)

$$ENDIF(TOP_SCREEN)
