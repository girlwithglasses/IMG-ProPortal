=====================================
Config files for apache on gpweb36/37
=====================================
User wwwimg

Files install locations

/global/homes/w/wwwimg/apache/admin/DEFAULT
apache2.conf
environment
ports.conf

/global/homes/w/wwwimg/apache/admin/DEFAULT/sites-enabled
auto-vhost
auto-vhost-ssl

/global/homes/w/wwwimg/apache/admin/DEFAULT/conf.d
gpweb37.proportal.conf

Files in directory sites-enabled should go to
/global/homes/w/wwwimg/apache/admin/DEFAULT/sites-enabled

Sets of globally-useful directory configs go in
/global/homes/w/wwwimg/apache/admin/DEFAULT/file_system (symlinked to webUI/apache/file_system)

=========================
check apache enabled mods
=========================

[wwwimg@gpweb36 DEFAULT]$ apachectl -help
...

[wwwimg@gpweb36 DEFAULT]$ pwd
/global/homes/w/wwwimg/apache/admin/gpweb07_20151016

apachectl -M  -d /global/homes/w/wwwimg/apache/admin/gpweb07_20151016 -f
apache2.conf

======================================================================
Edit /global/homes/w/wwwimg/apache/admin/gpweb07_20151016/apache2.conf
======================================================================
LoadModule wsgi_module /etc/httpd/modules/mod_wsgi.so

========================
test apache mods via php
========================
https://img-dev.jgi.doe.gov/test.php

=========================================
start, stop, or gracefully restart Apache
=========================================

sh bin/apache.sh (stop|start|restart)

"restart" will gracefully reload the server without killing any existing processes
