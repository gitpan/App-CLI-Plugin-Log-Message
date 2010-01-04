package MyApp;

use strict;
use base qw(App::CLI::Extension);
use constant alias => (
                 logobjcan     => "LogObjCan",
                 logmessage    => "LogMessage",
                 stringfystack => "StringfyStack",
             );

$ENV{APPCLI_NON_EXIT} = 1;
__PACKAGE__->config(log_message => {tag => "LOGTEST"});
__PACKAGE__->load_plugins(qw(
               Log::Message
            ));

1;
