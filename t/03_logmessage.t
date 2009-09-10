use strict;
use Test::More tests => 2;
use lib qw(t/lib);
use MyApp;

our $RESULTNUM;
our %RESULT;

my %check_result = (
    log    => "log test message",
    stderr => "stderr test message",
    warn   => "warn test message",
    carp   => "carp test message",
    trace   => "trace test message",
    cluck   => "cluck test message",
);

{
    local *ARGV = [qw(logmessage)];
    MyApp->dispatch;
}

ok(keys(%RESULT) == 6);
is_deeply(\%RESULT, \%check_result);
