package MyApp::Can;

use strict;
use base qw(App::CLI::Command);

sub run {

    my($self, @args) = @_;
    $main::RESULT = ($self->can("log")) ? 1 : 0;
}

1;

