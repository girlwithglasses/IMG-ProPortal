#!/usr/bin/env bash

# constants
# The actual path on disk to the applications.
APP_HOME=/global/homes/w/wwwimg/svn/webUI/proportal/

# directory where perlbrew is installed
PERLBREW_BASE=/global/homes/w/wwwimg

if [ $1 = '--script' ]; then
	SCRIPT_NAME="script/galaxy/${2}.pl";
	if [ -f "${APP_HOME}${SCRIPT_NAME}" ]; then
		# good to go!
		shift; shift;
#		echo "DANCER_ENVIRONMENT='proportal-galaxy' perl $SCRIPT_NAME $@"
		# init the perl environment, run the script.
		. ${PERLBREW_BASE}/perl5/perlbrew/etc/bashrc
		cd $APP_HOME
		DANCER_ENVIRONMENT='proportal-galaxy' perl $SCRIPT_NAME $@
	else
		echo "Could not find script ${APP_HOME}${SCRIPT_NAME}. Dying!"
	fi
fi

