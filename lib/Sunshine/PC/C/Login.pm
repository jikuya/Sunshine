package Sunshine::PC::C::Login;
use strict;
use warnings;
use utf8;
use Digest::MD5 qw/md5_hex/;

sub index {
    my ($class, $c) = @_;
    my $email  = $c->req->param('email');
    my $passwd = $c->req->param('passwd');
    $passwd = crypt($passwd, $c->config->{CRYPT_SALT});
    if (my $user = $c->dbh->selectrow_hashref(qq/SELECT * FROM users WHERE email = '$email' AND passwd = '$passwd'/)) {
        $c->session->set('id' => $user->{id});
        $c->session->set('nickname' => $user->{nickname});
        $c->session->set('email' => $user->{email});
    } else {
    }
    my $referrer = $c->req->{env}->{HTTP_REFERER};
    unless ($referrer =~ s/$c->config->{SITE_URL}//) {
        $referrer = '/';
    }
    $c->redirect($referrer); 
}

1;
