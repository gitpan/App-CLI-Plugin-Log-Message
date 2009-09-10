package App::CLI::Plugin::Log::Message;

=pod

=head1 NAME

App::CLI::Plugin::Log::Message - for App::CLI::Extension logging module

=head1 VERSION

0.1

=head1 SYNOPSIS

  # MyApp.pm
  package MyApp;
  
  use strict;
  use base qw(App::CLI::Extension);
  
  # extension method
  __PACKAGE__->load_plugins(qw(Log::Message));

  __PACKAGE__->config(log_message => { private => 1, level => "log", tag => "myapp" });
  
  1;
  
  # MyApp/Hello.pm
  package MyApp::Hello;
  use strict;
  feature "5.10.0";
  use base qw(App::CLI::Command);
  
  sub run {

      my($self, @args) = @_;
      $self->log->store("myapp execute start");
      $self->log->store("myapp execute end");
      foreach my $stack($self->log->retrieve) {
          say sprintf("%s ID[%05i]: %s", $stack->when, $stack->id, $stack->message);
      }
  }
  
  # myapp
  #!/usr/bin/perl
  
  use strict;
  use MyApp;
  
  MyApp->dispatch;
  
  # execute
  [kurt@localhost ~] ./myapp hello
  Sun Sep  6 20:43:39 2009 ID[00000]: myapp execute start
  Sun Sep  6 20:43:39 2009 ID[00001]: myapp execute end

=head1 DESCRIPTION

App::CLI::Extension Log::Message plugin module

log method setting

  __PACKAGE__->config( log_message => {%log_message_option} );

=cut

use strict;
use 5.008;
use Log::Message;

our $PACKAGE = __PACKAGE__;
our $VERSION = '0.1';

=pod

=head1 EXTENDED METHOD

=head2 Log::Message::stringfy_stack

Log::Message stack object to converts a string

Example:
  
  # MyApp::Hello(App::CLI::Command base package)
  sub run {

      my($self, @args) = @_;
      $self->log->store("myapp execute start");
      $self->log->store("myapp execute end");
      say $self->log->stringfy_stack;
      # for option(same Log::Message#retrieve option)
      #say $self->log->stringfy_stack(level => "log", tag => qr/myapp/);
  }

  # execute
  [kurt@localhost ~] ./myapp hello
  Sun Sep  6 20:57:10 2009 ID:00000000 myapp[2027]: myapp execute start(at /usr/local/lib/perl5/5.10.0/Log/Message.pm line 410
          Log::Message::store('Log::Message=HASH(0x96855f0)', 'myapp execute start') called at /home/kurt/lib/MyApp/Log.pm line 13
          MyApp::Log::run('MyApp::Log=HASH(0x9607790)') called at /usr/local/lib/perl5/site_perl/5.10.0/App/CLI/Command.pm line 53
          App::CLI::Command::run_command('MyApp::Log=HASH(0x9607790)') called at /usr/local/lib/perl5/site_perl/5.10.0/App/CLI.pm line 79
          App::CLI::dispatch('MyApp') called at ./myapp.pl line 8)
  Sun Sep  6 20:57:10 2009 ID:00000001 myapp[2027]: myapp execute end(at /usr/local/lib/perl5/5.10.0/Log/Message.pm line 410
          Log::Message::store('Log::Message=HASH(0x96855f0)', 'myapp execute end') called at /home/kurt/lib/MyApp/Log.pm line 14
          MyApp::Log::run('MyApp::Log=HASH(0x9607790)') called at /usr/local/lib/perl5/site_perl/5.10.0/App/CLI/Command.pm line 53
          App::CLI::Command::run_command('MyApp::Log=HASH(0x9607790)') called at /usr/local/lib/perl5/site_perl/5.10.0/App/CLI.pm line 79
          App::CLI::dispatch('MyApp') called at ./myapp.pl line 8)

=cut
*Log::Message::stringfy_stack   = \&_stringfy_stack;

=head2 Log::Message::Handlers::stderr

Log::Message::Handlers custom message handler

Example:

  # MyApp::Hello(App::CLI::Command base package)
  sub run {

      my($self, @args) = @_;
      $self->log->store(level => "stderr", message => "myapp execute start");
      $self->log->store(level => "stderr", message => "myapp execute end");
  }

=cut
*Log::Message::Handlers::stderr = \&_stderr;

=pod

=head1 METHOD

=head2 log

return Log::Message object

=cut
sub log {

    my $self = shift;

    if (!exists $self->{$PACKAGE}) {
        my %log_option = (exists $self->config->{log_message}) ? %{$self->config->{log_message}} : ();
        $self->{$PACKAGE} = Log::Message->new(%log_option);
    }
    return $self->{$PACKAGE};
}

{
    sub _stderr {
        print STDERR shift->message . "\n";
    }

    sub _stringfy_stack {
        my $self  = shift;
        my @list  = $self->retrieve(@_);
        my @lines = map {
                        sprintf "%s ID:%08i %s[%i]: %s(%s)", $_->when, $_->id, $_->tag, $$, $_->message, $_->longmess;
                    } @list;
        return join "\n", @lines;
    }
}

1;

__END__

=head1 SEE ALSO

L<App::CLI::Extension> L<Log::Message>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Copyright (C) 2009 Akira Horimoto

=cut

