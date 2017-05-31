This a supplement readme to webUI/proportal/README.md

gpweb36 setup

as wwwimg user

# What I need to install on gpweb36 as wwwimg user
# - ken

> export PERLBREW_ROOT=/webfs/projectdirs/microbial/img/perl5
> curl -L https://install.perlbrew.pl | bash

created script setup_perl_local.bash which is contains
source /webfs/projectdirs/microbial/img/perl5/etc/bashrc

> source setup_perl_local.bash
> perlbrew install-cpanm
> perlbrew install-patchperl
> perlbrew install perl-5.18.4
    
  
# this might be user account specific - ???- ken  
> perlbrew lib create perl-5.18.4@std
> perlbrew switch perl-5.18.4@std
    -- Attempting to create directory /global/homes/w/wwwimg/.perlbrew/libs/perl-5.18.4@std


> cpanm --cpanfile ~/webUI-ken/proportal/cpanfile --installdeps ~/webUI-ken/proportal/

> cpanm http://search.cpan.org/CPAN/authors/id/M/MJ/MJEVANS/DBD-Oracle-1.75_2.tar.gz

# to see what failed to install
> cpanm  --cpanfile ~/webUI-ken/proportal/cpanfile --installdeps ~/webUI-ken/proportal/ > out.log
[wwwimg@gpweb36 ~]$ cpanm  --cpanfile ~/webUI-ken/proportal/cpanfile --installdeps ~/webUI-ken/proportal/ > out.log
! Configure failed for XML-LibXML-2.0128. See /global/homes/w/wwwimg/.cpanm/work/1480964921.81316/build.log for details.
! Installing Net::SSLeay failed. See /global/homes/w/wwwimg/.cpanm/work/1480964921.81316/build.log for details. Retry with --force to force install it.
! Installing the dependencies failed: Module 'Net::SSLeay' is not installed
! Bailing out the installation for IO-Socket-SSL-2.039.
! Installing the dependencies failed: Module 'XML::LibXML' is not installed, Module 'Net::SSLeay' is not installed, Module 'IO::Socket::SSL' is not installed
! Bailing out the installation for /global/homes/w/wwwimg/webUI-ken/proportal/.
[wwwimg@gpweb36 ~]$ 


# skipped above for now - ken

> cpanm CJFIELDS/BioPerl-1.6.924.tar.gz

