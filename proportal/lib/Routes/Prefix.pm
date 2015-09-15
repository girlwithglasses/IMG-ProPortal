package Routes::Prefix;
use Dancer2 appname => 'TestApp';
use feature ':5.16';
use Routes::Prefix;

get '/blob' => sub {
	return 'got it!';
};

prefix '/one' => sub {

	get qr{
		/ (?<page> one | two )
		}x => sub {

			my $content = {
				page => captures->{page},
				app => app,
			};

			template 'pages/any_content', { content => $content };

	};

	get '/*' => sub {
		return 'got a page!';
	};

};


1;
