############################################################################
#
# see webUI/worker.cgi
#
# $Id: Command.pm 36499 2016-12-13 18:59:08Z klchu $
############################################################################
package Command;

use strict;
use Data::Dumper;
use WebConfig;
use WebUtil;
use Cwd;
use File::Path qw(make_path remove_tree);
use LWP::UserAgent;
use HTTP::Request::Common qw( GET POST);
use threads;

$| = 1;

my $env            = getEnv();
my $common_tmp_dir = $env->{common_tmp_dir};
my $cassetteDir    = $env->{fastbit_dir};
my $img_ken        = $env->{img_ken};
my $base_url       = $env->{base_url};
my $worker_base_url = $env->{worker_base_url};

my $thr = ''; # print dot thread

#
# create a session directory to store temp files
# this dir is located at common_tmp_dir where gpint05 and gpweb04 to 07 can read and write data too
#
# return session directory
#
sub createSessionDir {

    my $sessionId = getSessionId();

    #my $hostname = WebUtil::getHostname(); # load balancer issues
    my $hostname = 'gpweb36_37_shared';

    #my @tmps   = split( /\//, $base_url );
    my $urlTag = $env->{urlTag}; #$tmps[$#tmps];

    my $dir = $common_tmp_dir . "/$hostname/$urlTag/" . $sessionId;

    # untaint
    if ( $dir =~ /^(.*)$/ ) { $dir = $1; }

    print "making dir $dir <br/>\n" if ($img_ken);
    if ( !( -e "$dir" ) ) {
        umask 0002;
        make_path( $dir, { mode => 0775 } );

        #chmod (0777, $dir);
    }

    print "done making dir $dir <br/>\n" if ($img_ken);
    return $dir;
}

#
# create the command file to run on gpint05
#
# structure of the file
# cd=some directory to 'cd' to optional param
# cmd=the script to run all on one line
# stdout=a file to write out the stdout from the above cmd
#
#cd=/global/homes/k/klchu/Dev/cassettes/v3/genome/
#cmd=/global/homes/k/klchu/Dev/cassettes/v3/genome/findCommonPropsInTaxa db 638341121 2013515003
#stdout=/global/projectb/scratch/img/www-data/service/tmp/gpweb04/<urltag>/e100eb6e22a772898a6060a79a668c0c/output7877.txt
#
# $command - full path to the script to run with all options
# $cdDir - optional  the directory to 'cd' before running the script
#
# return:
# $cmdFile - full path to the command file
# $stdOutFilePath - full path the stdout file
#
sub createCmdFile {
    my ( $command, $cdDir ) = @_;

    my $dir = createSessionDir();

    my $cmdFile        = $dir . '/cmd' . $$ . '.txt';
    my $stdOutFilePath = $dir . '/output' . $$ . '.txt';

    my $wfh = WebUtil::newWriteFileHandle($cmdFile);
    print $wfh "cd=$cdDir\n" if ( $cdDir ne '' );
    print $wfh "cmd=$command\n";
    print $wfh "stdout=$stdOutFilePath";
    close $wfh;

    return ( $cmdFile, $stdOutFilePath );
}

#
# run the script on gpint05
#
# $cmdFile - full path to the command file
# $stdOutFile - full path the stdout file
#
# retrun
# $stdOutFile
# or -1 on failure
#
sub runCmdViaUrl {
    my ( $cmdFile, $stdOutFile ) = @_;

    # call url
    my $tmp = CGI::escape($cmdFile);
    my $url = $worker_base_url . "/cgi-bin/runCmd/cmd.cgi?file=$tmp";
    
    # add users email to the end of the url
    my $email = getSessionParam("email");
    if($email ne '') {
        $email = CGI::escape($email);
        $url = $url . '&email=' . $email;
    }
    
    if ($img_ken) {
        print "<pre>$url </pre><br/>";
    }

    my $ua   = WebUtil::myLwpUserAgent(); #new LWP::UserAgent();
    #$ua->ssl_opts(verify_hostname => 0, SSL_verify_mode => 0x00);
    
    # 120 is from Fin gene blast printDotThread()
    # 120 x 5 = 600 secs or 10 mins
    # grep startDotThread * - 20 mins is the largest
    $ua->timeout(1200);
    
    my $req  = GET($url);
    my $res  = $ua->request($req);
    my $code = $res->code;
    if ( $code eq "200" ) {
        my $content = $res->content;
        if ( $content =~ /Error:/ || $content =~ /Failure:/ ) {
            print qq{
            <br>
            failed<br/>
            $code <br/>
            $content
            };
            return -1;

        } else {

            # do noting for now
            #print "$content<br/>\n";
        }

        return $stdOutFile;
    } else {
        my $content = $res->content;
        print qq{
            <br>
            Failed: Message from BLAST Server - <br/>
            $code <br/>
            $content
        };
        return -1;
    }
}

#
# kill the dot printing thread when the process is done.
#
sub killDotThread {
    # Send a signal to a thread
    print "killDotThread <br>\n";
    $thr->kill('KILL')->detach();
}

#
# starts printing dots to the browser
#
# ONLY one dot thread for now - ken
# do not call startDotThread() more than once.
#
# How to use:
# printStartWorkingDiv();
# ....
# require Command;
#
# Command::startDotThread(120); # print dots every 5 secs for a max of 120 times, default is 60 times
# ....... do your long running query here ....
# Command::killDotThread();
# ...
# printEndWorkingDiv(); 
# 
sub startDotThread {
    my @a = @_;
    
    $thr = threads->create( 'printDotThread', @a);
    #$thr->join;    
}

# This is a private function DO NOT call this function
#
# printing dots every 5 secs for a max of $times times
# default is 60 times if not set.
#
sub printDotThread {
    my($times) = @_;
    $times = 60 if($times eq '');
    
    # thread kill handler
    $SIG{'KILL'} = sub { threads->exit(); };
    
    for(my $i=0; $i < $times; $i++) {
        print "Waiting ... $i / $times .. <br>\n";
        sleep 5; # 5 secs
    }
}

1;
