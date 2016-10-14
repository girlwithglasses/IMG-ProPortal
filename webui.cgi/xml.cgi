#!/bin/bash

#
# xml.cgi to create XML data objects from server.
#
# see xml.pl
#
# $Id: xml.cgi 35611 2016-05-08 21:22:50Z klchu $
#
# Control the environment from here for security and other reasons.
#
#
# http://aaroncrane.co.uk/2009/02/perl_safe_signals/
#
PATH="/usr/bin:/bin"
export PATH
LD_LIBRARY_PATH=""
export LD_LIBRARY_PATH
#/usr/bin/env PERL_SIGNALS=unsafe /usr/local/bin/perl -I`pwd` -T xml.pl
#/usr/bin/env PERL_SIGNALS=unsafe /usr/common/usg/languages/perl/5.16.0/bin/perl -I`pwd` -T  xml.pl

PERL5LIB=`pwd`
export PERL5LIB
/webfs/projectdirs/microbial/img/bin/imgEnv2 perl -T xml.pl  


if [ $? != "0" ] 
then
   echo "<font color='red'>"
   echo "Oops. This is embarrassing an error has occurred in our AJAX script."
   echo "Please reports this along with your steps on how to reproduce it."
   echo "- IMG email: imgsupp at lists.jgi-psf.org"
   echo "</font>"
fi
