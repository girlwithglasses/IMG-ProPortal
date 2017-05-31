# $Id: WebIO.pm 36955 2017-04-17 19:34:55Z klchu $
#
# for:
# opening files
# logging
# creating directories or files
# file checks
# - ken
#
package WebIO;
use strict;
use feature ':5.16';
use Time::localtime;
use MIME::Base64 qw( encode_base64 decode_base64 );
use FileHandle;
use Data::Dumper;
use Cwd;
use File::Path qw(make_path remove_tree);
use Sys::Hostname;
use POSIX ':signal_h';
use Carp;
use WebConfig;

my $env = WebConfig::getEnv();

#############################################################################
# appendFile - Append string to file.
#############################################################################
sub appendFile {
    my ( $file, $str ) = @_;
    my $afh = newAppendFileHandle( $file, "appendFile" );
    print $afh $str;
    close $afh;
}

#
# file name cannot have the following chars
# .. \ / ~ ' " `
#
sub checkFileName {
    my ($fname) = @_;
    if (   $fname =~ /\\/
        || $fname =~ /\.\./
        || $fname =~ /\//
        || $fname =~ /~/
        || $fname =~ /\'/
        || $fname =~ /\"/
        || $fname =~ /`/ )
    {
        die("Invalid filename: $fname\n");
    }
    return $fname;
}

############################################################################
# checkPath - Check path for invalid characters.
############################################################################
sub checkPath {
    my ($path) = @_;
    ## Catch bad pattern first.
    my @toks = split( /\//, $path );
    for my $t (@toks) {
        next if $t eq "";    # for double slashes
        if ( $t !~ /^[a-zA-Z0-9_\.\-\~]+$/ || $t eq ".." ) {
            confess("checkPath:1: invalid path '$path' tok='$t'\n");
            die("checkPath:1: invalid path '$path' tok='$t'\n");
        }
    }
    ## Untaint.
    $path =~ /([a-zA-Z0-9\_\.\-\/]+)/;
    my $path2 = $1;
    if ( $path2 eq "" ) {
        confess("checkPath:2: invalid path '$path2'\n");
        die("checkPath:2: invalid path '$path2'\n");
    }
    return $path2;
}

############################################################################
# checkTmpPath - Wrap temp path for safety.  An additional
#   check for writing (or reading) to (from) temp directory.
############################################################################
sub checkTmpPath {
    my ($path) = @_;
    my $common_tmp_dir = $env->{common_tmp_dir};
    my $tmp_dir = $env->{tmp_dir};
    my $cgi_tmp_dir = $env->{cgi_tmp_dir};
    if ( $path !~ /^$tmp_dir/ && $path !~ /^$cgi_tmp_dir/ && $path !~ /^$common_tmp_dir/ ) {
        die( "checkTmpPath: expected full temp directory " . "'$tmp_dir' or '$cgi_tmp_dir'; got path '$path'\n" );
    }
    $path = checkPath($path);
    my $fname  = lastPathTok($path);
    my $fname2 = validFileName($fname);
    return $path;
}


sub conditionalFile2Str {
    my ( $file, $origLine, $newLine ) = @_;

    my $rfh  = newReadFileHandle( $file, "file2Str" );
    my $line = '';
    my $s    = '';
    while ( $line = $rfh->getline() ) {
        if ( $line =~ /$origLine/i ) {
            $s .= $newLine;
        } else {
            $s .= $line;
        }
    }
    close $rfh;
    return $s;
}

###########################################################################
# file2Str - Convert file contents to string.
###########################################################################
sub file2Str {
    my ( $file, $noexit ) = @_;

    my $rfh  = newReadFileHandle( $file, "file2Str", $noexit );
    my $line = "";
    my $s    = "";
    if ( !$rfh && $noexit ) {
        return $s;
    }

    while ( $line = $rfh->getline() ) {
        $s .= $line;
    }
    close $rfh;
    return $s;
}

#############################################################################
# fileAtime - Return file access time for file name.
#############################################################################
sub fileAtime {
    my ($fileName) = @_;
    my $rfh = newReadFileHandle( $fileName, "fileAtime", 1 );
    return 0 if !$rfh;
    my ( $dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size, $atime, $mtime, $ctime, $blksize, $blocks ) = stat($rfh);
    close $rfh;

    return $mtime;
}

############################################################################
# fileRoot - Get file name root from path.
############################################################################
sub fileRoot {
    my ($path) = @_;
    my $fileName = lastPathTok($path);
    my ( $fileRoot, @exts ) = split( /\./, $fileName );
    return $fileRoot;
}

#############################################################################
# fileSize - Return file size of file name.
#############################################################################
sub fileSize {
    my ($fileName) = @_;
    my $rfh = newReadFileHandle( $fileName, "fileSize", 1 );
    return 0 if !$rfh;
    my ( $dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size, $atime, $mtime, $ctime, $blksize, $blocks ) = stat($rfh);
    close $rfh;
    return $size;
}

#
# touch a file / update the access time such that the
# file is not purged by cgi purge timeout
# - Ken
#
sub fileTouch {
    my ($fileName) = @_;

    # cannot use with perl -T
    my $now = time;

    $fileName = checkPath($fileName);

    if ( $fileName =~ /^(.*)$/ ) { $fileName = $1; }
    utime( $now, $now, $fileName );

    #if ($fileName =~ /^(.*)$/) { $fileName = $1; }
    # fileName is now untainted

}

# mkdir -p
sub myMakeDir {
    my ($dir) = @_;
    umask 0000;
    my $err;
    make_path( $dir, { mode => 0777, error => \$err} );
    if (@$err) {
      for my $diag (@$err) {
          my ($file, $message) = %$diag;
          if ($file eq '') {
              die("Cannot make $dir: general error: $message\n");
          } else {
              die("Cannot make $dir: problem unlinking $file: $message\n");
          }
      }
    }
}

############################################################################
# newAppendFileHandle - Security wrapper for new FileHandle.
############################################################################
sub newAppendFileHandle {
    my ( $path, $func, $noExit ) = @_;

    $func = "newAppendFileHandle" if $func eq "";
    $path = checkPath($path);
    my $fh = new FileHandle( $path, "a" );

    # to stop infinite loop when log files cannot be open - ken
    if ( !$fh && ( $func eq "webLog" || $func eq "webErrLog" ) ) {
        #print "Cannot open log file $path \n";
        die("Cannot open log file $path \n");
    }

    if ( !$fh && !$noExit ) {
        die("$func: cannot append '$path'\n");
    }
    return $fh;
}

############################################################################
# newCmdFileHandle - Security wrapper for new FileHandle with command.
############################################################################
sub newCmdFileHandle {
    my ( $cmd, $func, $noExit ) = @_;

    $func = "newCmdFileHandle" if $func eq "";

    # http://perldoc.perl.org/perlipc.html#Using-open()-for-IPC
    #
    # see section "Using open() for IPC"
    # - ken
    #$SIG{PIPE} = 'IGNORE';
    $SIG{PIPE} = sub {
        die "<p><font color='red'> pipe failed. </font></p>\n";
    };

    my $fh = new FileHandle("$cmd |");
    if ( !$fh && !$noExit ) {
        die("$func: cannot '$cmd'\n");
    }
    return $fh;
}

############################################################################
# newReadFileHandle - Security wrapper for new FileHandle.
############################################################################
sub newReadFileHandle {
    my ( $path, $func, $noExit ) = @_;

    $func = "newReadFileHandle" if $func eq "";
    $path = checkPath($path);
    my $fh = new FileHandle( $path, "r" );
    if ( !$fh && !$noExit ) {
        die("$func: cannot read '$path'\n");
    }
    return $fh;
}

############################################################################
# newWriteFileHandle - Security wrapper for new FileHandle.
############################################################################
sub newWriteFileHandle {
    my ( $path, $func, $noExit ) = @_;

    $func = "newWriteFileHandle" if $func eq "";
    $path = checkPath($path);
    my $fh = new FileHandle( $path, "w" );
    if ( !$fh && !$noExit ) {
        die("$func: cannot write '$path'\n");
    }
    return $fh;
}

############################################################################
# webErrLog - Do logging to STDERR to file.
############################################################################
sub webErrLog {
	return unless $env->{err_log_file};
    my ($s) = @_;
    my $afh = newAppendFileHandle( $env->{err_log_file}, "webErrLog" );
    print $afh $s;
    close $afh;
}

############################################################################
# webLog - Do logging to file.
############################################################################
sub webLog {
	return if ( $env->{verbose} < 0 || ! $env->{web_log_file} );
	my ($s) = @_;
	if ( $env->{web_log_file} ) {
		my $afh = newAppendFileHandle( $env->{web_log_file}, "webLog" );
		print $afh $s;
		close $afh;
	}
}


#############################################################################
# lastPathTok - Last path token in file path, i.e, the file name.
#############################################################################
sub lastPathTok {
    my ($path) = @_;
    my @toks = split( /\//, $path );
    my $i;
    my @toks2;
    foreach $i (@toks) {
        next if $i eq "";
        push( @toks2, $i );
    }
    my $nToks = @toks2;
    return $toks2[ $nToks - 1 ];
}

############################################################################
# validFileName - Check for valid file name w/o full path.
############################################################################
sub validFileName {
    my ($fname) = @_;
    $fname =~ /([a-zA-Z0-9\._-]+)/;
    my $fname2 = $1;
    if ( $fname2 eq "" ) {
        die("validFileName: invalid file name '$fname'\n");
    }
    return $fname2;
}



1;
