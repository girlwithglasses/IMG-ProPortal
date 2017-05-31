# $Id: WebDB.pm 37038 2017-05-02 20:05:55Z klchu $
#
#
package WebDB;

use strict;
use feature ':5.16';
use DBI;
use Data::Dumper;
use POSIX ':signal_h';
use MIME::Base64 qw( encode_base64 decode_base64 );

use WebConfig;
use WebPrint;
use WebIO;

my $env = WebConfig::getEnv();
#my $cgi_tmp_dir = $env->{cgi_tmp_dir};
#my $show_sql_verbosity_level = $env->{show_sql_verbosity_level};
#my $verbose = $env->{verbose};


# For sqlite
$ENV{TMP}     = $env->{cgi_tmp_dir};
$ENV{TEMP}    = $env->{cgi_tmp_dir};
$ENV{TEMPDIR} = $env->{cgi_tmp_dir};
$ENV{TMPDIR}  = $env->{cgi_tmp_dir};
$ENV{SQLITE_TMPDIR}  = $env->{cgi_tmp_dir};

my $maxClobSize = 38000;

# TODO timeout set?
# this might be ok since long process will reset timeout in their
# dispatch()
# and db connection is created after successful logins
# - ken
my $timeoutSec = '';

my $dbLoginTimeout = 10;    # 10 seconds
my ( $dsn, $user, $pw, $ora_port, $ora_host, $ora_sid );

# my $oracle_config = $env->{oracle_config} || undef;
# require $oracle_config if $oracle_config;

if ( $env->{oracle_config} ) {

	require $env->{oracle_config};

    $dsn      = $ENV{ORA_DBI_DSN};
    $user     = $ENV{ORA_USER};
    $pw       = $ENV{ORA_PASSWORD};
    $ora_port = $ENV{ORA_PORT};
    $ora_host = $ENV{ORA_HOST};
    $ora_sid  = $ENV{ORA_SID};
}

#
# create DB connections to IMG and GOLD
#
sub new
{
	my $class = shift;

	my $self = $_[0] ? shift :
	{
		imgDbh => undef,
		goldDbh => undef
	};

	bless $self, $class;
	return $self;
}


############################################################################
# execSql - Convenience wrapper to execute an SQL.
############################################################################
sub execSql_test {
    my ($self, $dbh, $sql, $verbose, @args ) = @_;

	if ( $verbose >= $env->{show_sql_verbosity_level} // 0 ) {
	    WebIO::webLog("$sql\n");
		if ( scalar @args ) {
			my $n = 0;
			WebIO::webLog( join "", map { $_ = "arg[$n] '$_'\n"; $n++; $_ } @args );
		}
	}

	use Carp;
	local $@;

    my $cur = eval {
    	$dbh->prepare( $sql ) or die "execSql: cannot preparse statement: $DBI::errstr\n"
    };
    confess $@ unless ! $@;

    $cur->execute( @args ) or die("execSql: cannot execute: $DBI::errstr\n");
    return $cur;
}

sub execSql {
    my ($self, $dbh, $sql, $verbose, @args ) = @_;
    WebIO::webLog("$sql\n") if ( $verbose >= $env->{show_sql_verbosity_level} // 0 );

    my $nArgs = @args;
    if ( $nArgs > 0 ) {
        my $s;
        for ( my $i = 0 ; $i < $nArgs ; $i++ ) {
            my $a = $args[$i];
            $s .= "arg[$i] '$a'\n";
        }
        WebIO::webLog($s) if ( $verbose >= $env->{show_sql_verbosity_level} // 0 );
    }
    my $cur = $dbh->prepare($sql)
      or die("execSql: cannot preparse statement: $DBI::errstr\n");
    $cur->execute(@args)
      or die("execSql: cannot execute: $DBI::errstr\n");
    return $cur;
}


############################################################################
# execSqlOnly - Convenience wrapper to execute an SQL. This does not
#   do any fetches.
############################################################################
sub execSqlOnly {
    my ($self, $dbh, $sql, $verbose, @args ) = @_;
    WebIO::webLog("$sql\n") if ( $verbose >= $env->{show_sql_verbosity_level} );
    my $cur = $dbh->prepare($sql)
      or die("execSql: cannot preparse statement: $DBI::errstr\n");
    my $nArgs = @args;
    if ( $nArgs > 0 ) {
        my $s;
        for ( my $i = 0 ; $i < $nArgs ; $i++ ) {
            my $a = $args[$i];
            $s .= "arg[$i] '$a'\n";
        }
        WebIO::webLog($s) if ( $verbose >= $env->{show_sql_verbosity_level} );
    }
    $cur->execute(@args)
      or die("execSql: cannot execute: $DBI::errstr\n");
    $cur->finish();
}

############################################################################
# execSqlBind - Convenience wrapper to execute an SQL with bind params.
#
# param $dbh - database handler
# param $sql - sql with '?' in the where clause statement
# param $bindList_aref - binding list of values
# param $verbose
# return sql execute cursor
#
# - ken
############################################################################
sub execSqlBind {
    my ($self, $dbh, $sql, $bindList_aref, $verbose ) = @_;
    WebIO::webLog "$sql\n"             if ( $verbose >= $env->{show_sql_verbosity_level} );
    WebIO::webLog("@$bindList_aref\n") if ( $verbose >= $env->{show_sql_verbosity_level} );
    my $cur = $dbh->prepare($sql)
      or WebUtil::webDie("execSqlBind: cannot preparse statement: $DBI::errstr\n");
    for ( my $i = 0 ; $i <= $#$bindList_aref ; $i++ ) {
        $cur->bind_param( ( $i + 1 ), $bindList_aref->[$i] )
        or die("execSqlBind: cannot bind param: $DBI::errstr\n");
    }
    $cur->execute()
      or die("execSqlBind: cannot execute: $DBI::errstr\n");
    return $cur;
}

############################################################################
# prepSql - Prepare SQL wrapper.
############################################################################
sub prepSql {
    my ($self, $dbh, $sql, $verbose ) = @_;
    WebIO::webLog "$sql\n" if $verbose >= 1;
    my $cur = $dbh->prepare($sql)
      or die("prepSql: cannot preparse statement: $DBI::errstr\n");
    return $cur;
}

############################################################################
# execStmt - Execute SQL statement.
############################################################################
sub execStmt {
    my ($self, $cur, @vars ) = @_;
    $cur->execute(@vars)
      or die("execStmt: cannot execute $DBI::errstr\n");
}


#
# max number of possible shared connections
#
sub getMaxSharedConn {
    my ($self, $dbh) = @_;

    # lets just return the value, one less query to run -ken
    return 100;
}

#
# the number of current open shared connections
#
# I should take 80% ??? of the max to test against to throw a db busy message
#
sub getOpenSharedConn {
    my ($self, $dbh, $gold) = @_;
    my $sql = qq{
select count(*) 
from v\$session 
where server != 'DEDICATED'
and osuser = 'wwwimg'
    };
    my $cur = $self->execSql( $dbh, $sql, $env->{verbose} );
    my ($cnt) = $cur->fetchrow();

    WebIO::webLog("\n\n getOpenSharedConn $gold ------------  " . $cnt . "\n\n");

    return $cnt;
}

sub dbLogin {
    my($self) = @_;

    WebIO::webLog("\n\nStatus: dbLogin ============================== \n\n");

    if ( $self->{imgDbh} ne '' ) {

        #http://search.cpan.org/~pythian/DBD-Oracle-1.64/lib/DBD/Oracle.pm#ping
        #        my  $rv = $DBH_IMG->ping;
        #        if($rv) {
        WebIO::webLog("img using pooled connection \n");
        return $self->{imgDbh};
    }

    if ( $ora_port ne "" && $ora_host ne "" && $ora_sid ne "" ) {
        $dsn = "dbi:Oracle:host=$ora_host;port=$ora_port;sid=$ora_sid;";
    }

    my $mask   = POSIX::SigSet->new(SIGALRM);    # signals to mask in the handler
    my $action = POSIX::SigAction->new(
        sub {
            WebUtil::webErrorHeader("Database connection timeout. UI is waiting too long. Please try again later.");
        },       # the handler code ref
        $mask # not using (perl 5.8.2 and later) 'safe' switch or sa_flags
    );

    my $oldaction = POSIX::SigAction->new();
    sigaction(SIGALRM, $action, $oldaction );
    my $dbh;
    eval {
        alarm($dbLoginTimeout);                  # seconds before time out
        $dbh = DBI->connect( $dsn, $user, $self->pwDecode($pw) );
        alarm(0);                                # cancel alarm (if connect worked fast)
    };
    alarm(0);                                    # cancel alarm (if eval failed)

    # restore original signal handler
    sigaction(SIGALRM, $oldaction );
    #alarm($timeoutSec) if ( $timeoutSec ne '' && $timeoutSec > 0 );
    WebUtil::timeout(0);

    if ($@) {
        WebUtil::webError("$@");
    } elsif ( !defined($dbh) ) {
        my $error = $DBI::errstr;

        #webLog("$error\n");
        if ( $error =~ "ORA-00018" ) {

            # "ORA-00018: maximum number of sessions exceeded"
            WebUtil::webErrorHeader( "<br/> Sorry, database is very busy. " . "Please try again later. <br/> $error", 1 );
        } else {
            WebUtil::webErrorHeader(
                "<br/>  This is embarrassing. Sorry, database is down. " . "Please try again later. <br/> $error", 1 );
        }
    }
    $dbh->{LongReadLen} = $maxClobSize;
    $dbh->{LongTruncOk} = 1;

    $self->{imgDbh} = $dbh;

    my $max = $self->getMaxSharedConn($dbh);
    my $opn = $self->getOpenSharedConn($dbh);
    WebIO::webLog("max = $max , open = $opn\n");
    if ( !$env->{ignore_db_check} && $opn >= $max ) {
        $self->dbLogoutImg();
        $self->dbLogoutGold();        
        WebUtil::webErrorHeader( "<br>We are sorry. The database is very busy ($opn, $max). Please try again later. <br> ", 1 );
    }

    return $dbh;
}

sub dbGoldLogin {
    my ($self, $isAjaxCall) = @_;

    if ( $self->{goldDbh} ne '' ) {

        #        my  $rv = $DBH_GOLD->ping;
        #        if($rv) {
        WebIO::webLog("gold using pooled connection \n");
        return $self->{goldDbh};

        #        }
    }

    # use the new database imgsg_dev
    my $user;        #     = "imgsg_dev";
    my $pw;          #       = decode_base64('VHVlc2RheQ==');
    my $ora_host;    # = 'muskrat.jgi-psf.org';                 #"jericho.jgi-psf.org";
    my $ora_port;    # = "";
    my $ora_sid;     #  = "imgiprd";
    my $dsn;         #      = "dbi:Oracle:" . $ora_sid;

    my $img_ken_localhost      = $env->{img_ken_localhost};
    my $img_gold_oracle_config = $env->{img_gold_oracle_config};

    if ($img_ken_localhost) {

        # used by ken for local testing only!

        $user = "imgsg_dev";
        $pw   = decode_base64('VHVlc2RheQ==');

        $ora_host = "localhost";
        $ora_port = "1531";
        $ora_sid  = "imgiprd";
    } elsif ($img_gold_oracle_config) {

        require $img_gold_oracle_config;
        $dsn      = $ENV{ORA_DBI_DSN_GOLD};
        $user     = $ENV{ORA_USER_GOLD};
        $pw       = $self->pwDecode( $ENV{ORA_PASSWORD_GOLD} );
        $ora_port = "";
        $ora_sid  = "";
        $ora_host = "";

        #webLog("===== using gold snapshot db ===========\n");
    }

    if ( $ora_port ne "" ) {
        $dsn = "dbi:Oracle:host=$ora_host;port=$ora_port;sid=$ora_sid";
    }

    my $mask   = POSIX::SigSet->new(SIGALRM);    # signals to mask in the handler
    my $action = POSIX::SigAction->new(
        sub {
            if ($isAjaxCall) {
                return '';
                exit(0);
            } else {
                WebUtil::webErrorHeader("GOLD database connection timeout. UI is waiting too long. Please try again later.");
            }

        },                                       # the handler code ref
        $mask

          # not using (perl 5.8.2 and later) 'safe' switch or sa_flags
    );

    my $oldaction = POSIX::SigAction->new();
    sigaction(SIGALRM, $action, $oldaction );
    my $dbh;
    eval {
        alarm($dbLoginTimeout);                  # seconds before time out
        $dbh = DBI->connect( $dsn, $user, $self->pwDecode($pw) );
        alarm(0);                                # cancel alarm (if connect worked fast)
    };
    alarm(0);                                    # cancel alarm (if eval failed)

    # restore original signal handler
    sigaction(SIGALRM, $oldaction );
    #alarm($timeoutSec) if ( $timeoutSec ne '' && $timeoutSec > 0 );
    WebUtil::timeout(0);

    if ($@) {
        WebUtil::webError("$@");
    } elsif ( !defined($dbh) ) {
        my $error = $DBI::errstr;

        #webLog("$error\n");
        if ( $error =~ "ORA-00018" ) {

            # "ORA-00018: maximum number of sessions exceeded"
            WebUtil::webErrorHeader( "<br/> DB GOLD: Sorry, database is very busy. " . "Please try again later. <br/> $error", 1 );
        } else {
            WebUtil::webErrorHeader(
                "<br/> DB GOLD: This is embarrassing. Sorry, database is down. " . "Please try again later. <br/> $error",
                1 );
        }
    }
    $dbh->{LongReadLen} = $maxClobSize;
    $dbh->{LongTruncOk} = 1;

     $self->{goldDbh} = $dbh;

    my $max = $self->getMaxSharedConn($dbh);
    my $opn = $self->getOpenSharedConn($dbh, 'gold');
    WebIO::webLog("max = $max , open = $opn\n");
    if ( !$env->{ignore_db_check} && $opn >= $max ) {
        $self->dbLogoutImg();
        $self->dbLogoutGold();        
        
        WebUtil::webErrorHeader( "<br>We are sorry. The GOLD database is very busy ($opn, $max). Please try again later. <br> ", 1 );
    }

    return $dbh;
}

sub logout {
    my $self = shift;
    $self->dbLogoutGold();
    $self->dbLogoutImg();
}

sub dbLogoutGold {
    my($self) = @_;
    if (  $self->{goldDbh}  ) {
        WebIO::webLog("gold pooled connection logout\n");
        my $dbh =  $self->{goldDbh};
        $dbh->disconnect();
        $self->{goldDbh} = undef;
    }
}

sub dbLogoutImg {
    my ($self) = @_;
    if ( $self->{imgDbh}) {
        WebIO::webLog("img pooled connection logout\n");
        my $dbh = $self->{imgDbh};
        $dbh->disconnect();
        $self->{imgDbh} = undef;
    }
}


############################################################################
# sdbLogin - Login to oracle or some RDBMS and return handle.
#   If "mode" is write, create a new sdb file.
############################################################################
sub sdbLogin {
    my ($self, $sdb_name, $mode, $exit ) = @_;

    my $sdbh;
    WebIO::webLog(">>> sdbLogin: '$sdb_name' (mode='$mode')\n");
    if ( $sdb_name && ( -e $sdb_name ) ) {
        $sdbh = DBI->connect( "dbi:SQLite:dbname=$sdb_name", "", "", { RaiseError => 1 }, );
    } elsif ( $sdb_name && $mode eq "w" ) {
        unlink($sdb_name);
        $sdbh = DBI->connect( "dbi:SQLite:dbname=$sdb_name", "", "", { RaiseError => 1 }, );
    }
    if ( !defined($sdbh) ) {
        WebIO::webLog("sdbLogin: cannot connect dbi:SQLite:dbname=$sdb_name\n");
        my $error = $DBI::errstr;

        if ($exit) {
            WebUtil::webErrorHeader(
"<br/>  This is embarrassing. Sorry, $sdb_name SQLite database is down. Please try again later. <br/> $error",
                1
            );
        }
    }

    return $sdbh;
}

############################################################################
# decode - Decode base64
############################################################################
sub decode {
    my ($self, $b64) = @_;
    my $s = decode_base64($b64);
    return $s;
}

############################################################################
# pwDecode - Password decode if encoded.
############################################################################
sub pwDecode {
    my ($self, $pw) = @_;
    my ( $tag, @toks ) = split( /:/, $pw );
    if ( $tag eq "encoded" ) {
        my $val = join( ':', @toks );
        return $self->decode($val);
    } else {
        return $pw;
    }
}


1;

