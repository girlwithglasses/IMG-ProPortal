package ProPortal::CoreAppAdapter;
use Dancer2::Plugin::AppRole::Helper;
use Dancer2::Plugin;

=pod

=encoding UTF-8

=head1 NAME

ProPortal::CoreAppAdapter

=head1 VERSION

version 0.1.0

=head1 SYNOPSIS


=head1 DESCRIPTION

Adds the functionality of the IMG core app to the ProPortal Dancer app via plugin keywords

=cut

=cut
	# roles used by the core app
	'IMG::App::Role::HttpClient',       # http_ua
	'IMG::App::Role::Session',          # session
	'IMG::App::Role::PreFlight',        # remote_addr, user_agent (both to be deprecated)
	'IMG::App::Role::DbConnection',     # db_connection_h
	'IMG::App::Role::JGISessionClient',
#	'IMG::App::Cache',                  # to write!
#	'IMG::App::Logger',                 # to write!
	'IMG::App::Role::User',             # user
	'IMG::App::Role::UserChecks',
	'IMG::App::Role::FileManager',
	'IMG::App::Role::LinkManager',
	'IMG::App::Role::MenuManager',
	'IMG::App::Role::Schema';           # schema_h

=cut


my @roles = qw( HttpClient PreFlight DbConnection JGISessionClient LinkManager MenuManager Schema FileManager User UserChecks );

# for my $r ( @roles ) {
#     on_plugin_import { ensure_approle 'IMG::App::Role::' . $r => @_ };
# }

on_plugin_import { ensure_approle 'ProPortal::Views::ProPortalMenu' => @_ };

register_plugin;

1;
