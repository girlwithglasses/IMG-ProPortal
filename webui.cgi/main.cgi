#!/bin/bash 
# Control the environment from here for security and other reasons.
#
# $Id: main.cgi 35611 2016-05-08 21:22:50Z klchu $
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
/webfs/projectdirs/microbial/img/bin/imgEnv2 perl -T main.pl


if [ $? != "0" ] 
then
   echo "<br/><font color='red'>"
   echo "Oops. This is embarrassing an error has occurred.<br/>"
   echo "Please report this along with your steps on how to reproduce it.<br/>"
   echo "- IMG email: imgsupp at lists.jgi-psf.org"
   echo "</font>"
fi
