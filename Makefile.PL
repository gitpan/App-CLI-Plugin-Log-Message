use inc::Module::Install;
name 'App-CLI-Plugin-Log-Message';
author 'Akira Horimoto';
all_from 'lib/App/CLI/Plugin/Log/Message.pm';

build_requires 'Test::More';
requires(
      "App::CLI::Extension"   => 1.2,
      "Class::Data::Accessor" => 0,
      "Log::Message"          => 0,
    );
use_test_base;
auto_include;
author_tests('xt');
sign;
WriteAll;
