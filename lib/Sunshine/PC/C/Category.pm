package Sunshine::PC::C::Category;
use strict;
use warnings;
use utf8;

sub index {
    my ($class, $c, $args) = @_;

    #   TODO:MODELに切り出す
    my $publishes = $c->dbh->selectall_arrayref(
        qq/SELECT publishes.*, users.nickname FROM publishes,users WHERE category_id = $args->{id} AND publishes.author = users.id/,
        {Slice => {}}
    );

    $c->render(
        'category.tt',
        {
            login_name => $c->login_name,
            publishes  => $publishes,
        }
    );
}

1;
