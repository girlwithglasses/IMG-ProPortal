# IMG / ProPortal Development #

## Application Structure ##

The ProPortal app is split into a number of parts. Core application functionality is in the [`webui.cgi/IMG::*`](../../webui.cgi/IMG/) modules, and ProPortal-specific code is (generally) in [`/proportal/lib/`](../lib/). Modules with general functionality will be shifted to the `IMG::` namespace.

The ProPortal modules consist of the following:

| Package name | Functionality |
|--------------|---------------|
| [`ProPortalPackage.pm`](../lib/ProPortalPackage.pm) | wrapper for all ProPortal modules. |
| [`DataModel::*`](../lib/DataModel/) | [`DBIx::DataModel`](http://metacpan.org/pod/DBIx::DataModel) models of the Gold and core databases |
| [`Routes::*`](../lib/Routes/) | Dancer-based routing modules that parse the URL and dispatch the appropriate request. |
| [`AppCore`](../lib/AppCore.pm) | Dancer-based functionality common to all routes, such as checks on incoming requests and template defaults. Caching capabilities are available but not yet implemented. |
| [`ProPortal::Controller::*`](../lib/ProPortal/Controller/) | controllers for specific ProPortal routes. Base.pm has the core controller functionality. Controllers and their functionality are independent of Dancer. |
| [`ProPortal::IO::*`](../lib/IO/) | Input/output-related modules. Currently just DBIxDataModel |
| [`ProPortal::Util::*`](../lib/ProPortal/Util/) | various utility modules, including adaptors for Dancer2 plugins that have now been abandoned. |


The IMG modules consist of the following:

| Package name | Functionality |
|--------------|---------------|
| [`IMG::App.pm`](../../webui.cgi/IMG/App.pm) | wrapper for the IMG core app functionality. Functionality is implemented using roles in the `IMG::App::*` namespace. An `IMG::App` instance can be created de novo, or automatically created by the ProPortal app. |

General App.pm functionality:

- Database connections: [`DBIx::Connector`](http://metacpan.org/pod/DBIx::Connector) connections to the databases.
- [`Dispatch`](../../webui.cgi/IMG/App/Role/Dispatch.pm): parameter parsing, selecting which module to load
- [`FileManager`](../../webui.cgi/IMG/App/Role/FileManager.pm) and [`IMG::Util::File`](../../webui.cgi/IMG/Util/File.pm): centralized file manager and useful file parsing shortcuts
- HTTP client: defaults to a new [`HTTP::Tiny`](http://metacpan.org/pod/HTTP::Tiny) instance
- [`JGISessionClient`](../../webui.cgi/IMG/App/Role/JGISessionClient.pm): interacts with Caliban to check the JGI session is valid
- [`PreFlight`](../../webui.cgi/IMG/App/Role/PreFlight.pm): runs preflight checks to ensure the environment is ready
- [`Schema`](../../webui.cgi/IMG/App/Role/Schema.pm): provides access to the Gold and core databases via `DBIx::DataModel`
- [`User`](../../webui.cgi/IMG/App/Role/User.pm): access to user data and user checks

TODO:
- logger
- cache


| Package name | Functionality |
|--------------|---------------|
| [`IMG::App::Role::LinkManager`](../../webui.cgi/IMG/App/Role/LinkManager.pm) | Link manager. In development. |
| [`IMG::App::Role::MenuManager`](../../webui.cgi/IMG/App/Role/MenuManager.pm) | Menu manager. In development. |
| [`IMG::App::Role::Templater`](../../webui.cgi/IMG/App/Role/Templater.pm) | renders a [Template::Toolkit](http://template-toolkit.org) template |
|||
| [`IMG::Util::Base`](../../webui.cgi/IMG/Util/Base.pm) | defines sets of modules to be loaded together; see [Import::Base](http://metacpan.org/pod/Import::Base) |
| [`IMG::Util::DB`](../../webui.cgi/IMG/.pm) | useful database-related functions, mostly DB config file-related. |
| [`IMG::Util::Untaint`](../../webui.cgi/IMG/Util/Untaint.pm) | untaint your paths! |
|||
| [`IMG::Views::ExternalLinks`](../../webui.cgi/IMG/Views/ExternalLinks.pm) | functional interface to external link data |
| [`IMG::Views::Links`](../../webui.cgi/IMG/Views/Links.pm) | functional interface to internal link data |

