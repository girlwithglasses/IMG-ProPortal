#!/bin/bash 
# Control the environment from here for security and other reasons.
#
# $Id: main.cgi 37087 2017-05-18 17:25:52Z klchu $
#
# http://aaroncrane.co.uk/2009/02/perl_safe_signals/
#
PATH="/usr/bin:/bin"
export PATH
LD_LIBRARY_PATH=""
export LD_LIBRARY_PATH

#/usr/bin/env PERL_SIGNALS=unsafe /usr/local/bin/perl -I`pwd` -T  main.pl 
# /usr/common/usg/languages/perl
#/usr/bin/env PERL_SIGNALS=unsafe /usr/common/usg/languages/perl/5.16.0/bin/perl -I`pwd` -T  main.pl 

PERL5LIB=`pwd`
export PERL5LIB

# default main.pl will change it to another value I hope - ken
export TMP="/opt/img/temp"
export TEMP="/opt/img/temp"
export TEMPDIR="/opt/img/temp"
export TMPDIR="/opt/img/temp"
export SQLITE_TMPDIR="/opt/img/temp"
#export TESTDIR="/opt/img/temp"

/webfs/projectdirs/microbial/img/bin/imgEnv2 perl -T main.pl


if [ $? != "0" ] 
then
   echo "<br/><font color='red'>"
   echo "Oops. This is embarrassing an error has occurred.<br/>"
   echo "Please report this along with your steps on how to reproduce it.<br/>"
   echo "- IMG email: jgi-imgsupp at lists.lbl.gov"
   echo "</font>"
fi
