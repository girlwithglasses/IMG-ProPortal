# IMG / ProPortal Development #

## Application Structure ##

The ProPortal app is split into a number of parts. Core application functionality is in the [`webui.cgi/IMG::*`](../../webui.cgi/IMG/) modules, and ProPortal-specific code is (generally) in [`/proportal/lib/`](../lib/). Modules with general functionality will be shifted to the `IMG::` namespace.

The ProPortal modules consist of the following:

| Package name | Functionality |
|--------------|---------------|
| [`ProPortalPackage.pm`](../lib/ProPortalPackage.pm) | wrapper for all ProPortal modules. |
| [`DataModel::*`](../lib/DataModel/) | [`DBIx::DataModel`](http://metacpan.org/pod/DBIx::DataModel) models of the Gold and core databases |
| [`Routes::*`](../lib/Routes/) | Dancer-based routing modules that parse the URL and dispatch the appropriate request. |
| [`AppCore`](../lib/AppCore.pm) and [`AppCorePlugin`](../lib/AppCorePlugin.pm) | Dancer-based functionality common to all routes, such as checks on incoming requests and template defaults. Caching capabilities are available but not yet implemented. |
| [`ProPortal::Controller::*`](../lib/ProPortal/Controller/) | controllers for specific ProPortal routes. Base.pm has the core controller functionality. Controllers and their functionality are independent of Dancer. |
| [`ProPortal::IO::*`](../lib/IO/) | Input/output-related modules. |
| [`ProPortal::IO::DBIxDataModel`](../lib/ProPortal/IO/DBIxDataModel.pm) | Common queries and database interactions |
| [`ProPortal::IO::ProPortalFilters`](../lib/ProPortal/IO/ProPortalFilters.pm) | Common filters used for ProPortal queries |
| [`ProPortal::Util::*`](../lib/ProPortal/Util/) | various utility modules |
| [`ProPortal::Util::DataStructure`](../lib/ProPortal/Util/DataStructure) | common data structure wrangling |
| [`ProPortal::Views::ProPortalMenu`](../lib/ProPortal/Views/ProPortalMenu.pm) | the menu structure for the ProPortal |

The IMG modules consist of the following:

| Package name | Functionality |
|--------------|---------------|
| [`IMG::App.pm`](../../webui.cgi/IMG/App.pm) | wrapper for the IMG core app functionality. Functionality is implemented using roles in the `IMG::App::*` namespace. An `IMG::App` instance can be created de novo, or automatically created by the ProPortal app. |
| [`IMG::Util::ConfigValidator`](../../webui.cgi/IMG/Util/ConfigValidator.pm) | handles loading of config files, separating out elements into Dancer2 and `IMG::App` config. Validation to be added. |
| [`IMG::App::Role::Dispatch`](../../webui.cgi/IMG/App/Role/Dispatch.pm) and [`IMG::App::DispatchCore`](../../webui.cgi/IMG/App/DispatchCore.pm) | parameter parsing, selecting which module to load. Needs some updating. |
| [`IMG::App::Role::ErrorMessages`](../../webui.cgi/IMG/App/Role/ErrorMessages.pm) | standardised error messages! |
| [`IMG::App::Role::HttpClient`](../../webui.cgi/IMG/App/Role/HttpClient.pm) | access to an HTTP client via `$img_app->http_ua`; defaults to a new [`HTTP::Tiny`](http://metacpan.org/pod/HTTP::Tiny) instance |
| [`IMG::App::Role::MenuManager`](../../webui.cgi/IMG/App/Role/MenuManager.pm) | Menu manager, for generating data structures that can be interpreted to produce page menus. |
| [`IMG::App::Role::PreFlight`](../../webui.cgi/IMG/App/Role/PreFlight.pm) | runs preflight checks to ensure the environment is ready |
 [`IMG::App::Role::Templater`](../../webui.cgi/IMG/App/Role/Templater.pm) | renders a [Template::Toolkit](http://template-toolkit.org) template |


#### File Handling ####

| Package name | Functionality |
|--------------|---------------|
| [`IMG::App::Role::FileManager`](../../webui.cgi/IMG/App/Role/FileManager.pm) | centralised file manager; to be expanded |
| [`IMG::Util::File`](../../webui.cgi/IMG/Util/File.pm) | useful file parsing shortcuts |
| [`IMG::Util::FileAppender`](../../webui.cgi/IMG/Util/FileAppender.pm) | role for editing TSV data files, e.g. adding or moving columns |
| [`IMG::Util::Parser::TSV2GFF`](../../webui.cgi/IMG/Util/Parser/TSV2GFF.pm) | parse the IMG tab-delimited files and convert them into GFFs |
| [`IMG::Util::Untaint`](../../webui.cgi/IMG/Util/Untaint.pm) | untaint your paths! |


#### Links ####

| Package name | Functionality |
|--------------|---------------|
| [`IMG::App::Role::LinkManager`](../../webui.cgi/IMG/App/Role/LinkManager.pm) | Link manager; provides the link to a page, given the page ID and relevant variables |
| [`IMG::Views::ExternalLinks`](../../webui.cgi/IMG/Views/ExternalLinks.pm) | functional interface to external link data |
| [`IMG::Views::Links`](../../webui.cgi/IMG/Views/Links.pm) | functional interface to internal link data |


#### Database ####

| Package name | Functionality |
|--------------|---------------|
| [`IMG::Util::DB`](../../webui.cgi/IMG/.pm) | useful database-related functions, mostly DB config file-related. To be refactored. |
| [`IMG::Util::DBIxConnector`](../../webui.cgi/IMG/Util/DBIxConnector.pm) | DBH creation utilities |
| [`IMG::App::Role::DbConnection`](../webui.cgi/IMG/App/Role/DbConnection.pm) | access to [`DBIx::Connector`](http://metacpan.org/pod/DBIx::Connector) connections to the databases. |
| [`IMG::App::Role::Schema`](../../webui.cgi/IMG/App/Role/Schema.pm) | provides access to the Gold and core databases via `DBIx::DataModel` through `$img_app->schema('img_core')` and `$img_app->schema('img_gold')` |

#### Sessions and Users ####

| Package name | Functionality |
|--------------|---------------|
| [`IMG::App::Role::JGISessionClient`](../../webui.cgi/IMG/App/Role/JGISessionClient.pm) | interacts with Caliban to check the JGI session is valid |
| [`IMG::App::Role::Session`](../../webui.cgi/IMG/App/Role/Session.pm) | session-related functionality. May need updating? |
|
| [`IMG::App::Role::User`](../../webui.cgi/IMG/App/Role/User.pm) and [`IMG::App::Role::UserChecks`](../../webui.cgi/IMG/App/Role/UserChecks.pm) | access to user data and user checks |
| [`IMG::App::Cart`](../../webui.cgi/IMG/App/Cart.pm) | First attempts at a cart interface |


#### Other bits and pieces ####

| Package name | Functionality |
|--------------|---------------|
| [`IMG::Model::DataManager`](../../webui.cgi/IMG/Model/DataManager.pm) | units for various measurements |
| [`IMG::Model::UnitConverter`](../../webui.cgi/IMG/Model/UnitConverter.pm) | interconversion between units |
| [`IMG::Util::Factory`](../../webui.cgi/IMG/Util/Factory.pm) | object creation |
| [`IMG::Util::Import`](../../webui.cgi/IMG/Util/Import.pm) | defines sets of modules to be loaded together; see [Import::Base](http://metacpan.org/pod/Import::Base) |
| [`IMG::Util::Text`](../../webui.cgi/IMG/Util/Text.pm) | collection point for text-related functionality |
| [`IMG::Util::Timed`](../../webui.cgi/IMG/Util/Timed.pm) | simple interface for timing a function |
| [`IMG::Util::Logger`](../../webui.cgi/IMG/Util/Logger.pm) | TODO: integrate logger with Dancer2 logging! |


[`IMG::Views::ViewMaker`](../../webui.cgi/IMG/Views/ViewMaker.pm) is/was a first attempt at extracting all the output-related functionality from [`main.pl`](../../webui.cgi/main.pl), [`WebUtil`](../../webui.cgi/WebUtil.pm), etc.


#### TODO ####

- logger (partially implemented)
- cache

