package Sunshine::PC::C::Signup;
use strict;
use warnings;
use utf8;

sub index {
    my ($class, $c) = @_;
    if ($c->req->{env}->{REQUEST_METHOD} eq 'GET') {
        $c->render(
            'signup.tt',
            {
                login_name => $c->login_name,
            }
        );
    } elsif ($c->req->{env}->{REQUEST_METHOD} eq 'POST') {
        my $id;
        my $nickname = $c->req->param('nickname');
        my $email    = $c->req->param('email');
        my $passwd   = $c->req->param('passwd');
        if ($c->dbh->selectrow_arrayref(qq/SELECT id FROM users WHERE email = '$email'/)) {
            # TODO:エラーメッセージを返す
            return;
        } else {
            eval {
                $c->dbh->do_i(q{INSERT INTO users }, {
                    nickname  => $nickname,
                    email     => $email,
                    passwd    => crypt($passwd, $c->config->{CRYPT_SALT} ),
                });
                $id = $c->dbh->last_insert_id(undef, undef, undef, undef);
            };
            if( $@ ){
                print "catch!! $@\n";
            }
            $c->session->set('id' => $id);
            $c->session->set('nickname' => $nickname);
            $c->session->set('email' => $email);
            $c->redirect('/');
        }
    }
}

1;
