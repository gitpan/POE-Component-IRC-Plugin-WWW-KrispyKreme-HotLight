requires 'perl',                              '5.008005';
requires 'Moose',                             '0';
requires 'POE::Component::IRC::Plugin',       '0';
requires 'POE::Component::IRC::Plugin::Role', '0';
requires 'WWW::KrispyKreme::Hotlight',        '0.01';

on test => sub {
    requires 'Test::More', '0.88';
};
