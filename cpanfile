requires 'perl',                              '5.008005';
requires 'Moose',                             '0';
requires 'POE::Component::IRC::Plugin',       '0';
requires 'POE::Component::IRC::Plugin::Role', '0';
requires 'WWW::KrispyKreme::HotLight',        '0.02';

on test => sub {
    requires 'Test::More', '0.88';
};
