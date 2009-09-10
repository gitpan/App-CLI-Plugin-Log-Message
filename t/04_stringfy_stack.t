use strict;
use Test::More tests => 1;
use lib qw(t/lib);
use MyApp;

our $RESULT;

{
    local *ARGV = [qw(stringfystack)];
    MyApp->dispatch;
}

isnt($RESULT, undef);
