###########################################################################
#
# $Id: Session.pm 34501 2015-10-13 23:40:50Z aireland $
#
############################################################################
package IMG::App::Role::Session;

use IMG::Util::Base 'MooRole';

requires 'config';

has 'session' => (
	is => 'rw',
	isa => Object,
	predicate => 1,
	writer => 'set_session',
);


=head3 set_up_session



=cut

sub set_up_session {
	my $self = shift;
	my $user = shift;

	say 'params to set_up_session: ' . Dumper $user;

	say 'user: ' . Dumper $self->user;

#	$self->session->write( 'jgi_session_id', $user->{user_data}{id} );

	#	only if sso is enabled
	if ( $self->can('user') ) {
		my @params = qw( contact_oid username super_user name email jgi_session_id caliban_id caliban_user_name );
		for ( @params ) {
			$self->session->write( $_, $self->user->$_ // 0 );
		}
		$self->session->write( 'user_object', $self->user );
		$self->session->write( 'banned_checked', 1 );

#		$self->load_user_preferences();
	}
	else {


	}

#	$self->touch_cart_files();


=cut
	# set up session params
	session 'contact_oid'       => $q->[0];
	session 'username'          => $q->[1];
	session 'super_user'        => $q->[2];
	session 'name'              => $q->[3];
	session 'email'             => $q->[4];
	session 'jgi_session_id'    => $user_data->{id};
	session 'caliban_id'        => $user_data->{user}{contact_id};
	session 'caliban_user_name' => $user_data->{user}{login};
	session 'banned_checked'    => 1;

	say "session looks like this: " . Dumper session;

#=cut
	WebUtil::loginLog( 'login', 'sso' );
	require MyIMG;
	MyIMG::App::Role::UserPreferences();
#=cut
	# load prefs into the session
	require Workspace;
	my $fname = Workspace::getUserPrefsFileName();
	if ( -r $fname ) {
		my $p_hash = IMG::Util::File::file_to_hash( $fname );
		if ( %$p_hash ) {
			for ( keys %$p_hash ) {
				$self->session->write( $_ => $p_hash->{$_} );
			}
		}
	}
=cut
	return;

}



=cut
#
# once login in sso call this to setup cgi session
#
# https://signon.jgi.doe.gov/api/users/3701.json
# http://contacts.jgi-psf.org/api/contacts/3696
#
sub validate_user {
	my $self = shift;
	my $arg_h = shift;

	my $conn = $arg_h->{conn};
	my $cookies = $self->{cookies};

	# check for session cookie and value
	if (! $cookies->{ $self->cfg->{sso_session_cookie_name } } || ! $cookies->{ $self->cfg->{sso_session_cookie_name}}->value) {
		return 0;
	}

#    webLog("here 4 $url\n");
#    my $ua = WebUtil::myLwpUserAgent();

#    my $req  = GET($url);
#    my $res  = $ua->request($req);
#    my $code = $res->code;

    #webLog("here 5 $code\n");

	my $sess_data = $self->get_jgi_user_data( $cookies->{ $self->cfg->{sso_session_cookie_name} }->value );
	# ping the server

	if (! $sess_data->{user}{login} || ! $sess_data->{user}{email_address}) {
		return 0;
	}

	my $sess_id   = $sess_data->{id};
	my $user_href = $sess_data->{user};
	my $user_id   = $sess_data->{user}{id};

	# contact_oid, username, super_user, name, email
	my $user_h = getContactOid( $arg_h->{dbh}, $sess_data->{user}{id} );


#	my ( $contact_oid, $username, $super_user, $name, $email2 ) = getContactOid( $dbh, $sess_data->{user}{id} );

	return 0 unless $user_h->{contact_oid};

#=cut
	my ( $ans, $login, $email, $userData_href ) = getUserInfo3( $user_id, $user_href );

    my ( $id, $user_href ) = @_;

    my $contact_id = $user_href->{contact_id};
    my $login      = $user_href->{'login'};
    my $email      = $user_href->{'email_address'};

    if ( $email eq '' || $login eq '' ) {
        return ( 0, '', '', '' );
    }

    my %userData = (
        'username'     => $login,
        'email'        => $email,
        'name'         => $user_href->{'first_name'} . ' ' . $user_href->{'last_name'},
        'phone'        => $user_href->{'phone_number'},
        'organization' => $user_href->{'institution'},
        'address'      => $user_href->{'address_1'},
        'state'        => $user_href->{'state'},
        'country'      => $user_href->{'country'},
        'city'         => $user_href->{'city'},
        'title'        => $user_href->{'prefix'},
        'department'   => $user_href->{'department'},
    );

    webLog(" 1, $login, lc($email),\n");
    return ( 1, $login, lc($email), \%userData );

#=cut

        checkBannedUsers( $user_h->{username}, $user_h->{email}, $sess_data->{user}{email_address} );
#=cut
        if ( $ans == 1 && $contact_oid eq "" ) {
            $login = CGI::unescape($login);
            $email = CGI::unescape( lc($email) );

            my $emailExists = emailExist( $dbh, $email );
            if ($emailExists) {

                # update user's old img account with caliban data
                updateUser( $login, $email, $user_id );
            } else {

                # user is an old jgi sso user, data not in img's contact table
                #insertUser( $login, $email, $user_id, $userData_href );

                imgAccounttForm( $email, $userData_href );
            }
            ( $contact_oid, $username, $super_user, $name, $email2 ) = getContactOid( $dbh, $user_id );
        }
#=cut

	setSessionParam( "contact_oid",       $user_h->{contact_oid} );
	setSessionParam( "super_user",        $user_h->{super_user} );
	setSessionParam( "username",          $user_h->{username} );
	setSessionParam( "jgi_session_id",    $sess_data->{id} );
	setSessionParam( "name",              $sess_data->{first_name} . ' ' . $sess_data->{last_name} );
	setSessionParam( "email",             $user_h->{email} );
	setSessionParam( "caliban_id",        $sess_data->{user}{id} );
	setSessionParam( "caliban_user_name", $sess_data->{user}{login} );
	return 1;
}


sub session_set_up {





}


sub initialize {
    $cgi = new CGI;

    # see http://search.cpan.org/~sherzodr/CGI-Session-3.95/Session/Tutorial.pm
    # section INITIALIZING EXISTING SESSIONS
    # idea:
    # before we create a session id lets check the cookies
    # if it exists use existing cookie sid
    # also the cookie name is now system base url specific
    # - Ken
    $cookie_name = "CGISESSID_";
    if ( $self->cfg->{urlTag} ) {
        $cookie_name .= $self->cfg->{urlTag};
    } else {
        my @tmps = split( /\//, $base_url );
        $cookie_name = $cookie_name . $tmps[$#tmps];
    }
    CGI::Session->name($cookie_name);    # override default cookie name CGISESSID
    $CGI::Session::IP_MATCH = 1;

    my $cookie_sid = $cgi->cookie($cookie_name) || undef;
    $g_session = new CGI::Session( undef, $cookie_sid, { Directory => $cgi_tmp_dir } );

    #$g_session              = new CGI::Session( undef, $cgi, { Directory => $cgi_tmp_dir } );

    stackTrace( "WebUtil::initialize()", "TEST: cookie ids ======= cookie_name => $cookie_name sid => $cookie_sid" );
}


my $session = getSession();

# +90m expire after 90 minutes
# +24h - 24 hour cookie
# +1d - one day
# +6M   6 months from now
# +1y   1 year from now
#$session->expire("+1d");
#
# TODO Can this be the problem with NAtalia always getting logged out - ken June 1, 2015 ???
#resetContactOid();

my $session_id  = $session->id();
my $contact_oid = getContactOid();

# see WebUtil.pm line CGI::Session->name($cookie_name); is called - ken
my $cookie_name = WebUtil::getCookieName();
my $cookie      = cookie( $cookie_name => $session_id );
if ( $sso_enabled ) {
    require Caliban;
    if ( !$contact_oid ) {
        my $dbh_main = dbLogin();
        my $ans      = Caliban::validateUser($dbh_main);


        if ( !$ans ) {
			# go to login
            printAppHeader("login");
            Caliban::printSsoForm();
            printContentEnd();
            printMainFooter(1);
            WebUtil::webExit(0);
        }
        WebUtil::loginLog( 'login', 'sso' );
        require MyIMG;
        MyIMG::App::Role::UserPreferences();
    }

    # logout in genome portal i still have contact oid
    # I have to fix and relogin
    my $ans = Caliban::isValidSession();

    if ( !$ans ) {
        Caliban::logout( 0, 1 );
        printAppHeader("login");
        Caliban::printSsoForm();
        printContentEnd();
        printMainFooter(1);
        WebUtil::webExit(0);
    }
} elsif ( ( $public_login || $user_restricted_site ) && !$contact_oid ) {
    require Caliban;
    my $username = param("username");
    $username = param("login") if ( blankStr($username) );    # single login form for sso or img
    my $password = param("password");
    if ( blankStr($username) ) {
        printAppHeader("login");
        Caliban::printSsoForm();
        printContentEnd();
        printMainFooter(1);
        WebUtil::webExit(0);
    } else {
        my $redirecturl = "";
        if ($sso_enabled) {

            # do redirect via cookie
            # return cookie name
            my %cookies = CGI::Cookie->fetch;
            if ( exists $cookies{$sso_cookie_name} ) {
                $redirecturl = $cookies{$sso_cookie_name}->value;
                $redirecturl = "" if ( $redirecturl =~ /main.cgi$/ );

                #$redirecturl = "" if ( $redirecturl =~ /forceimg/ );
            }
        }

        require MyIMG;
        my $b = MyIMG::App::Role::UserPassword( $username, $password );
        if ( !$b ) {
            Caliban::logout();
            printAppHeader( "login", '', '', '', '', '', $redirecturl );
            print qq{
<p>
    <span style="color:red; font-size: 14px;">
    Invalid Username or Password. Try again. <br>
    For JGI SSO accounts please use the login form on the right side
    <span style="color:#336699; font-weight:bold;"> "JGI Single Sign On (JGI SSO)"</span></span>
</p>
            };
            Caliban::printSsoForm();
            printContentEnd();
            printMainFooter(1);
            WebUtil::webExit(0);
        }
        Caliban::checkBannedUsers( $username, $username, $username );
        WebUtil::loginLog( 'login', 'img' );
        MyIMG::App::Role::UserPreferences();
        setSessionParam( "oldLogin", 1 );

        #if($img_ken) {
            Caliban::migrateImg2JgiSso($redirecturl);
        #}

        if ( $sso_enabled && $redirecturl ne "" ) {
            print header( -type => "text/html", -cookie => $cookie );
            print qq{
                    <p>
                    Redirecting to: <a href='$redirecturl'> $redirecturl </a>
                    <script language='JavaScript' type="text/javascript">
                     window.open("$redirecturl", "_self");
                    </script>
            };
            WebUtil::webExit(0);
        }
    }
}


#
# clear cgi session id file and directory after logout and after block bots calls
#
sub clearSession {

    webLog("clear cgi session\n");
    my $contact_oid = getContactOid();
    my $session     = getSession();
    my $session_id  = getSessionId();

    setSessionParam( "blank_taxon_filter_oid_str", "1" );
    setSessionParam( "contact_oid",                "" );
    setTaxonSelections("");
    setSessionParam( "jgi_session_id", "" );
    setSessionParam( "oldLogin",       "" );

    $session->delete();
    $session->flush();                # Recommended practice says use flush() after delete().

    webLog( "clear cgi session: $cgi_tmp_dir/cgisess_" . $session_id . "\n" );
    wunlink( "$cgi_tmp_dir/cgisess_" . $session_id );

    webLog( "clear cgi session: $cgi_tmp_dir/" . $session_id . "\n" );
    remove_tree( "$cgi_tmp_dir/" . $session_id ) if ( $session_id ne '' );

    stackTrace( "WebUtil::clearSession()", '', $contact_oid, $session_id );
}

sub getCookieName {
    return $cookie_name;
}


############################################################################
# getSessionId - Get session ID.
############################################################################
sub getSessionId {
    return $g_session->id();
}

############################################################################
# getSession - Get session cookie
############################################################################
sub getSession {
    return $g_session;
}

############################################################################
# getSessionParam - Get session parameter.
############################################################################
sub getSessionParam {
    my ($arg) = @_;
    return $g_session->param($arg);
}

############################################################################
# getContactOid - Get current contact_oid for user restricted site.
############################################################################
sub getContactOid {
    if ( !$user_restricted_site && !$public_login ) {
        return 0;
    }
    return getSessionParam("contact_oid");
}

############################################################################
# getUserName - Get username
# user - login id
############################################################################
sub getUserName {
    if ( !$user_restricted_site && !$public_login ) {
        return "";
    }
    return getSessionParam("username");
}

# gets users "name" from contact table
sub getUserName2 {
    if ( !$user_restricted_site && !$public_login ) {
        return "";
    }
    return getSessionParam("name");
}

############################################################################
# getSuperUser - Get contact.super_user status.
############################################################################
sub getSuperUser {
    if ( !$user_restricted_site ) {
        return "";
    }
    return getSessionParam("super_user");
}

############################################################################
# setSessionParam - Set session parameter.
############################################################################
sub setSessionParam {
    my ( $arg, $val ) = @_;
    $g_session->param( $arg, $val );
}


#
# create and gets session dir under cgi_tmp_dir
#
# $e->{ cgi_tmp_dir } = "/opt/img/temp/" . $e->{ domain_name } .  "_"  . $urlTag;
#
# $subDir - optional - create a subdir under $cgi_tmp_dir/$sessionId/$subDir
sub getSessionDir {
    my ($subDir) = @_;

    my $sessionId = getSessionId();
    my $dir       = "$cgi_tmp_dir/$sessionId";
    if ( !( -e "$dir" ) ) {
        mkdir "$dir" or webError("Cannot make $dir!");
    }

    if ( $subDir ne '' ) {
        $dir = "$cgi_tmp_dir/$sessionId/$subDir";
        if ( !( -e "$dir" ) ) {
            mkdir "$dir" or webError("Cannot make $dir!");
        }
    }

    return $dir;
}

#
# wrapper to getSessionDir()
# this has a better method name
#
sub getSessionCgiTmpDir {
    my ($subDir) = @_;
    return getSessionDir($subDir);
}

#
# create and gets session dir under tmp_dir
#     $e->{ base_dir } = $apacheVhostDir . $e->{ domain_name } . "/htdocs/$urlTag";
#     $e->{ tmp_dir } = $e->{ base_dir } . "/tmp";
#
# $subDir - optional - create a subdir under $tmp_dir/$sessionId/$subDir
sub getSessionTmpDir {
    my ($subDir) = @_;

    my $sessionId = getSessionId();
    my $dir       = "$tmp_dir/public/$sessionId";
    if ( !( -e "$dir" ) ) {
        mkdir "$dir" or webError("Cannot make $dir!");
        chmod( 0777, $dir );
    }

    if ( $subDir ne '' ) {
        $dir = "$tmp_dir/public/$sessionId/$subDir";
        if ( !( -e "$dir" ) ) {
            mkdir "$dir" or webError("Cannot make $dir!");
            chmod( 0777, $dir );
        }
    }

    return $dir;
}

#
# gets tmp dir url that goes with method getSessionTmpDir()
# You MUST call getSessionTmpDir() first, because it creates the needed sub-directories.
#
# $subDir - optional - create a subdir under $tmp_dir/$sessionId/$subDir
sub getSessionTmpDirUrl {
    my ($subDir) = @_;

    my $sessionId = getSessionId();
    my $dir       = "$tmp_url/public/$sessionId";
    my $dirTest   = "$tmp_dir/public/$sessionId";
    if ( !( -e $dirTest ) ) {
        webError("Cannot find $dirTest!");
    }

    if ( $subDir ne '' ) {
        $dir = "$tmp_url/public/$sessionId/$subDir";
        if ( !( -e "$dirTest/$subDir" ) ) {
            webError("Cannot find $dirTest!");
        }
    }

    return $dir;
}


# from TreeFile.pm

#
# file format:
# open list  of  ids \n
# or
# selected list od ids \n
#
sub readSession {
    my ($file) = @_;
    $file = WebUtil::checkFileName($file);
    my %hash = ();

    my $path = "$cgi_tmp_dir/$file";
    if ( !-e $path ) {

        #webLog("Tree state file does not exists or session time out\n");
        return \%hash;
    }

    my $res = newReadFileHandle( $path, "runJob" );

    while ( my $line = $res->getline() ) {
        chomp $line;
        next if ( $line eq "" );
        $hash{$line} = "";
    }

    close $res;
    return \%hash;
}

# write session file on what the user has done so far
sub writeSession {
    my ( $file, $ids_aref ) = @_;

    if ( $file eq "" ) {
        my $sid = getSessionId();
        $file = "treestate$$" . "_" . $sid;
    } elsif ( $file ne "" ) {
        $file = WebUtil::checkFileName($file);
        if ( !-e "$cgi_tmp_dir/$file" ) {
            webError("Your session timed out, please restart!");
        }
    }

    $file = WebUtil::checkFileName($file);

    my $prev_data_href = readSession($file);
    my $path           = "$cgi_tmp_dir/$file";
    my $res            = newWriteFileHandle( $path, "runJob" );

    # save new ids
    foreach my $id (@$ids_aref) {
        if ( exists $prev_data_href->{$id} ) {

            # skip
            next;
        } else {
            print $res "$id\n";
        }
    }

    foreach my $id ( keys %$prev_data_href ) {
        print $res "$id\n";
    }

    close $res;
    return $file;
}

# write session files but remove ids
sub writeSessionRemove {
    my ( $file, $ids_aref ) = @_;

    if ( $file eq "" ) {
        my $sid = getSessionId();
        $file = "treestate$$" . "_" . $sid;
    } elsif ( $file ne "" ) {
        $file = WebUtil::checkFileName($file);
        if ( !-e "$cgi_tmp_dir/$file" ) {
            my $url = "$section_cgi";
            $url = alink( $url, "Restart" );
            print qq{
              <p>
              $url
              </p>
            };
            webError("Your session timed out, please restart!");
        }
    }

    $file = WebUtil::checkFileName($file);

    my $prev_data_href = readSession($file);
    my $path           = "$cgi_tmp_dir/$file";
    my $res            = newWriteFileHandle( $path, "runJob" );

    # save new ids
    foreach my $id (@$ids_aref) {
        if ( exists $prev_data_href->{$id} ) {

            #webLog("=== delete ids $id \n");
            delete $prev_data_href->{$id};
        }
    }

    foreach my $id ( keys %$prev_data_href ) {
        print $res "$id\n";
    }

    close $res;
    return $file;
}

# load user prefs from workspace
sub loadUserPreferences {
    if ( $env->{user_restricted_site} ) {
        require Workspace;
        my $href = Workspace::loadUserPreferences();
        foreach my $key ( keys %$href ) {
            my $value = $href->{$key};
            setSessionParam( $key, $value );
        }
    }
}

# save users preferences in workspace
#
# default use is for preferences
# can be used for genome list cfg preferences
# given the filename mygenomelistprefs ??? - TODO
# - ken
#
sub saveUserPreferences {
    my ( $href, $customFilename ) = @_;
    return if ( !$user_restricted_site );

    my $sid      = getContactOid();
    my $filename = "$workspace_dir/$sid/mypreferences";
    if ( $customFilename ne '' ) {
        $filename = "$workspace_dir/$sid/$customFilename";
    }

    if ( !-e "$workspace_dir/$sid" ) {
        mkdir "$workspace_dir/$sid" or webError("Workspace is down!");
    }

    my $wfh = newWriteFileHandle($filename);
    foreach my $key ( sort keys %$href ) {
        my $value = $href->{$key};
        print $wfh "${key}=${value}\n";
    }

    close $wfh;
}

sub loadUserPreferences {
    my ($customFilename) = @_;

    my %hash;
    if ( !$user_restricted_site ) {
        return \%hash;
    }

    my $sid      = getContactOid();
    my $filename = "$workspace_dir/$sid/mypreferences";
    if ( $customFilename ne '' ) {
        $filename = "$workspace_dir/$sid/$customFilename";
    }

    if ( !-e $filename ) {
        return \%hash;
    }

    # read file
    # return hash
    my %hash;
    my $rfh = newReadFileHandle($filename);
    while ( my $line = $rfh->getline() ) {
        chomp $line;
        next if ( $line eq "" );
        my ( $key, $value ) = split( /=/, $line );
        $hash{$key} = $value;
    }
    close $rfh;
    return \%hash;
}
=cut

1;
