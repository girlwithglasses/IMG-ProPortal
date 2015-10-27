package ProPortalPackage;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'CoreStuff';

use Routes::GateKeeper;
use Routes::Ajax;
use Routes::MenuPages;
use Routes::JBrowse;
use Routes::IMG;
use Routes::ProPortal;
use Routes::TestStuff;

1;
