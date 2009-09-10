use strict;
use Test::More tests => 1;
use lib qw(t/lib);
use MyApp;

our $RESULT;

{
    local *ARGV = [qw(logobjcan)];
    MyApp->dispatch;
}

ok($RESULT == 1, "log extend method method test");

