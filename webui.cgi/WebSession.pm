#
# I'm trying to move the CGI session stuff out of WebUtil.pm to this object
# - ken
#
package WebSession;

use strict;
use CGI qw( :standard );
use CGI::Session qw/-ip-match/;
use CGI::Cookie;
use CGI::Carp qw( carpout set_message  );

use WebConfig;
use WebPrint;
use WebIO;
use WebUtil;

my $env                   = WebConfig::getEnv();
my $img_ken               = $env->{img_ken};
my $public_login          = $env->{public_login};
my $user_restricted_site  = $env->{user_restricted_site};
#my $cgi_tmp_dir           = $env->{cgi_tmp_dir};
# my $base_url              = $env->{base_url};

# Force the temporary files directory to dir abc - for files uploads see CGI.pm docs
# http://perldoc.perl.org/CGI.html search for -private_tempfiles
#$CGITempFile::TMPDIRECTORY = '/opt/img/temp';
#$CGITempFile::TMPDIRECTORY = $TempFile::TMPDIRECTORY = '/opt/img/temp';
#or
#$ENV{TMPDIR} = '/opt/img/temp';
# http://www.webdeveloper.com/forum/showthread.php?157639-CGI-Perl-uploading-files
#

#	$CGITempFile::TMPDIRECTORY = $TempFile::TMPDIRECTORY = "$cgi_tmp_dir";

#
# env - has from WebConfig
# logging function from WebUtil
#
sub new
{
    my $class = shift;

	my $self = {
		_cgi => CGI->new(),
		_cookie_name => undef,
		_g_session => undef,
		_env => WebConfig::getEnv(),
	};

    bless $self, $class;

	if ( @_ ) {
		my $args = ( @_ && 1 < scalar( @_ ) ) ? { @_ } : shift;
		for ( qw( _cgi _cookie_name _g_session _env ) ) {
			if ( ! $args->{$_} ) {
				die 'Missing required parameter ' . $_;
			}
			$self->{$_} = $args->{$_};
		}
	}
	else {
		# do setup here!
		$self->initialize();
	}

    return $self;
}

# see http://search.cpan.org/~sherzodr/CGI-Session-3.95/Session/Tutorial.pm
# section INITIALIZING EXISTING SESSIONS
# idea:
# before we create a session id lets check the cookies
# if it exists use existing cookie sid
# also the cookie name is now system base url specific
# - Ken
sub initialize {
    my $self = shift;
	my $env = $self->{_env};
    my $cgi = $self->{_cgi};
    my $g_session;

    $CGITempFile::TMPDIRECTORY = $TempFile::TMPDIRECTORY = $env->{cgi_tmp_dir};

    # see http://search.cpan.org/~sherzodr/CGI-Session-3.95/Session/Tutorial.pm
    # section INITIALIZING EXISTING SESSIONS
    # idea:
    # before we create a session id lets check the cookies
    # if it exists use existing cookie sid
    # also the cookie name is now system base url specific
    # - Ken
    my $cookie_name = "CGISESSID_";
    if ( $env->{urlTag} ) {
        $cookie_name = $cookie_name . $env->{urlTag};
    } else {
        my @tmps = split( /\//, $env->{base_url} );
        $cookie_name = $cookie_name . $tmps[$#tmps];
    }
    CGI::Session->name($cookie_name);    # override default cookie name CGISESSID
    $CGI::Session::IP_MATCH = 1;
    my $cookie_sid = $cgi->cookie($cookie_name) || undef;

    # test last host cookie
    my $hostname = WebUtil::getHostname();
    my $cookie_host = $cgi->cookie('img_host' . $env->{urlTag}) || undef;
    WebIO::webLog("\n\nHOST $hostname === cookie host $cookie_host\n\n");
    if(defined($cookie_host) && $hostname ne $cookie_host) {
        $self->printSessionExpired("over 1+ hour idle time.");
    }

    # http://search.cpan.org/~markstos/CGI-Session-4.48/lib/CGI/Session/Tutorial.pm
    # Above example is worth an attention. Remember, all expired sessions are empty sessions,
    # but not all empty sessions are expired sessions.
    my $sessiontest = CGI::Session->load(undef, $cookie_sid, { Directory => $env->{cgi_tmp_dir} });
    if ( $sessiontest->is_expired ) {
        webLog( "\n\nYOUR session expired. $cookie_sid\n\n");

        # if not from the login page jgi sso
        my $oldLogin = param('oldLogin');
        if($oldLogin eq '') {
            $self->printSessionExpired("over 55+ min idle time.");
        }
    }

    if ( $sessiontest->is_empty ) {
        # my login out or expired session
        WebIO::webLog( "\n\nYOUR session is_empty: $cookie_sid\n\n");
        $g_session = $sessiontest->new();
        $self->{_g_session} = $g_session;
        my $newid = $self->getSessionId();
        WebIO::webLog( "\n\nYOUR NEW session created in is_empty(): $newid\n\n");
    } else {
        $g_session = $sessiontest;
    }

     $self->{_g_session} = $g_session;

    # OLD way for cgi session v3.x+
    #$g_session = new CGI::Session( undef, $cookie_sid, { Directory => $cgi_tmp_dir } ); # this works better
    #$g_session              = new CGI::Session( undef, $cgi, { Directory => $cgi_tmp_dir } ); # does not as well
    WebIO::webLog("\n\nYOUR session id ===== " . $self->getSessionId());
    WebIO::webLog("  cookie id: ===== $cookie_sid\n\n");
    WebIO::webLog("script =======  $0\n\n");

    # the cookie expires 55min
    #$g_session->expire('+1h');    # expire after 1 hour
    $g_session->expire('+55m');    # expire after 55 mins

    #stackTrace( "WebUtil::initialize()", "TEST: cookie ids ======= cookie_name => $cookie_name sid => " . ( $cookie_sid || "" ) );

    $self->{_cookie_name} = $cookie_name;

}


sub getCgi {
    my($self) = @_;
    return $self->{_cgi};
}

sub getSession {
    my($self) = @_;
    return $self->{_g_session};
}

sub getCookieName {
    my($self) = @_;
    return $self->{_cookie_name};
}

sub getSessionId {
    my $self = shift;
    return $self->{_g_session}->id;
}

sub getSessionParam {
    my ($self, $arg) = @_;
    return $self->getSession()->param($arg);
}

#
# print a session expired page
# why ? sso is 24 hours
# user do not know they have been logout by img and relogin by jgi sso
# hence their carts stuff disappears etc....
#
sub printSessionExpired {
    my($self, $text) = @_;

     my $public_login = $env->{public_login};
     my $user_restricted_site  = $env->{user_restricted_site};

    # for the xml.pl json_proxy.pl
    # just return
    my $script = $0;
    if($script =~/^xml/ || $script =~/^json_proxy/ || $script =~/^inner/) {
        return;
    }

    my $sso_url                 = $env->{sso_url};
    my $sso_domain              = $env->{sso_domain};

    my $cookie_host = $self->makeCookieHostname();
    my $cookie = $self->makeCookieSession(-1, '-1d');

    # make sure we set the correct host name cookie
    print header(-type => "text/html", -cookie => [$cookie, $cookie_host ] );


    WebPrint::printHeader();

    my $buttonText = 'Refresh Session';
    if($user_restricted_site || $public_login) {
        $buttonText = 'Sign In Again';
    }

    print qq{
<br><br>
Your IMG session has expired: $text
<br><br>
<input class='smdefbutton' type='button' name='signin' value='$buttonText'
onclick="window.open('main.cgi', '_self')";>
<br>

</body>
    };

    WebPrint::printMainFooter();

    # I cannot jgi sso logout - what if they were using the portal and forgot about
    # the img window
    WebUtil::webExit();
}

# this creates a cookie named 'img_host' . $env->{urlTag}
# it keeps track if the load balancers switches the user to another server
# the cookie expires with 2 hours idle time
# - ken
sub makeCookieHostname {
    my ($self) = @_;
    my $env = $self->{_env};
    my $hostname =  $self->{_hostname};

    my $cookie_host = CGI::Cookie->new(
            -name   => 'img_host' . $env->{urlTag},
            -value  => $hostname,
            -expires => '+2h'
    );
    return $cookie_host;
}

# creates cgi session cookie
#
# input
# cookie value - the default is cgi session id
# expire time: default is 2 hours idle time
#
# +45m
# +90m expire after 90 minutes
# +24h - 24 hour cookie
# +1d - one day
# +6M   6 months from now
# +1y   1 year from now
#
# $session->expire("+1d");
# - ken
sub makeCookieSession {
    my($self, $value, $expiresTime) = @_;
    $expiresTime = '+2h' if(!$expiresTime);

    my $g_session = $self->{_g_session};
    if(!$value) {
        $value = $g_session->id();
    }

    my $cookie_name = $self->{_cookie_name};
    my $cookie = CGI::Cookie->new(
            -name   => $cookie_name,
            -value  => $value,
            -expires => $expiresTime
    );
    return $cookie;
}

# creates jgi sso return cookie
#
sub makeCookieSsoReturn {
    my($self, $url) = @_;
    my $env = $self->{_env};
    my $sso_domain      = $env->{sso_domain};
    my $sso_cookie_name = $env->{sso_cookie_name};

     my $cookie_return = CGI::Cookie->new(
            -name   => $sso_cookie_name,
            -value  => $url,
            -domain => $sso_domain
     );


     #die("ssso " . $sso_cookie_name);

     return $cookie_return;
}

sub getContactOid {
	my($self) = @_;
    
    if (!$user_restricted_site && !$public_login ) {
        return 0;
    }
    
    return $self->getSession->param("contact_oid");
}

sub getUserName {
	my($self) = @_;
    if ( !$user_restricted_site && !$public_login ) {
        return "";
    }
    return $self->getSession->param("username");
}

sub getUserName2 {
	my($self) = @_;
    if ( !$user_restricted_site && !$public_login ) {
        return "";
    }
    return $self->getSession->param("name");
}

sub getSuperUser {
	my($self) = @_;
    if ( !$user_restricted_site ) {
        return "";
    }
    return $self->getSession->param("super_user");

}

sub setSessionParam {
    my ($self, $arg, $val ) = @_;
    my $g_session = $self->getSession();
    $g_session->param( $arg, $val );
}

1;
