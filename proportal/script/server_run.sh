#!/usr/bin/env bash

# cd ~/webUI/proportal && plackup -E development -s Starman --workers=16 -p 5013 bin/server-app.psgi &> ~/apache/logs/proportal.log &

declare -A PORT=( [dev]=5009 [test]=5013 )
declare -A APP=(  [dev]=proportal_dev [test]=proportal_test )
declare -A WORKERS=( [dev]=8 [test]=4 )
declare -A ENV=( [dev]='proportal-dev' [test]='proportal-test' )

# no arguments: assume that we're running the dev server
CURRENT='dev'

echo \$1 is \'$1\'

if [ ! -z $1 ]
then
	if [ $1 = 'test' ] || [ $1 = 'TEST' ]
	then
		CURRENT='test'
	fi
fi

# constants
# The actual path on disk to the application.
APP_HOME="$HOME/svn/webUI/proportal"

# start_server daemon
# DAEMON="$HOME/perl5/perlbrew/perls/current/bin/start_server"
DAEMON="start_server"

# This should be the directory name/app name
PIDFILE="$HOME/${APP[$CURRENT]}.pid"
STATUS="$HOME/${APP[$CURRENT]}.status"

# error log for the psgi app
ERROR_LOG="$HOME/logs/${APP[$CURRENT]}.error.log"

# starman command to run proportal-app-(test|dev).psgi
STARMAN="starman --workers ${WORKERS[$CURRENT]} --error-log $ERROR_LOG $APP_HOME/bin/server-app-$CURRENT.psgi"

PLACKUP="plackup -E ${ENV[$CURRENT]} -s Starman --workers=${WORKERS[$CURRENT]} $APP_HOME/bin/server-app-$CURRENT.psgi"

DAEMON_OPTS="--pid-file=$PIDFILE --status-file=$STATUS --port ${PORT[$CURRENT]} --daemonize --log-file=$ERROR_LOG -- $PLACKUP"


. $HOME/perl5/perlbrew/etc/bashrc

cd $APP_HOME

# Here you could even do something like this to ensure deps are there:
# cpanm --installdeps .

if [ -r $PIDFILE ]; then
	echo 'Found a PIDFILE; running restart'
	$DAEMON --restart $DAEMON_OPTS

	# If the restart failed (2 or 3) then try again. We could put in a kill.
	if [ $? -gt 0 ]; then
		echo "Restart failed; the application is probably not running. Starting..."
		# Rely on start-stop-daemon to run start_server in the background
		# The PID will be written by start_server
		# /sbin/start-stop-daemon --start --background --exec $DAEMON -- $DAEMON_OPTS
		$DAEMON $DAEMON_OPTS
	fi

fi

# otherwise, start the server instead
echo about to run $DAEMON $DAEMON_OPTS

$DAEMON $DAEMON_OPTS
