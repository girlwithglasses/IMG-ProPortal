This was tested on xubuntu 16 LTS
- ken

> export PERLBREW_ROOT=/home/kchu/perl5
> curl -L https://install.perlbrew.pl | bash

# do this every time you login
> source ~/perl5/etc/bashrc

# for help
> perlbrew 

> perlbrew install-cpanm
> perlbrew install-patchperl
> perlbrew install perl-5.18.4

# if there are some small test errors try:ls
> cd /home/kchu/perl5/build/perl-5.18.4; make install

> perlbrew lib create perl-5.18.4@std
> perlbrew switch perl-5.18.4@std

# I had to install this first!
# found these issues after iteration the cmd of "cpanm --cpanfile ...." below
> cpanm 'Devel::GlobalDestruction'
> cpanm 'Stream::Buffered'
> cpanm 'IO::Handle::Util'
> cpanm 'Algorithm::Diff'
> cpanm 'Class::Method::Modifiers'

# Now my svn code is at ~/webUI/
> cpanm --cpanfile ~/webUI/proportal/cpanfile --installdeps ~/webUI/proportal/

> cpanm http://search.cpan.org/CPAN/authors/id/M/MJ/MJEVANS/DBD-Oracle-1.75_2.tar.gz
> cpanm CJFIELDS/BioPerl-1.6.924.tar.gz

#
#
#

# edit /etc/hosts
chu@kchu-laptop:~$ more  /etc/hosts
127.0.0.1 localhost img-proportal.dev img-galaxy.dev
127.0.1.1 kchu-laptop


sudo a2enmod rewrite
sudo a2enmod proxy
sudo a2enmod expires
sudo service apache2 restart
# check /etc/apache2/mods-enabled

cd /etc/apache2/conf-enabled
sudo ln -s ~/webUI/proportal/apache/sample_server.conf .
sudo apachectl configtest
sudo service apache2 restart

# this works
http://img-proportal.dev/404.html 


#
edit environments/db.pl
change to database => '/home/kchu/webUI/proportal/share/dbschema-img_core.db',


# Getting error - core dump - why? - I need  cpanm 'Acme::Damn' ???
# on linux installed: libacme-damn-perl - it did not help
# I had to first re-install
# - reinstall the Plack mods
cpanm --reinstall 'WWW::Form::UrlEncoded'
cpanm --reinstall 'HTTP::Request::Common'
# I had to reboot
plackup bin/app.psgi

kchu@kchu-laptop:~/webUI/proportal$ plackup bin/app.psgi
Error while loading /home/kchu/Dev/svn/webUI/proportal/bin/app.psgi: Can't locate WWW/Form/UrlEncoded.pm in @INC (you may need to install the WWW::Form::UrlEncoded module) (@INC contains: /home/kchu/Dev/svn/webUI/webui.cgi /home/kchu/Dev/svn/webUI/proportal/lib /home/kchu/Dev/svn/webUI/jbrowse/src/perl5 /home/kchu/Dev/svn/webUI/jbrowse/extlib/lib/perl5 /home/kchu/.perlbrew/libs/perl-5.18.4@std/lib/perl5/5.22.1/x86_64-linux-gnu-thread-multi /home/kchu/.perlbrew/libs/perl-5.18.4@std/lib/perl5/5.22.1 /home/kchu/.perlbrew/libs/perl-5.18.4@std/lib/perl5/x86_64-linux-gnu-thread-multi /home/kchu/.perlbrew/libs/perl-5.18.4@std/lib/perl5 /home/kchu/perl5/lib/perl5/5.22.1/x86_64-linux-gnu-thread-multi /home/kchu/perl5/lib/perl5/5.22.1 /home/kchu/perl5/lib/perl5/x86_64-linux-gnu-thread-multi /home/kchu/perl5/lib/perl5 /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.22.1 /usr/local/share/perl/5.22.1 /usr/lib/x86_64-linux-gnu/perl5/5.22 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl/5.22 /usr/share/perl/5.22 /usr/local/lib/site_perl /usr/lib/x86_64-linux-gnu/perl-base .) at /home/kchu/.perlbrew/libs/perl-5.18.4@std/lib/perl5/HTTP/Entity/Parser/UrlEncoded.pm line 5.
-- reboot pc

kchu@kchu-laptop:~/webUI/proportal$ plackup bin/app.psgi
Error while loading /home/kchu/Dev/svn/webUI/proportal/bin/app.psgi: Can't locate Bio/JBrowse/Cmd/FlatFileToJson.pm in @INC (you may need to install the Bio::JBrowse::Cmd::FlatFileToJson module) (@INC contains: /home/kchu/Dev/svn/webUI/install/proportal-local /home/kchu/Dev/svn/webUI/install /home/kchu/Dev/svn/webUI/webui.cgi /home/kchu/Dev/svn/webUI/proportal/lib /home/kchu/Dev/svn/webUI/jbrowse/src/perl5 /home/kchu/Dev/svn/webUI/jbrowse/extlib/lib/perl5 /home/kchu/.perlbrew/libs/perl-5.18.4@std/lib/perl5/x86_64-linux /home/kchu/.perlbrew/libs/perl-5.18.4@std/lib/perl5 /home/kchu/perl5/lib/perl5 /home/kchu/perl5/perls/perl-5.18.4/lib/site_perl/5.18.4/x86_64-linux /home/kchu/perl5/perls/perl-5.18.4/lib/site_perl/5.18.4 /home/kchu/perl5/perls/perl-5.18.4/lib/5.18.4/x86_64-linux /home/kchu/perl5/perls/perl-5.18.4/lib/5.18.4 .) at /home/kchu/Dev/svn/webUI/proportal/lib/ProPortal/Util/JBrowseFilePrep.pm line 19.
# install nodejs via ubuntu
# install http://jbrowse.org

unzip jbrowse in ~kchu/
in kchu/public_html/jbrowse to ../JB....

ran setup.sh under the local perl install
failed
kchu@kchu-laptop:~/public_html/jbrowse$ ./setup.sh 
Installing Perl prerequisites ... failed.  See setup.log file for error messages. As a first troubleshooting step, make sure development libraries and header files for GD, Zlib, and libpng are installed and try again.


# /home/kchu/.cpanm/work/1481224369.23102/build.log
# BerkeleyDB failed

cpanm 'BerkeleyDB' 
# failed

cpanm 'Class::HPLOO::Base'
cpanm 'DBD'
ubuntu install libdb.... 
cpanm 'DB_File'
cpanm 'BerkeleyDB' 
# back to to jbrowse setup 
# ok installed ok
plackup bin/app.psgi
# failed again
 reinstall Bio perl again
 
kchu@kchu-laptop:~/JBrowse-1.12.1/extlib/lib/perl5/Bio$ cp -r * /home/kchu/.perlbrew/libs/perl-5.18.4@std/lib/perl5/Bio
kchu@kchu-laptop:~/Dev/svn/webUI$ ln -s ~kchu/JBrowse-1.12.1 jbrowse
cpanm 'TestApp'
cpanm 'Catalyst::Test'
cpanm --reinstall 'App::Cmd::Tester'

# ubuntu install nginx
cpanm  'Nginx'

http://nginx.org/en/linux_packages.html

cpanm  'Test::App'

