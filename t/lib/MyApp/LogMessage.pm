package MyApp::LogMessage;

use strict;
use base qw(App::CLI::Command);

sub run {

    my($self, @args) = @_;
    $self->log->store("log test message");
    $self->log->store(level => "stderr", message => "stderr test message");
    $self->log->store(level => "warn"  , message => "warn test message");
    $self->log->store(level => "carp"  , message => "carp test message");
    $self->log->store(level => "trace"  , message => "trace test message");
    $self->log->store(level => "cluck"  , message => "cluck test message");
    foreach my $item($self->log->retrieve(tag => qr/^LOGTEST$/)) {
        my $level   = $item->level;
        my $message = $item->message;
        $main::RESULT{$level} = $message;
    }
}

1;

