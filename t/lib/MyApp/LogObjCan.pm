package MyApp::LogObjCan;

use strict;
use base qw(App::CLI::Command);

sub run {

    my($self, @args) = @_;
    $main::RESULT = ($self->log->can("stringfy_stack")) ? 1 : 0;
}

1;

