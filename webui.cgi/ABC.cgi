#!/bin/bash 
# Control the environment from here for security and other reasons.
#
# $Id: ABC.cgi 37087 2017-05-18 17:25:52Z klchu $
#
PATH="/usr/bin:/bin"
export PATH
LD_LIBRARY_PATH=""
export LD_LIBRARY_PATH

export TMP="/opt/img/temp"
export TEMP="/opt/img/temp"
export TEMPDIR="/opt/img/temp"
export TMPDIR="/opt/img/temp"
export SQLITE_TMPDIR="/opt/img/temp" 

#/webfs/projectdirs/microbial/img/bin/imgEnv2 python ABC.py 2>> /webfs/scratch/img/logs/ABC.log
/webfs/projectdirs/microbial/img/bin/imgEnv2 python ABC.py


if [ $? != "0" ] 
then
   echo "<br/><font color='red'>"
   echo "Oops. This is embarrassing an error has occurred.<br/>"
   echo "Please report this along with your steps on how to reproduce it.<br/>"
   echo "- IMG email: jgi-imgsupp at lists.lbl.gov "
   echo "</font>"
fi
