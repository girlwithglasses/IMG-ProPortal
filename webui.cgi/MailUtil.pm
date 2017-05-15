##########################################################################
# Send Mail
# $Id: MailUtil.pm 36954 2017-04-17 19:34:04Z klchu $
##########################################################################
package MailUtil;

use strict;
use CGI qw( :standard );
use Data::Dumper;
use Email::Valid;
use MIME::Lite;
use WebConfig;
use WebUtil;

# Force flush
$| = 1;

my $env         = getEnv();
my $base_url    = $env->{base_url};
my $base_dir    = $env->{base_dir};
my $cgi_url     = $env->{cgi_url};
my $cgi_dir     = $env->{cgi_dir};
my $img_version = $env->{img_version};
my $verbose     = $env->{verbose};

# unix sendmail program
my $sendmail = $env->{sendmail};
$sendmail = "/usr/sbin/sendmail" if ( $sendmail eq "" );

# rt-img\@cuba.jgi-psf.org
my $bugmasterEmail = $env->{img_support_email};

############################################################################
# validateEMail
############################################################################
sub validateEMail {
    my ($emailAddress) = @_;
    
    return (Email::Valid->address($emailAddress));
}

############################################################################
# getMyEmail
############################################################################
sub getMyEmail {
    my ( $dbh, $contact_oid ) = @_;

    my $myEmail;
    if ( $contact_oid > 0 ) {
        my $sql = qq{
           select email
           from contact
           where contact_oid = ?
        };
        my $cur = execSql( $dbh, $sql, $verbose, $contact_oid );
        $myEmail = $cur->fetchrow();
        $cur->finish();
    }

    return $myEmail;
}

############################################################################
# sendEMailTo
############################################################################
sub sendEMailTo {
    my ( $emailTo, $ccTo, $subject, $content, $filePath, $file ) = @_;

    if ( $filePath ne '' ) {
        sendMailAttachment( $emailTo, $ccTo, $subject, $content, $filePath, $file );
    } else {
        sendMail( $emailTo, $ccTo, $subject, $content );
    }
    webLog("Mail sent to $emailTo for $subject<br/>\n");
}

############################################################################
# sendMail
############################################################################
sub sendMail {
    my ( $emailTo, $ccTo, $subject, $content, $from) = @_;

    $emailTo = $bugmasterEmail if ($emailTo eq '');
    WebUtil::webDie "Invalid email address $emailTo!" if (! validateEMail($emailTo));
	
    my $send_from = "From: $bugmasterEmail\n";
    if($from ne '') {
        $send_from = "From: $from\n";
    }
    
    my $reply_to = "Reply-to: $bugmasterEmail\n";
    if($from ne '') {
        $reply_to = "Reply-to: $from\n";
    }

    my $send_to = "To: $emailTo\n";
    my $cc_to = '';
    $cc_to = "cc: $ccTo\n" if ($ccTo ne '' && validateEMail($ccTo));
    my $subject = "Subject: $subject\n";

    WebUtil::unsetEnvPath();
	open(SENDMAIL, "|$sendmail -t") or WebUtil::webDie "Cannot open $sendmail: $!";
    print SENDMAIL $send_from;
    print SENDMAIL $reply_to; 
    print SENDMAIL $send_to; 
    print SENDMAIL $cc_to if ($cc_to ne '');
	print SENDMAIL $subject;
	print SENDMAIL "Content-type: text/plain\n\n";
	print SENDMAIL $content;
	close(SENDMAIL);

}

############################################################################
# sendMailAttachment
############################################################################
sub sendMailAttachment {
    my ( $emailTo, $ccTo, $subject, $content, $outFilePath, $outFile) = @_;

    $emailTo = $bugmasterEmail if ($emailTo eq '');
    WebUtil::webDie "Invalid email address $emailTo!" if (! validateEMail($emailTo));
    WebUtil::webDie "$outFilePath does not exist!" if (! (-e $outFilePath));
    
	# create a new message
	my $msg = MIME::Lite->new(
	   From => $bugmasterEmail,
	   To => $emailTo,
	   Cc => $ccTo,
	   Subject => $subject,
	   Data => $content
	);

	# add the attachment
	$msg->attach(
	    Type => "text/plain",
	    Path => $outFilePath,
	    Filename => $outFile,
	    Disposition => "attachment"
	);

    WebUtil::unsetEnvPath();
    # send the email
	$msg->send();
}

############################################################################
# processSubmittedMessage
############################################################################
sub processSubmittedMessage {
    my ($content) = @_;

    printProcessSubmittedMessage($content);

    my $tmp = printWindowStop();
    require WebPrint;
    WebPrint::printMainFooter( "", $tmp );

    # I need to disconnect parent thread before child use db connection because it cannot be shared between
    # connections - ken
    WebUtil::dbLogoutImg();
    WebUtil::dbLogoutGold();

}

############################################################################
# printProcessSubmittedMessage
############################################################################
sub printProcessSubmittedMessage {
    my ($content) = @_;

    my $fromEmail = $env->{img_support_email};
    my $text = qq{
        Your request to process $content has been successfully submitted.
        You will be notified via email from <b>$fromEmail</b> with a URL to the result.<br/>
        The URL will be valid for <b>only 24 hours</b>.
    };
    WebUtil::printMessage($text);

}

############################################################################
# printWindowStop
############################################################################
sub printWindowStop {
    my $str = qq{
        <script language="javascript" type="text/javascript">
            window.stop();
        </script>
    };
    return $str;
}

############################################################################
# getDoNotReplyMailContent
############################################################################
sub getDoNotReplyMailContent {
    my ($url, $tmp, $moreMag) = @_;

    my $content = qq{
        This is an automatically generated email. DO NOT reply.
        Use links below to download or view your results. (The URL will be valid for <b>only 24 hours</b>)
        $moreMag

        Files:
        $url
        $tmp

        It is best to have the IMG web page open first.
        $base_url
        before downloading or viewing files.
    };

    return $content;

}

1;
