package POE::Component::IRC::Plugin::WWW::KrispyKreme::HotLight;

use 5.008_005;
use Moose;
use WWW::KrispyKreme::Hotlight;
use IRC::Utils qw(parse_user);

our $VERSION = '0.01';

use POE::Component::IRC::Plugin qw( :ALL );
with 'POE::Component::IRC::Plugin::Role';

has geo => (is => 'rw', isa => 'ArrayRef[Num]');

our @channels;

sub new {
    my ($class, %args) = @_;
    my $self = bless \%args, $class;

    $self->{ping} = 0;
    return $self;
}

# trigger a donut search when:
# -we join a channel
# -we are pinged by the server (every 20 times)
sub S_join {
    my ($self, $irc) = splice @_, 0, 2;
    my $joiner  = parse_user(${$_[0]});
    my $nick    = $irc->{nick};
    my $channel = ${$_[1]};
    push @channels, $channel;
    return $joiner eq $nick ? $self->_donuts($channel) : PCI_EAT_NONE;
}

sub S_ping {
    my $self = shift;
    $self->{ping}++;

    # ping interval on freenode is ~2 mins
    my $ready = $self->{ping} % 20 == 0;

    return PCI_EAT_NONE unless @channels and $ready;
    return $self->_donuts($_) for @channels;
}

sub _donuts {
    my ($self, $channel) = @_;

    my $donuts = WWW::KrispyKreme::Hotlight->new(where => $self->geo)->locations;
    my $stores = join ', ', map $_->{title}, grep $_->{hotLightOn}, @$donuts;
    $self->irc->yield(    #
        privmsg => $channel =>
          "Fresh donuts available at the following Kripsy Kreme locations: $stores"
    ) if $stores;
    return PCI_EAT_PLUGIN;
}

1;
__END__

=encoding utf-8

=head1 NAME

POE::Component::IRC::Plugin::WWW::KrispyKreme::HotLight - IRC Plugin
to announce when there are fresh donuts in the area!

=head1 SYNOPSIS

  use POE::Component::IRC::Plugin::WWW::KrispyKreme::HotLight;

=head1 DESCRIPTION

POE::Component::IRC::Plugin::WWW::KrispyKreme::HotLight is an IRC
plugin that announces when there are fresh Krispy Kreme donuts near
the given location

=head1 AUTHOR

Curtis Brandt E<lt>curtis@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Curtis Brandt

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
