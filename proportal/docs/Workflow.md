# IMG / ProPortal #

## Application Workflow ##

The IMG ProPortal application combines the [Dancer2 engine](http://perldancer.org/) with an `IMG::App` object that holds IMG-specific functionality.


The basic flow of operations is:

#### HTTP request comes in ####

#### `before` hook (runs before any route handling) ####

* any existing controller is cleared from the `IMG::App` object
* preflight checks (see [`IMG::App::Role::PreFlight`](../../webui.cgi/IMG/App/Role/PreFlight.pm))
* if SSO is enabled:
  * check JGI session is valid (see [`IMG::App::Role::JGISessionClient`](../../webui.cgi/IMG/App/Role/JGISessionClient.pm))
  * load user data
  * set up session params

#### parse URL and query parameters ####

Handled by modules in [the `Routes::` directory](../lib/Routes/).

#### load appropriate module `$module` ####

For modules in the `ProPortal::Controller::` hierarchy, this involves populating the `controller` attribute on the `IMG::App`

#### run `$module->render` ####

Data is collected, wrangled into an appropriate structure, and then returned.

#### `before_template_render` ####

Extra data needed for the page, such as menu structures, filters, other miscellaneous details, are added to the output.

#### render template ####

Template is rendered and HTTP response is dispatched.

