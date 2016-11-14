package ProPortalPackage;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'AppCore';

our $VERSION = '0.1.0';

#use Routes::GateKeeper;
#use Routes::Ajax;
use Routes::MenuPages;
use Routes::JBrowse;
# use Routes::IMG;
use Routes::API;
use Routes::ProPortal;
use Routes::TestStuff;

1;
