package Sunshine::PC::C::Logout;
use strict;
use warnings;
use utf8;

sub index {
    my ($class, $c) = @_;
    $c->session->remove('id');
    $c->session->remove('nickname');
    $c->session->remove('email');
    $c->redirect('/');
}

1;
