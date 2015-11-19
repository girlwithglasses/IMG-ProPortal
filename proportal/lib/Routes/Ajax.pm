package Routes::Ajax;

use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'CoreStuff';
use Dancer2::Plugin::Ajax;

# use XMLProxy;
# use JSONProxy;

our $VERSION = '0.1';

any '/inner.cgi' => sub {

	return 'Called the inner cgi!';

};

ajax '/xml.cgi' => sub {

	require XMLProxy;
	return XMLProxy->run( params => request->parameters, config => config );
#	return 'Called xml.cgi!';

};

ajax '/json_proxy.cgi' => sub {

	require JSONProxy;
	# args: hash of parameters

	my $result = JSONProxy->run( params => request->parameters, config => config );

	if ( $result ) {
		# JSON header
		content_type 'application/json';
		return to_json $result;
	}
#	return 'Called json_proxy.cgi!';
};


1;
