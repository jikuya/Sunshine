package Sunshine::PC::C::Signup;
use strict;
use warnings;
use utf8;
use Digest::SHA1  qw(sha1_base64);

sub begin {
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
            # TODO:エラー処理
            return;
        } else {
            my $hash  = time() . $nickname . $c->config->{CRYPT_SALT};
            my $token = sha1_base64($hash);
            eval {
                $c->dbh->do_i(q{INSERT INTO temp_reg }, {
                    token     => $token,
                    nickname  => $nickname,
                    email     => $email,
                    passwd    => crypt($passwd, $c->config->{CRYPT_SALT} ),
                });
                $id = $c->dbh->last_insert_id(undef, undef, undef, undef);
            };
            if( $@ ){
                print "catch!! $@\n";
            }

            if ($c->config->{ENV} eq 'deployment') {
                $c->send_mail(
                    $nickname,
                    $email,
                    '登録を完了してください',
                    '以下のURLから登録を完了させて下さい。\n'.
                    $c->config->{SITE_URL}.'/complete/'.$token ,
                );
                $c->redirect('/');
            } else {
                eval {
                    $c->dbh->do_i(q{INSERT INTO users }, {
                        nickname  => $nickname,
                        email     => $email,
                        passwd    => $passwd,
                    });
                    $id = $c->dbh->last_insert_id(undef, undef, undef, undef);
                };
                if( $@ ){
                    print "catch!! $@\n";
                }
                $c->session->set('id'       => $id);
                $c->session->set('nickname' => $nickname);
                $c->session->set('email'    => $email);
                $c->redirect('/');
            }
        }
    }
}

sub complete {
    my ($class, $c, $args) = @_;
    if ($c->req->{env}->{REQUEST_METHOD} eq 'POST') {
        my $id;
        if (my $user = $c->dbh->selectrow_arrayref(qq/SELECT * FROM temp_reg WHERE token = '$args->{token}'/)) {
            eval {
                $c->dbh->do_i(q{INSERT INTO users }, {
                    nickname  => $user->{nickname},
                    email     => $user->{email},
                    passwd    => $user->{passwd},
                });
                $id = $c->dbh->last_insert_id(undef, undef, undef, undef);
            };
            if( $@ ){
                print "catch!! $@\n";
            }
            $c->session->set('id'       => $id);
            $c->session->set('nickname' => $user->{nickname});
            $c->session->set('email'    => $user->{email});
            $c->redirect('/');
        } else {
            # TODO:エラー画面を出す
            return;
        }
    } else {
        # TODO:エラー画面を出す
        return;
    }
}
1;
