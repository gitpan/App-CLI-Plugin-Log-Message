package App::CLI::Plugin::Log::Message;

=pod

=head1 NAME

App::CLI::Plugin::Log::Message - for App::CLI::Extension logging module

=head1 VERSION

1.2

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
  use feature ":5.10.0";
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
use base qw(Class::Data::Accessor);
use Log::Message;

__PACKAGE__->mk_classaccessor("log");
our $VERSION = '1.2';

=pod

=head1 EXTENDED METHOD

=head2 Log::Message::stringfy_stack

Log::Message stack object to converts a string

Example:
  
  # MyApp::Hello(App::CLI::Command base package)
  sub run {

      my($self, @args) = @_;
      $self->log->store("myapp execute start");
      $self->log->store(level => "warn", message => "warning message");
      $self->log->store(level => "cluck", message => "cluck message");
      $self->log->store("myapp execute end");
      say $self->log->stringfy_stack;
      # for option(same Log::Message#retrieve option)
      #say $self->log->stringfy_stack(level => "log");
  }
  
  # execute
  [kurt@localhost ~] ./myapp hello 2>/dev/null
  Sat Sep 19 00:20:02 2009 log      ID:00000000 NONE[3963]: myapp execute start
  Sat Sep 19 00:20:02 2009 log      ID:00000003 NONE[3963]: myapp execute end
 
  # stringfy_stack verbose option
  sub options {
      return (
         "verbose|v"   => "verbose",
      );
  }
  
  sub run {

      my($self, @args) = @_;
      $self->log->store("myapp execute start");
      $self->log->store(level => "warn", message => "warning message");
      $self->log->store(level => "cluck", message => "cluck message");
      $self->log->store("myapp execute end");
      say $self->log->stringfy_stack(level => "log", verbose => $self->{verbose});
  }
  
  # verbose execute
  [kurt@localhost ~] ./myapp hello --verbose 2>/dev/null
   Sat Sep 19 00:23:07 2009 log      ID:00000000 NONE[3968]: at /usr/local/lib/perl5/5.10.0/Log/Message.pm line 410
           Log::Message::store('Log::Message=HASH(0x9b468f0)', 'myapp execute start') called at /home/holly/lib/MyApp/Log.pm line 19
           MyApp::Log::run('MyApp::Log=HASH(0x9bb2498)') called at /home/kurt/App/CLI/Plugin/InstallCallback.pm line 183
           App::CLI::Plugin::InstallCallback::_run_command('MyApp::Log=HASH(0x9bb2498)') called at /usr/local/lib/perl5/site_perl/5.10.0/App/CLI.pm line 79
           App::CLI::dispatch('MyApp') called at ./myapp.pl line 8
   Sat Sep 19 00:23:07 2009 log      ID:00000003 NONE[3968]: at /usr/local/lib/perl5/5.10.0/Log/Message.pm line 410
           Log::Message::store('Log::Message=HASH(0x9b468f0)', 'myapp execute end') called at /home/holly/lib/MyApp/Log.pm line 22
           MyApp::Log::run('MyApp::Log=HASH(0x9bb2498)') called at /home/kurt/App/CLI/Plugin/InstallCallback.pm line 183
           App::CLI::Plugin::InstallCallback::_run_command('MyApp::Log=HASH(0x9bb2498)') called at /usr/local/lib/perl5/site_perl/5.10.0/App/CLI.pm line 79
           App::CLI::dispatch('MyApp') called at ./myapp.pl line 8

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

sub setup {

	my($self, @argv) = @_;
	my %log_option = (exists $self->config->{log_message}) ? %{$self->config->{log_message}} : ();
	$self->log(Log::Message->new(%log_option));
	$self->maybe::next::method(@argv);
}


####################################
# Log::Message extended method
####################################
sub _stderr {
	warn shift->message . "\n";
}

sub _stringfy_stack {

	my($self, %option) = @_;
	my @lines = map {
			my $message = (exists $option{verbose} && $option{verbose} == 1) ? $_->longmess : $_->message;
			sprintf("%s %-8s ID:%08i %s[%i]: %s", $_->when, $_->level, $_->id, $_->tag, $$, $message)
	} $self->retrieve(%option);
	return join "\n", @lines;
}

1;

__END__

=head1 SEE ALSO

L<App::CLI::Extension> L<Class::Data::Accessor> L<Log::Message>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Copyright (C) 2010 Akira Horimoto

=cut

