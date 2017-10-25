requires 'AnyEvent';
requires 'AnyEvent::Handle';
requires 'AnyEvent::Socket';
requires 'JSON';
requires 'Log::Log4perl';
requires 'Try::Tiny';
requires 'Getopt::Long';
requires 'Carp';
requires 'Plack';
requires 'Twiggy';

on test => sub {
    requires 'Test::More';
    requires 'Test::Deep';
};