package Routes::Ajax;

use IMG::Util::Import;
use Dancer2 appname => 'ProPortal';
use AppCorePlugin;
use Dancer2::Plugin::Ajax;

# use XMLProxy;
# use JSONProxy;

any '/inner.cgi' => sub {

	return 'Called the inner cgi!';

};

ajax '/xml.cgi' => sub {

	require XMLProxy;
	return XMLProxy->run( params => request->parameters, config => config );

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
};


1;
