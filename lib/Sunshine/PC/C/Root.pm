package Sunshine::PC::C::Root;
use strict;
use warnings;
use utf8;

sub index {
    my ($class, $c) = @_;

    #   TODO:MODELに切り出す
    my $category_mst = $c->dbh->selectall_arrayref(
        qq/SELECT * FROM category_mst/,
        {Slice => {}}
    );

    $c->render(
        'index.tt',
        {
            login_name   => $c->login_name,
            common       => $c->common,
            category_mst => $category_mst,
        }
    );
}

1;
