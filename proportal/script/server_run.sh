#!/bin/bash

# cd ~/webUI/proportal && plackup -E development -s Starman --workers=16 -p 5013 bin/server-app.psgi &> ~/apache/logs/proportal.log &

PORT=4013

# This should be the directory name/app name
APP="proportal_test"
PIDFILE="$HOME/$APP.pid"
STATUS="$HOME/$APP.status"

# The actual path on disk to the application.
APP_HOME="$HOME/webUI/proportal"

# How many workers
WORKERS=16

# This is only relevant if using Catalyst
# TDP_HOME="$HOME/$APP"
# export TDP_HOME

ERROR_LOG="$HOME/logs/$APP.error.log"

STARMAN="starman --workers $WORKERS --error-log $ERROR_LOG $APP_HOME/bin/app.psgi"
DAEMON="$HOME/perl5/perlbrew/perls/current/bin/start_server"
DAEMON_OPTS="--pid-file=$PIDFILE --status-file=$STATUS --port $PORT -- $STARMAN"

. $HOME/perl5/perlbrew/etc/bashrc

cd $APP_HOME

# Here you could even do something like this to ensure deps are there:
# cpanm --installdeps .

$DAEMON --restart $DAEMON_OPTS

# If the restart failed (2 or 3) then try again. We could put in a kill.
if [ $? -gt 0 ]; then
    echo "Restart failed, application likely not running. Starting..."
    # Rely on start-stop-daemon to run start_server in the background
    # The PID will be written by start_server
    /sbin/start-stop-daemon --start --background --exec $DAEMON -- $DAEMON_OPTS
fi
