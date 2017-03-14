###########################################################################
#
#
# $Id: Caliban.pm 36698 2017-03-13 17:46:58Z klchu $
#
############################################################################
package Caliban;

use strict;
use CGI qw/:standard/;
use CGI::Session qw/-ip-match/;    # for security - ken
use CGI::Cookie;
use HTML::Template;
#use XML::Simple;
use Scalar::Util 'reftype';
use Data::Dumper;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Request::Common qw( GET POST PUT DELETE);
use JSON;
use WebConfig;
use WebUtil;
use DataEntryUtil;
use MailUtil;
use OracleUtil;

$| = 1;

my $env                      = getEnv();
my $base_url                 = $env->{base_url};
my $base_dir                 = $env->{base_dir};
my $top_base_url             = $env->{top_base_url};
my $main_cgi                 = $env->{main_cgi};
my $cgi_url                  = $env->{cgi_url};
my $cgi_tmp_dir              = $env->{cgi_tmp_dir};
my $section                  = "Caliban";
my $section_cgi              = "$main_cgi?section=$section";
my $user_restricted_site     = $env->{user_restricted_site};
my $user_restricted_site_url = $env->{user_restricted_site_url};

my $abc                      = $env->{abc};                        # BC & SM home

# sso Caliban
# cookie name: jgi_return, value: url, domain: jgi.doe.gov
my $sso_url                 = $env->{sso_url};
my $sso_domain              = $env->{sso_domain};
my $sso_cookie_name         = $env->{sso_cookie_name};           # jgi_return cookie name
my $sso_session_cookie_name = $env->{sso_session_cookie_name};  # jgi_session
my $sso_api_url             = $env->{sso_api_url};               # https://signon.jgi-psf.org/api/sessions/
my $sso_user_info_url       = $env->{sso_user_info_url};
my $sso_enabled             = $env->{sso_enabled};
my $verbose                 = $env->{verbose};
my $public_login            = $env->{public_login};

my $tipText = qq{
<b>Tip:</b> If you keep seeing this message try the following:
<br> 
Try to login and logout using JGI SSO directly <a href='https://signon.jgi.doe.gov/'> https://signon.jgi.doe.gov/ </a>
<br>
Or try clearing your browser's cookies and cache.
<br>
};

sub getPageTitle {
    return '';
}

sub getAppHeaderData {
    my ($self) = @_;

    my @a = ('');
    if ( param("logout") ne "" ) {
        @a = ('logout');
    }
    return @a;
}

sub dispatch {
    my ( $self, $numTaxon ) = @_;
    my $page = param('page');

    if ( param("logout") ne "" ) {
        WebUtil::setSessionParam( "blank_taxon_filter_oid_str", "1" );
        WebUtil::setSessionParam( "oldLogin",                   0 );
        WebUtil::setTaxonSelections("");
        print qq{
            <div id='message'>
            <p>Logged out.</p>
            </div>
            <p>
            <a href='main.cgi'>Sign in</a>
            </p>
        };
        my $sso_enabled = $env->{sso_enabled};
        my $oldLogin    = WebUtil::getSessionParam("oldLogin");
        if ( !$oldLogin && $sso_enabled ) {
            logout(1, 4);
        } else {
            logout(0, 5);
        }
    } elsif ( $page eq 'migrateForm' ) {

        #printMigrateForm();
    } elsif ( $page eq 'submitMigrate' ) {

        #processMigrateForm();
    } elsif ( $page eq 'userinfo' ) {

        #getCalibanInfoFromEmail();
    }
}

sub printSsoForm {
	my ($errorCode) = @_;
	
    my $imgOnlyLogin = param('imgOnlyLogin');

    #my $url = $cgi_url . "/main.cgi?oldLogin=true";

    if ( $imgOnlyLogin eq 'yes' ) {
        my $template = HTML::Template->new( filename => "$base_dir/loginFormOld.html" );

        #    $template->param( base_url => $base_url );
        #    $template->param( cgi_url  => $cgi_url );
        #    $template->param( sso_url  => $sso_url );
        print $template->output;

    } elsif ( $imgOnlyLogin eq 'sso' ) {
        my $template = HTML::Template->new( filename => "$base_dir/loginFormSso.html" );

        #    $template->param( base_url => $base_url );
        #    $template->param( cgi_url  => $cgi_url );
        #    $template->param( sso_url  => $sso_url );
        if($errorCode) {
        	$template->param( errorCode  => "<br> JGI SSO error $errorCode" );
        }
        
        print $template->output;

    } elsif($abc) {
        my $template = HTML::Template->new( filename => "$base_dir/loginFormABC.html" );
        #$template->param( base_url     => $base_url );
        $template->param( sso_url      => $sso_url );
        $template->param( top_base_url => $top_base_url );
        print $template->output;


    } else {

        my $template = HTML::Template->new( filename => "$base_dir/loginFormBoth.html" );
        $template->param( base_url     => $base_url );
        #$template->param( cgi_url      => $cgi_url );
        $template->param( sso_url      => $sso_url );
        $template->param( top_base_url => $top_base_url );

        if($errorCode) {
            $template->param( errorCode  => "<br> JGI SSO error $errorCode" );
        }        
        
        print $template->output;
    }
}

#
# once login in sso call this to setup cgi session
#
# https://signon.jgi.doe.gov/api/users/3701.json
# http://contacts.jgi-psf.org/api/contacts/3696
#
# $dbh should be null here - do not open db connect util signed into jgi sso first !!! - ken 10-09-2016
#
sub validateUser {
    my ($dbh) = @_;

    WebUtil::webLog("Caliban validateUser\n");

    my %cookies = CGI::Cookie->fetch;

    if ( !exists $cookies{$sso_session_cookie_name} ) {
        WebUtil::loginLog( 'Caliban.pm logout', "sso 12" );
        return 0 ;    
    }
    
    my $id = $cookies{$sso_session_cookie_name}->value;
    if ( $id eq "" ) {
        WebUtil::loginLog( 'Caliban.pm logout', "sso 13" );
        return 0;
    }

    # the cookie has the sub path in id
    # https://signon.jgi.doe.gov/api/sessions/e29a0ea6ac80f6b8
    #<session><location>/api/sessions/01f3b5f748d90db59a4a4fbe5f1cbdb2</location>
    #   <user>/api/users/3701</user><ip>128.3.44.193</ip></session>
    #
    # see cookie jgi_session set by jgi sso
    #
    #
    # new user json url
    # https://signon.jgi.doe.gov/api/sessions/01f3b5f748d90db59a4a4fbe5f1cbdb2.json
    # {"ip":"128.3.44.193","id":"01f3b5f748d90db59a4a4fbe5f1cbdb2",
    #  "user":{"created_at":"2011-02-15T14:52:51Z","email":"klchu@lbl.gov","id":3701,
    #    "last_authenticated_at":"2015-04-28T18:31:26Z","login":"klchu","updated_at":"2015-01-07T18:55:00Z",
    #    "contact_id":3696,"prefix":null,"first_name":"Ken","middle_name":null,"last_name":"Chu","suffix":null,
    #    "gender":null,"institution":"Joint Genome Institute","institution_type":"DOE Lab","department":null,
    #    "address_1":"2800 Mitchell Drive","address_2":"","city":"Walnut Creek","state":"CA","postal_code":"94598",
    #    "country":"United States","phone_number":"925-296-5670",
    #    "fax_number":null,"email_address":"klchu@lbl.gov",
    #    "comments":null,"internal":true}
    #    }
    my $url = $sso_url . $id . '.json';

    #webLog("here 4 $url\n");
    
    # 404 errors reported here on Oct 9 2016
    # maybe pause for 1 sec to let sso finish its db stuff??? - Ken
    webLog("\n\nStatus1: JGI SSO $url\n\n");
    webLog("\n\nStatus1: sleep for 2 sec \n\n");
    sleep(2);
    webLog("\n\nStatus1: awake now \n\n");
    
    my $ua = WebUtil::myLwpUserAgent();

    my $req  = GET($url);
    my $res  = $ua->request($req);
    my $code = $res->code;

    #webLog("here 5 $code\n");

    webLog("Status1: JGI SSO $url\n\n");

    if ( $code eq "200" ) {
        my $content = $res->content;

        #        my $href    = XMLin($content);
        #        my @tmp     = split( /\//, $href->{location} );
        #        my $sid     = $tmp[$#tmp];
        #        my @tmp     = split( /\//, $href->{user} );
        #        my $user_id = $tmp[$#tmp];

        my $href      = decode_json($content);
        my $sid       = $href->{id};
        my $user_href = $href->{user};
        my $user_id   = $user_href->{id};

        my $dbh = dbLogin();
        my ( $contact_oid, $username, $super_user, $name, $email2, $jgi_user, $img_editor ) = getContactOidDb( $dbh, $user_id );
        my ( $ans, $login, $email, $userData_href ) = getUserInfo3( $user_id, $user_href );

        checkBannedUsers( $username, $email, $email2 );

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
            ( $contact_oid, $username, $super_user, $name, $email2, $jgi_user, $img_editor ) = getContactOidDb( $dbh, $user_id );
        }

        if (!$contact_oid || $contact_oid eq "" || $contact_oid eq "0" ) {
            WebUtil::loginLog( 'Caliban.pm logout', "sso 14" );
            return 0;
        }

        setSessionParam( "contact_oid",       $contact_oid );
        setSessionParam( "super_user",        $super_user );
        setSessionParam( "username",          $username );
        setSessionParam( "jgi_session_id",    $sid );
        setSessionParam( "name",              $name );
        setSessionParam( "email",             $email2 );
        setSessionParam( "caliban_id",        $user_id );
        setSessionParam( "caliban_user_name", $login );
        setSessionParam( "jgi_user", $jgi_user );
        setSessionParam( "img_editor", $img_editor );
        if ( $img_editor eq "Yes" ) {
            setSessionParam( "editor", 1 );
        } else {
            setSessionParam( "editor", 0 );
        }
        
       
        return 1;
        
    } elsif($code eq "410" || $code eq "404") {
        my $text = qq{
<br>
Your JGI SSO session has expired. <br>
Please login again.
<br>
<br>
$tipText
        };
        
        
        logout(1, 6);
        #WebUtil::printSessionExpired($text);
        return 0;
    } else {
        # sso issue?
        my $content = $res->content;
        
        webLog("Error1: ====================\n\n");
        webLog("Error1: JGI SSO\n\n $url\n\n");
        webLog("Error1: There is an issue with JGI SSO (https://signon.jgi.doe.gov/) \n\n $code \n\n $content <br> $url\n");
        webLog("Error1: ====================\n\n");

        my $text = qq{
<br>
Error1: There is an issue with JGI SSO (https://signon.jgi.doe.gov/) <br> $code <br> $content <br> $url
Please login again.
<br>
<br>
$tipText
        };
        
        logout(1, "7 $code");
        WebUtil::webErrorHeader($text, -1, 1);
    }
    return 0;
}

sub emailExist {
    my ( $dbh, $email ) = @_;
    $email = lc($email);
    my $sql = qq{
        select contact_oid
        from contact
        where lower(email) = ?
        };
    my $cur = WebUtil::execSql( $dbh, $sql, $verbose, $email );
    my ($id) = $cur->fetchrow();
    if ($id) {
        return 1;
    }
    return 0;
}

sub updateUser {
    my ( $login, $email, $caliban_id ) = @_;
    $email = lc($email);
    my $dbh = WebUtil::dbGoldLogin();
    $dbh->{AutoCommit} = 0;
    $dbh->{RaiseError} = 1;

    # update contact table
    my $sql = qq{
        update contact
        set caliban_id = ? ,
        caliban_user_name = ?
        where lower(email) = ?
    };
    my $cur = $dbh->prepare($sql) or webError("cannot preparse statement: $DBI::errstr");
    my $i = 1;
    $cur->bind_param( $i++, $caliban_id ) or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $login )      or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $email )      or webError("$i-1 cannot bind param: $DBI::errstr\n");

    $cur->execute() or webError("cannot execute: $DBI::errstr\n");
    $dbh->commit;

    #$dbh->disconnect();
}

#  - update user info from caliban
# - add name address phone etc.
#
sub insertUser {
    my ( $login, $email, $caliban_id, $userData_href ) = @_;
    $email = lc($email);
    my $dbh = WebUtil::dbGoldLogin();
    $dbh->{AutoCommit} = 0;
    $dbh->{RaiseError} = 1;

    #        my %userData = (
    #                         'username'     => $href->{'login'},
    #                         'email'        => $href->{'email'},
    #                         'name'         => $href->{'first_name'} . ' ' . $href->{'last_name'},
    #                         'phone'        => $href->{'phone_number'},
    #                         'organization' => $href->{'institution'},
    #                         'address'      => $href->{'address_1'},
    #                         'state'        => $href->{'state'},
    #                         'country'      => $href->{'country'},
    #                         'city'         => $href->{'city'},
    #                         'title'        => $href->{'prefix'},
    #                         'department'   => $href->{'department'},
    #        );
    my $name    = $userData_href->{'name'};
    my $reftype = reftype $name;
    $name = '' if ( $reftype eq 'HASH' );

    my $phone = $userData_href->{'phone'};
    $reftype = reftype $phone;
    $phone = '' if ( $reftype eq 'HASH' );

    my $organization = $userData_href->{'organization'};
    $reftype = reftype $organization;
    $organization = '' if ( $reftype eq 'HASH' );

    my $address = $userData_href->{'address'};
    $reftype = reftype $address;
    $address = '' if ( $reftype eq 'HASH' );

    my $state = $userData_href->{'state'};
    $reftype = reftype $state;
    $state = '' if ( $reftype eq 'HASH' );

    my $country = $userData_href->{'country'};
    $reftype = reftype $country;
    $country = '' if ( $reftype eq 'HASH' );

    my $city = $userData_href->{'city'};
    $reftype = reftype $city;
    $city = '' if ( $reftype eq 'HASH' );

    my $title = $userData_href->{'title'};
    $reftype = reftype $title;
    $title = '' if ( $reftype eq 'HASH' );

    my $department = $userData_href->{'department'};
    $reftype = reftype $department;
    $department = '' if ( $reftype eq 'HASH' );

    # get max contact_oid
    my $sql = qq{
        select max(contact_oid)
        from contact
    };
    my $cur = WebUtil::execSql( $dbh, $sql, $verbose );
    my ($contact_oid_max) = $cur->fetchrow();
    $contact_oid_max = $contact_oid_max + 1;

    # insert into contact table
    $sql = qq{
        insert into contact
        (contact_oid, username, password, email, comments,
         add_date,
        caliban_id, caliban_user_name, super_user,
        name, phone, organization, address, state, country, city, title, department
        )
        values
        (?, ?, ?, ?, ?,
         sysdate,
         ?, ?, 'No',
        ?,?,?, ?,?,?, ?,?,?)
    };
    $cur = $dbh->prepare($sql) or webError("cannot preparse statement: $DBI::errstr");

    my $comment = 'user created via caliban img';
    my $i       = 1;
    $cur->bind_param( $i++, $contact_oid_max )                  or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, 'donotuse' . $contact_oid_max )     or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, 'no_password!!' . randomNumbers() ) or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $email )                            or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $comment )                          or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $caliban_id )                       or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $login )                            or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $name )                             or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $phone )                            or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $organization )                     or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $address )                          or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $state )                            or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $country )                          or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $city )                             or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $title )                            or webError("$i-1 cannot bind param: $DBI::errstr\n");
    $cur->bind_param( $i++, $department )                       or webError("$i-1 cannot bind param: $DBI::errstr\n");

    $cur->execute() or webError("cannot execute: $DBI::errstr\n");
    $dbh->commit;

    #$dbh->disconnect();

}

sub imgAccounttForm {
    my ( $email, $userData_href ) = @_;

    # get country list from img gold
    my $dbhg = WebUtil::dbGoldLogin();
    my $sql  = qq{
select cv_term from countrycv
    };
    my $aref = OracleUtil::execSqlCached( $dbhg, $sql, 'countrycv' );

    my @a;
    foreach my $ref (@$aref) {
        my $c = $ref->[0];
        push( @a, $c );
    }

    # add adhoc country spellings
    push( @a, 'United States' );
    push( @a, 'Viet Nam' );
    my $str = join( "','", @a );
    my $countArray = "['" . $str . "']";

    $email = lc($email);

    my $name    = $userData_href->{'name'};
    my $reftype = reftype $name;
    $name = '' if ( $reftype eq 'HASH' );

    my $phone = $userData_href->{'phone'};
    $reftype = reftype $phone;
    $phone = '' if ( $reftype eq 'HASH' );

    my $organization = $userData_href->{'organization'};
    $reftype = reftype $organization;
    $organization = '' if ( $reftype eq 'HASH' );

    my $address = $userData_href->{'address'};
    $reftype = reftype $address;
    $address = '' if ( $reftype eq 'HASH' );

    my $state = $userData_href->{'state'};
    $reftype = reftype $state;
    $state = '' if ( $reftype eq 'HASH' );

    my $country = $userData_href->{'country'};
    $reftype = reftype $country;
    $country = '' if ( $reftype eq 'HASH' );

    my $city = $userData_href->{'city'};
    $reftype = reftype $city;
    $city = '' if ( $reftype eq 'HASH' );

    my $title = $userData_href->{'title'};
    $reftype = reftype $title;
    $title = '' if ( $reftype eq 'HASH' );

    my $department = $userData_href->{'department'};
    $reftype = reftype $department;
    $department = '' if ( $reftype eq 'HASH' );

    my $template = HTML::Template->new( filename => "$base_dir/imgAccountForm.html" );

    $template->param( name         => $name );
    $template->param( title        => $title );
    $template->param( department   => $department );
    $template->param( organization => $organization );
    $template->param( email        => $email );
    $template->param( phone        => $phone );
    $template->param( address      => $address );
    $template->param( city         => $city );
    $template->param( state        => $state );
    $template->param( country      => $country );
    $template->param( countryArray => $countArray );

    # username
    my ( $username, $junk ) = split( /@/, $email );

    #$username =~ s/\W//g;
    $username =~ s/[^A-Za-z0-9]//g;
    my $postfix = 'SSOAPI';
    my $postfixSize = length($postfix);
    my $minUsernameSize = 8 - $postfixSize;# 8 - 6;
    my $maxUsernameSize = 30 - $postfixSize - 1; #30 - 7;
    if(length($username) > $maxUsernameSize) {
        $username = substr($username, 0, $maxUsernameSize);
    } elsif(length($username) < $minUsernameSize) {
        $username = $username . 'X'; # add char
    }
    
    $username = $username . $postfix;
    
    

    # get all distinct img usernames
    my $dbh = WebUtil::dbLogin();
    my %allusernames;
    $sql = qq{
        select username from contact
    };
    my $cur = WebUtil::execSql( $dbh, $sql, 1 );
    for ( ; ; ) {
        my ($name) = $cur->fetchrow();
        last if ($name);
        $allusernames{$name} = $name;
    }
    if ( exists $allusernames{$username} ) {
        # username exists
        my $tmp = $username;
        if(length($tmp) > $maxUsernameSize) {
            $tmp = substr($tmp, 0, $maxUsernameSize);
        }
        do {
            $username = $tmp . randomNumbers(); # random size is 3
        } while ( exists $allusernames{$username} );
    }
    $template->param( username => $username );

    main::printAppHeader("login");

    print $template->output;

    main::printContentEnd();
    main::printMainFooter();
    Caliban::logout(1, 8);
    WebUtil::webExit(0);
}

sub randomNumbers {
    my @chars = ( "0" .. "9" );
    my $string;
    $string .= $chars[ rand @chars ] for 1 .. 3;
    return $string;
}

#
# get user img contact oid via caliban_id
#
sub getContactOidDb {
    my ( $dbh, $user_id ) = @_;

    my $sql = qq{
      select contact_oid, username, super_user, name, email, jgi_user, img_editor
      from contact
      where caliban_id = ?
   };

    my $cur = WebUtil::execSql( $dbh, $sql, $verbose, $user_id );

    my ( $contact_oid, $username, $super_user, $name, $email, $jgi_user, $img_editor ) = $cur->fetchrow();
    return ( $contact_oid, $username, $super_user, $name, $email, $jgi_user, $img_editor );
}

        
# TODO reset session param
# last_jgisso_ping to current time
# we will ping sso every 30 mins instead of every ui refresh or form submit
# - ken
sub doPingJgiSso {
    # get current time
	my $currTime = time();
	
	my $lastTime = WebUtil::getSessionParam("last_jgisso_ping");
	if(!$lastTime) {
		
		# user has just logged in or user was login in the Portal and
		# came to IMG - ken  
		$lastTime = $currTime;
		WebUtil::setSessionParam("last_jgisso_ping", $currTime);
		return 1; 
	} 
	
	my $diff = $currTime - $lastTime;
	my $maxtime = 30 * 60; # 30 mins in secs
	
	if($diff < $maxtime) {
		# no ping
		webLog("\nNo ping diff: $diff ,  $maxtime\n\n");
		return 0;
	}

    WebUtil::setSessionParam("last_jgisso_ping", $currTime);
    return 1; # yes do jgi sso ping
}


#
# is a session valid and do a "touch" or ping too
#
sub isValidSession {
	if(!doPingJgiSso()) {
		webLog("\nStatus: NO JGI SSO PING\n\n");
		return 1;
	}
	webLog("\nStatus: YES do a JGI SSO PING\n\n");
	
    my $sid = getSessionParam("jgi_session_id");

    # logout( 1, 10 )
    webLog("isValidSession \n");
    return 10 if ( $sid eq "" || $sid eq 0 );

    # make sure the jgi_Session cookie exists
    # if gone the user logout eg closed browser
    # logout( 1, 11 )
    my %cookies = CGI::Cookie->fetch;
    return 11 if ( !exists $cookies{$sso_session_cookie_name} );


    # https://signon.jgi-psf.org/api/sessions/
    # my $url = $sso_api_url . $sid;
    # new 2015-01-04 - ken
    my $url = $sso_api_url . $sid . '.json';

    webLog("Status2: JGI SSO \n $url \n\n");

    my $ua = WebUtil::myLwpUserAgent();

    my $req = GET($url);            # new 2015-01-04 - ken
                                    #my $req = PUT($url);            # does a touch
    my $res = $ua->request($req);

    my $code = $res->code;

    #webLog("code: $code\n");

    # 200 - OK
    # 204 - ok but no content
    # 410 or 404 - Gone
    if ( $code eq "200" || $code eq "204" ) {
        return 1;
    } elsif ($code eq "410" || $code eq "404") {

        return $code;        
    } else {
        
        # sso issue? - SHOULD I even validate - lets just continue? 
        # what about portal logins
        my $content = $res->content;

        webLog("Error2: ====================\n\n");
        webLog("Error2: JGI SSO\n\n $url\n\n");
        webLog("Error2: JGI SSO $code \n $content \n");
        webLog("Error2: ====================\n\n");

        my $text = qq{
Error2: There is an issue with JGI SSO (https://signon.jgi.doe.gov/) <br> $code <br> $content <br><br>
Please try again<br><br>

$tipText
        };
        logout(1, "2 $code");
        WebUtil::webErrorHeader($text, 1);
    }
}

#  we need to touch the session to keep active
#
# curl -X PUT -d "" -D headers.txt https://signon.jgi-psf.org/api/sessions/e8b6ef108302e1e4
# ; cat headers.txt
#
#sub touch {
#    my($sid) = @_;
#
#    webLog("running: curl -i -X PUT $sso_url/api/sessions/$sid \n");
#

#}

sub logout {
    my ( $sso_logout, $code ) = @_;

    if ($sso_logout ) {
        # logout from portal or other jgi sso site
        WebUtil::loginLog( 'Caliban.pm logout', "sso $code" );

    } else {

        # portal logout is here ? or above
        WebUtil::loginLog( 'Caliban.pm logout', "img $code" );
    }

    WebUtil::clearSession();

    # http://blog.unmaskparasites.com/2009/10/28/evolution-of-hidden-iframes/
    #
    #     //window.open('$sso_url/signon/destroy', '_blank');
    #
    # this also calls the xml.cgi message file read twice 
    #
    if ($sso_logout) {
        print <<EOF;
    <script language='JavaScript' type='text/javascript'>
    document.cookie='jgi_return=$base_url/; domain=$sso_domain; path=/;';
    </script>

    <iframe height="0" width="0" style="visibility: hidden" src="$sso_url/signon/destroy"></iframe>
EOF
    }
}

sub sso_logout {
	return logout( 1, @_ );
}

#
# get caliban user info id
#
# # new urls return json format
# curl https://signon.jgi.doe.gov/api/users/3701.json
# curl https://signon.jgi.doe.gov/api/users.json?login=klchu
# curl http://contacts.jgi-psf.org/api/contacts/3696
# - 3696 is Ariel id not caliban id
# replaces
# curl https://signon.jgi.doe.gov/api/users/3701
# where 3701 is caliban id
#
sub getUserInfo2 {
    my ($id) = @_;

    # caliban id
    my $url = "https://signon.jgi.doe.gov/api/users/$id.json";

    webLog("$url\n");

    my $ua   = WebUtil::myLwpUserAgent();
    my $req  = GET($url);
    my $res  = $ua->request($req);
    my $code = $res->code;

    my $href1;
    if ( $code eq "200" ) {
        my $content = $res->content;
        $href1 = decode_json($content);

        #print $href->{'contact_id'} . "\n";
        #print $href->{'email'} . "\n";
    } else {

        #print "Failed: $url\n";
        return ( 0, '', '', '' );
    }

    my $contact_id = $href1->{'contact_id'};
    my $login      = $href1->{'login'};
    my $email      = $href1->{'email'};

    $url = "http://contacts.jgi-psf.org/api/contacts/$contact_id";

    webLog("$url\n");

    $req = GET($url);
    $res = $ua->request($req);
    my $href2;
    if ( $res->code eq "200" ) {
        my $content = $res->content;
        $href2 = decode_json($content);
    } else {

        #print "Failed: $url\n";
        return ( 0, '', '', '' );
    }

    $email = $href2->{'email_address'} if ( $email eq '' );
    my %userData = (
        'username'     => $login,
        'email'        => $email,
        'name'         => $href2->{'first_name'} . ' ' . $href2->{'last_name'},
        'phone'        => $href2->{'phone_number'},
        'organization' => $href2->{'institution'},
        'address'      => $href2->{'address_1'},
        'state'        => $href2->{'state'},
        'country'      => $href2->{'country'},
        'city'         => $href2->{'city'},
        'title'        => $href2->{'prefix'},
        'department'   => $href2->{'department'},
    );

    webLog(" 1, $login, lc($email),\n");
    return ( 1, $login, lc($email), \%userData );
}

# newer version
# new user json url
# https://signon.jgi-psf.org/api/sessions/01f3b5f748d90db59a4a4fbe5f1cbdb2.json
# {"ip":"128.3.44.193","id":"01f3b5f748d90db59a4a4fbe5f1cbdb2",
#  "user":{"created_at":"2011-02-15T14:52:51Z","email":"klchu@lbl.gov","id":3701,
#    "last_authenticated_at":"2015-04-28T18:31:26Z","login":"klchu","updated_at":"2015-01-07T18:55:00Z",
#    "contact_id":3696,"prefix":null,"first_name":"Ken","middle_name":null,"last_name":"Chu","suffix":null,
#    "gender":null,"institution":"Joint Genome Institute","institution_type":"DOE Lab","department":null,
#    "address_1":"2800 Mitchell Drive","address_2":"","city":"Walnut Creek","state":"CA","postal_code":"94598",
#    "country":"United States","phone_number":"925-296-5670",
#    "fax_number":null,"email_address":"klchu@lbl.gov",
#    "comments":null,"internal":true}
#    }
sub getUserInfo3 {
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
}

#
# check to see if username or email address has been banned
#
# - only works for jgi sso logins
# - img accounts are not found in the IsCalibanUser.cgi - get popup of bad login
#
sub checkBannedUsers {
    my ( $cur_username, $curr_email, $curr_email2 ) = @_;

    my $ans = getSessionParam("banned_checked");
    if ( $ans eq 'Yes' ) {
        return;
    }

    my $dbh = WebUtil::dbGoldLogin();
    my $sql = qq{
    select username, email
    from cancelled_user
    };

    my $cur = execSql( $dbh, $sql, $verbose );
    for ( ; ; ) {
        my ( $username, $email ) = $cur->fetchrow();
        last if !$username;

        if (   ( $cur_username eq $username )
            || ( lc($cur_username) eq lc($email) )
            || ( lc($curr_email)   eq lc($email) )
            || ( lc($curr_email2)  eq lc($email) ) )
        {
            my $text = qq{
Your account has been locked. <br>
If you believe this is an error please email us at:<br>
imgsupp at lists.jgi-psf.org (imgsupp\@lists.jgi-psf.org)
            };
            $cur->finish();

            main::printAppHeader("login");
            print $text;
            main::printContentEnd();
            main::printMainFooter();
            Caliban::logout(1, 3);
            WebUtil::webExit(0);
        }
    }

    setSessionParam( "banned_checked", "Yes" );
}

#
# user has no jgi caliban account
# user logins into img with img account
# ask user to migrate to jgi sso now - yes or no - show date Jan 1, 2016 as end of img accounts.
# if no just login for now.
# if yes
# - check to see if email already in caliban
# - display a new form to submit to jgi sso
# - try to prefill the data
# - tell users that an email will be sent to confirm password and jgi sso account
# -
# POST http://contacts.jgi-psf.org/api/registration.json
#
#field: required
#email_address: *yes*
#first_name: *yes*
#middle_name: no
#last_name: *yes*
#institution: *yes*
#institution_type: *yes* w/ CV
#department: no
#address_1: *yes*
#address_2: no
#city: *yes*
#state: *yes* if country is "United States"
#postal_code: no
#country: *yes*  w/ CV
#phone_number: *yes*
#
#
# 422: Argument error, required fields missing or not in CV
# 201: User registered
# 500: Server error
# Response Body
#"email_address":"bsiepert@lbl.gov",
#  "prefix":null,
#  "suffix":null,
#  "first_name":"Bryan",
#  "middle_name":null,
#  "last_name":"Siepert",
#  "gender":null,
#  "institution":"JGI",
#  "institution_type":"DOE Lab",
#  "department":null,
#  "address_1":"2800 Mitchell Drive",
#  "address_2":"",
#  "city":"Walnut Creek",
#  "state":"CA",
#  "postal_code":"94598",
#  "country":"United States",
#  "phone_number":"4155551212",
#  "fax_number":null,
#  "comments":null
#
sub migrateImg2JgiSso {
    my ($redirecturl) = @_;

    $redirecturl = 'main.cgi' if ( $redirecturl eq '' );

    my $contact_oid       = getSessionParam('contact_oid');
    my $email             = getSessionParam('email');
    my $caliban_id        = getSessionParam('caliban_id');
    my $caliban_user_name = getSessionParam('caliban_user_name');

    # the img public user account
    return if ( $contact_oid eq '901' );

    #webLog("1 migrateImg2JgiSso $caliban_id\n");

    if ( !$caliban_id ) {

        # check to see is user has a jgi sso account but has never log into IMG with jgi sso
        my $url = 'https://signon.jgi.doe.gov/api/users.json?email=' . $email;
        my $ua  = WebUtil::myLwpUserAgent();
        my $req = GET($url);
        my $res = $ua->request($req);

        #webLog("2 migrateImg2JgiSso $url\n");

        my $code = $res->code;
        if ( $code eq "200" ) {
            my $content = $res->content;
            my $aref    = decode_json($content);
            if ( $#$aref < -1 ) {
                $caliban_id = 0;

                #   webLog("3 migrateImg2JgiSso $caliban_id\n");

            } else {
                my $href = $aref->[0];
                $caliban_id        = $href->{'id'};
                $caliban_user_name = $href->{'login'};

                #  webLog("4 migrateImg2JgiSso $caliban_id $caliban_user_name\n");

            }
        }
    }

    # webLog("10 migrateImg2JgiSso $caliban_id\n");

    main::printAppHeader("login");

    if ($caliban_id) {

        # tell user to login with their JGIS SSO account
        my $template = HTML::Template->new( filename => "$base_dir/userJgiSsoExists.html" );
        $template->param( ssoUsername => $caliban_user_name );
        $template->param( url         => $redirecturl );
        print $template->output;
    } else {

        # tell user to signup for a jgi sso account
        my $template = HTML::Template->new( filename => "$base_dir/userJgiSsoNo.html" );

        $template->param( email => $email );
        $template->param( url   => $redirecturl );
        print $template->output;
    }

    main::printContentEnd();
    main::printMainFooter(1);
    WebUtil::webExit(0);

    # check to see if email exists in Caliban
    # if yes tell user to user jgi sso form to login
    # end.

    # now user does not have caliban account
    # try to get all user info to prefill a form for jgi sso account.

}

1;
