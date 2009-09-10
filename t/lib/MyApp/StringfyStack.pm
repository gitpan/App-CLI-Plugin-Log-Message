package MyApp::StringfyStack;

use strict;
use base qw(App::CLI::Command);

sub run {

    my($self, @args) = @_;
    $self->log->store("log test message");
    $main::RESULT = $self->log->stringfy_stack;
}

1;

