# IMG / ProPortal Development #

## Application Structure ##

The ProPortal app is split into a number of parts. Core application functionality is in the `webui.cgi/IMG::*` modules, and ProPortal-specific code is (generally) in `/proportal/lib/`. Modules with general functionality will be shifted to the `IMG::` namespace.

The ProPortal modules consist of the following:

| Package name | Functionality |
|--------------|---------------|
| `ProPortalPackage.pm` | wrapper for all ProPortal modules. |
| `DataModel::*`        | `DBIx::DataModel` models of the Gold and core databases |
| `Routes::*`           | Dancer-based routing modules that parse the URL and dispatch the appropriate request. |
| `AppCore`             | Dancer-based functionality common to all routes, such as checks on incoming requests and template defaults. Caching capabilities are available but not yet implemented. |
| `ProPortal::Controller::*` | controllers for specific ProPortal routes. Base.pm has the core controller functionality. Controllers and their functionality are independent of Dancer. |
| `ProPortal::IO::*` | Input/output-related modules. Currently just DBIxDataModel |
| `ProPortal::Util::*` | various utility modules, including adaptors for Dancer2 plugins that have now been abandoned. |


The IMG modules consist of the following:

| Package name | Functionality |
|--------------|---------------|
| `IMG::App.pm`         | wrapper for the IMG core app functionality. Functionality is implemented using roles in the `IMG::App::*` namespace. An `IMG::App` instance can be created de novo, or automatically created by the ProPortal app. |

General App.pm functionality:

- Database connections: `DBIx::Connector` connections to the databases.
- `Dispatch`: parameter parsing, selecting which module to load
- `FileManager` and `IMG::Util::File`: centralized file manager and useful file parsing shortcuts
- HTTP client: defaults to a new `HTTP::Tiny` instance
- `JGISessionClient`: interacts with Caliban to check the JGI session is valid
- `PreFlight`: runs preflight checks to ensure the environment is ready
- `Schema`:    provides access to the Gold and core databases via `DBIx::DataModel`
- `User`:      access to user data and user checks

TODO:
- logger
- cache


| Package name | Functionality |
|--------------|---------------|
| IMG::App::Role::LinkManager | Link manager. In development. |
| IMG::App::Role::MenuManager | Menu manager. In development. |
| IMG::App::Role::Templater | renders a Template::Toolkit template |
|||
| IMG::Util::Base | defines sets of modules to be loaded together; see Import::Base |
| IMG::Util::DB | useful database-related functions, mostly DB config file-related. |
| IMG::Util::Untaint | untaint your paths! |
|||
| IMG::Views::ExternalLinks | functional interface to external link data |
| IMG::Views::Links | functional interface to internal link data |

