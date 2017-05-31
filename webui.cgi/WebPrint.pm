# $Id: WebPrint.pm 36955 2017-04-17 19:34:55Z klchu $
#
#
package WebPrint;

use strict;
use feature ':5.16';
use CGI qw( :standard  );
use Time::localtime;
use MIME::Base64 qw( encode_base64 decode_base64 );
use FileHandle;
use Data::Dumper;
use Cwd;
use File::Path qw(make_path remove_tree);
use Sys::Hostname;
use POSIX ':signal_h';
use Template;
use HTML::Template;
use JSON;

use WebIO;
use WebConfig;
use WebUtil;

my $env      = getEnv();
my $abc      = $env->{abc};        # BC & SM home
my $base_dir                 = $env->{base_dir};
my $base_url                 = $env->{base_url};
my $cgi_dir                  = $env->{cgi_dir};
my $cgi_tmp_dir              = $env->{cgi_tmp_dir};
my $MESSAGE                  = $env->{message};
my $top_base_url             = $env->{top_base_url};
my $top_base_dir             = $env->{top_base_dir};
my $dblock_file              = $env->{dblock_file};
my $default_timeout_mins     = $env->{default_timeout_mins};
my $img_edu                  = $env->{img_edu};
my $img_er                   = $env->{img_er};
my $img_geba                 = $env->{img_geba};
my $img_hmp                  = $env->{img_hmp};
my $img_internal             = $env->{img_internal};
my $img_ken                  = $env->{img_ken};
my $img_proportal            = $env->{img_proportal};
my $img_version              = $env->{img_version};
my $include_metagenomes      = $env->{include_metagenomes};
my $virus                    = $env->{virus};

my $public_login             = $env->{public_login};
my $user_restricted_site     = $env->{user_restricted_site};

############################################################################
# WebUtil::webDie - Code dies a serious death.   Show on web.
############################################################################
sub webDie {
	say 'running WebUtil::webDie unaltered';
	my ($s) = @_;

	#print "Content-type: text/html\n\n";
	print header( -type => "text/html", -status => '404 Not Found' );
	print "<html>\n";
	print "<p>\n";
	print "SCRIPT ERROR:\n";
	print "<p>\n";
	print "<font color='red'>\n";
	print "<b>$s</b>\n";
	print "</font>\n";

	webExit(0);
}

############################################################################
# WebUtil::webError - Show error message.
############################################################################
sub webError {
	my ( $txt, $exitcode, $noHtmlEsc ) = @_;

	if ( $env->{img_ken} ) {
		print "Content-type: text/html\n\n";    # test from ken

		my @names = param();
		foreach my $p (@names) {
			my $x = param($p);
			print "$p => $x <= <br>\n";
		}
	}
	my $copyright_year = $env->{copyright_year};
	my $version_year   = $env->{version_year};

	my $remote_addr = getIpAddress() // '';
	my $servername;
	my $s = getHostname();
	$servername = $s . ' ' . ( $ENV{ORA_SERVICE} || "" ) . ' ' . $];
	my $buildDate = WebIO::file2Str( $env->{base_dir} . "/buildDate", 1 ) // '';

	print "<div id='error'>\n";
	print "<img src='"
	  . $env->{base_url}
	  . "/images/error.gif' "
	  . "width='46' height='46' alt='Error' />\n";
	print "<p>\n";
	if ($noHtmlEsc) {
		print $txt;
	}
	else {
		print WebUtil::escHtml($txt);
	}
	print "</p>\n";
	print "</div>\n";
	print "<div class='clear'></div>\n";
	my $str = WebIO::file2Str( $env->{base_dir} . "/footer.html" );
	$str =~ s/__main_cgi__/$env->{main_cgi}/g;
	$str =~ s/__google_analytics__//g;

	$str =~ s/__copyright_year__/$copyright_year/;
	$str =~ s/__version_year__/$version_year/;

	$str =~ s/__server_name__/$servername/;
	$str =~ s/__build_date__/$buildDate $remote_addr/;
	$str =~ s/__post_javascript__//;

	print "$str\n";

	printStatusLine( "Error", 2 );
	webExit($exitcode);
}

############################################################################
# WebUtil::webErrorHeader - Show error with header.
############################################################################
sub webErrorHeader {
	print header( -type => "text/html" );
	print "<br>\n";
	webError(@_);
}

#
# web exit
# this should be use instead of the perl exit command
# - ken
#
sub webExit {
	my ($code) = @_;

	$code = 0 if !$code;

	exit $code;
}

sub getIpAddress {

# HTTP_X_FORWARDED_FOR gets true client ip address when there is a load balancer port forwarding to web server
# REMOTE_ADDR will be the 127.xxxxx ip address which is imcorrect - ken
	my $remote_addr = $ENV{HTTP_X_FORWARDED_FOR};
	if ( !$remote_addr ) {
		$remote_addr = $ENV{REMOTE_ADDR};
	}
	return $remote_addr;
}

#
# get server's hostanme eg gpweb04, gpweb05 etc
#
sub getHostname {
	my $host = hostname;
	if ( $host ne '' ) {
		return $host;
	}

	# otherwise try command line way of getting host name
	unsetEnvPath();    # to avoid -T errors in perl 5.10 - ken
	delete @ENV{ 'IFS', 'CDPATH', 'ENV', 'BASH_ENV' };
	my $servername = `/bin/hostname`;
	chomp $servername;
	return $servername;
}

############################################################################
# unsetEnvPath - Unset the environment path for external calls.
############################################################################
sub unsetEnvPath {

	my $envPath = $ENV{PATH};
	if ( $envPath =~ /^(.*)$/ ) {
		$ENV{PATH} = $1;    #untaint
	}
	return;
}

############################################################################
# printStatusLine - Show status line in the UI.
############################################################################
sub printStatusLine {
	my ( $s, $z_index ) = @_;
	my $zidx = 1;
	if ( $z_index > 1 || blankStr($s) ) {
		$zidx = 2;
	}
	if ( $s =~ /Loading/ ) {

		#
	}
	else {
		$s =~ s/\n/ /g;
		$s =~ s/"/'/g;
		print qq{
        <script language='javascript' type='text/javascript'>
            var e0 = document.getElementById( "loading" );
            if(e0 != null) {
                e0.innerHTML = "$s";
            }
        </script>
        };
	}
}

###########################################################################
# blankStr - Is blank string.  Return 1=true or 0=false.
###########################################################################
sub blankStr {
	my $s = shift;

	if ( $s =~ /^[ \t\n]+$/ || $s eq "" ) {
		return 1;
	}
	else {
		return 0;
	}
}

#
# print an img header with no js source files just css files
#
sub printHeader {
	my $tt = Template->new(
		{
			INCLUDE_PATH => $base_dir,
			INTERPOLATE  => 1,
		}
	) or die "$Template::ERROR\n";

	$tt->process("header.tt") or die $tt->error();
}

#
# print standard img footer
#
sub printMainFooter {
	my ( $homeVersion, $postJavascript ) = @_;

	$postJavascript = '' if !$postJavascript;

# HTTP_X_FORWARDED_FOR gets true client ip address when there is a load balancer port forwarding to web server
# REMOTE_ADDR will be the 127.xxxxx ip address which is imcorrect - ken
	my $remote_addr = getIpAddress();

	# try to get true hostname
	# can't use back ticks with -T
	# - ken
	my $servername =
	  $ENV{SERVER_NAME};    # this does not work on the new gpweb36/37 - ken
	my $hostname = getHostname();

	my $img_rdbms = '';
	if ( $env->{img_ken} ) {
		$img_rdbms = '<br>' . $env->{oracle_config_dir};
	}

	$servername = $hostname . " $img_rdbms " . $ENV{ORA_SERVICE} . ' ' . $];

	#    my $copyright_year = $env->{copyright_year};
	#    my $version_year   = $env->{version_year};
	my $img = param("img");

	# no exit read
	my $buildDate = WebIO::file2Str( $env->{base_dir} . "/buildDate", 1 );
	my $templateFile = $env->{base_dir} . "/footer-v33.html";

	#$templateFile = $env->{base_dir} . "/footer-v33.html" if ($homeVersion);
	my $s = WebIO::file2Str( $templateFile, 1 );
	$s =~ s/__main_cgi__/$env->{main_cgi}/g;
	$s =~ s/__base_url__/$env->{base_url}/g;
	$s =~ s/__copyright_year__/$env->{copyright_year}/;
	$s =~ s/__version_year__/$env->{version_year}/;
	$s =~ s/__server_name__/$servername/;
	$s =~ s/__build_date__/$buildDate $remote_addr/;
	$s =~ s/__google_analytics__//;
	$s =~ s/__post_javascript__/$postJavascript/;
	$s =~ s/__top_base_url__/$env->{top_base_url}/g;
	print "$s\n";
}

# end content div
sub printContentEnd {
	print qq{
    </div> <!-- end of content div  -->
        <div id="myclear"></div>
    };

	print qq{
    </div> <!-- end of container div  -->
    };
}

# other pages content div
sub printContentOther {
	print qq{
    <div id="content_other">
    };
}

# home page content div
sub printContentHome {
	if ($abc) {
		print qq{
    <div id="content" class='content contentABC'>
    };

	}
	else {
		print qq{
    <div id="content" class='content'>
    };
	}
}

# error frame - test to see if js enabled
# if enabled you can use div's id "error_content" innerHtml to display an error message
# and
# error frame - hidden by default but to display set an in-line style:
#  style="display: block" to override the default css
# 4th div
sub printErrorDiv {
    my $section = param('section');

    my $template = HTML::Template->new( filename => "$base_dir/error-message-tmpl.html" );
    $template->param( base_url => $base_url );

    print $template->output;

    # message from the web config file - ken
    if ( $MESSAGE ne "" ) {
        print qq{
        <div id="message_content" class="message_frame shadow" style="display: block" >
        <img src='$top_base_url/images/announcementsIcon.gif'/>
        $MESSAGE
        </div>
    };
    }
}

# newer version using async
sub googleAnalyticsJavaScript2 {
    my ( $server, $google_key ) = @_;

    my $str = WebUtil::file2Str( "$top_base_dir/js/google2.js", 1 );
    $str =~ s/__google_key__/$google_key/g;
    $str =~ s/__server__/$server/g;

    return $str;
}



sub getNewsHeaders {
    my ($maxLines) = @_;
    $maxLines = 3 if ( !$maxLines );
    my $file  = '/webfs/scratch/img/news.html';
    my $lines = '';

    my $line;
    my $rfh = newReadFileHandle($file);
    my $i   = 0;
    while ( my $line = $rfh->getline() ) {
        last if ( $i > $maxLines );
        if ( $line =~ /^<b id='subject'>/ ) {
            $line =~ s/<br>//;
            $line =~ s/<\/br>//;
            my $tmp = $i + 1;
            $lines .= "<a href='main.cgi?section=Help&page=news#$tmp'>" . $line . "</a><br>";
            $i++;
        }
    }
    close $rfh;

    return $lines;
}

sub printMenuDiv {

    # menu file json data
    # read file
    my $content;
    if ( $abc ) {
      $content = WebUtil::file2Str("$base_dir/menu-abc.json");
    } else {
      $content = WebUtil::file2Str("$base_dir/menu.json");
    }

    my $aref = decode_json($content);
    print "<div id='menu'>\n";
    printMenuRow( $aref, 0 );
    print qq{
        </div> <!-- end menu div -->
<div id="myclear"></div>
<div id="container">        
    };
}

sub printMenuRow {
    my ( $aref, $level ) = @_;
    return if ( $aref eq '' );

    my $subarrowRight = "<img class='subarrow' src='../../images/ArrowNav.gif'/>";
    my $subarrowLeft  = "<img class='subarrow_left' src='../../images/ArrowNav_left.gif'/>";

    if ( $level == 0 ) {
        print "<ul id='nav'>\n";
    } elsif ( $level == 1 ) {
        print "    <ul>\n";
    } else {
        print "        <ul>\n";
    }

    foreach my $menutop_href (@$aref) {
        my $name              = $menutop_href->{'name'};
        my $level             = $menutop_href->{'level'};
        my $title             = $menutop_href->{'title'};
        my $url               = $menutop_href->{'url'};
        my $icon              = $menutop_href->{'icon'};
        my $arrow             = $menutop_href->{'arrow'};
        my $not_avaiable_href = $menutop_href->{'not avaiable'};
        if ( !$not_avaiable_href ) {
            $not_avaiable_href = $menutop_href->{'not in'};
        }
        my $submenu_aref = $menutop_href->{'submenu'};
        my $onClick      = $menutop_href->{'onClick'};

        next if ( $abc                 && exists $not_avaiable_href->{'abc'} );
        next if ( $img_edu             && exists $not_avaiable_href->{'edu'} );
        next if ( $img_hmp             && exists $not_avaiable_href->{'hmp'} );
        next if ( $img_proportal       && exists $not_avaiable_href->{'proportal'} );
        next if ( $virus               && exists $not_avaiable_href->{'vr'} );
        next if ( $include_metagenomes && !$user_restricted_site && exists $not_avaiable_href->{'m'} );
        next if (!$img_ken && $include_metagenomes && $user_restricted_site && exists $not_avaiable_href->{'mer'} );
        next if (exists $not_avaiable_href->{'public'} && !$public_login && !$user_restricted_site); 

        my $arrowStr = '';
        if ( $arrow eq 'right' ) {
            $arrowStr = $subarrowRight;
        } elsif ( $arrow eq 'left' ) {
            $arrowStr = $subarrowLeft;
        }

        my $iconStr = '';
        if ($icon) {
            $iconStr = "<img class='menuimg' src='../../images/$icon'/>";
        }

        my $titleStr = '';
        if ($title) {
            $titleStr = "title='$title'";
        }

        if ( $level == 0 && $name ne 'Help' ) {
            print qq{    <li><a href="$url"> $name </a>\n};
        } elsif ( $level == 0 && $name eq 'Help' ) {
            print qq{    <li class="rightmenu"><a href="$url"> $name </a>\n};
        } elsif ( $level == 1 && $submenu_aref ne '' && $#$submenu_aref < 0 ) {
            print qq{        <li class="sub" $titleStr><a href="$url">$iconStr $name </a>\n};
        } elsif ( $level == 1 && $submenu_aref ne '' && $#$submenu_aref > -1 ) {
            if ( $arrow eq 'right' ) {
                print qq{        <li class="sub2" $titleStr><a href="$url">$iconStr $name $arrowStr</a>\n};
            } elsif ( $arrow eq 'left' ) {
                print qq{        <li class="sub2" $titleStr><a href="$url">$arrowStr $iconStr $name </a>\n};
            } else {
                print qq{       <li class="sub2" $titleStr><a href="$url">$iconStr $name </a>\n};
            }
        } elsif ( $level == 2 ) {
            print qq{           <li class="sub3" $titleStr><a href="$url">$iconStr $name </a>\n};
        }

        if ( $submenu_aref ne '' && $#$submenu_aref > -1 ) {
            printMenuRow( $submenu_aref, $level + 1 );
        }
        if ( $level == 0 ) {
            print "    </li>\n";
        } elsif ( $level == 1 ) {
            print "        </li>\n";
        } else {
            print "            </li>\n";
        }

    }

    if ( $level == 0 ) {
        print "</ul>\n";
    } elsif ( $level == 1 ) {
        print "    </ul>\n";
    } else {
        print "        </ul>\n";
    }
}



1;
