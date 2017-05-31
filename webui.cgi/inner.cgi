#!/bin/bash 
# Control the environment from here for security and other reasons.
#PATH=""
#export PATH
#/usr/common/usg/languages/perl/5.16.0/bin/perl -I`pwd` -T inner.pl

PERL5LIB=`pwd`
export PERL5LIB

export TMP="/opt/img/temp"
export TEMP="/opt/img/temp"
export TEMPDIR="/opt/img/temp"
export TMPDIR="/opt/img/temp"
export SQLITE_TMPDIR="/opt/img/temp" 

/webfs/projectdirs/microbial/img/bin/imgEnv2 perl -T inner.pl

if [ $? != "0" ] 
then
   echo "<font color='red'>"
   echo "ERROR: Perl taint (-T) security violation or other error." 
   echo "Check web server error log for details."
   echo "</font>"
fi
