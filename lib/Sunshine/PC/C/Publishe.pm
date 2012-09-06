package Sunshine::PC::C::Publishe;
use strict;
use warnings;
use utf8;

sub view {
    my ($class, $c, $args) = @_;

    my $id = $args->{id};
    my $publishe = $c->dbh->selectrow_hashref(
        qq/SELECT publishes.*, users.nickname FROM publishes,users WHERE publishes.id = $id AND publishes.author = users.id/,
        {Slice => {}}
    );

    # カテゴリマスタ取得
    # TODO:Modelに切り出す 
    my $category_mst = $c->dbh->selectall_arrayref(
        qq/SELECT * FROM category_mst/,
        {Slice => {}}
    );
    my %category_mst;
    foreach my $category (@$category_mst) {
        $category_mst{$category->{id}} = $category->{name};
    }

    # コンテンツタイプ取得
    # TODO:Modelに切り出す 
    my $contents_type = $c->dbh->selectall_arrayref(
        qq/SELECT * FROM contents_type/,
        {Slice => {}}
    );
    my %contents_type;
    foreach my $type (@$contents_type) {
        $contents_type{$type->{id}} = $type->{name};
    }

    # コンテンツタイプ取得
    $publishe->{category_mst}  = $category_mst{$publishe->{category_id}};
    $publishe->{contents_type} = $contents_type{$publishe->{type}};

    $c->render(
        'publishe/view.tt',
        {
            login_name    => $c->login_name,
            publishe      => $publishe,
        }
    );
}

sub create {
    my ($class, $c) = @_;
    if ($c->req->{env}->{REQUEST_METHOD} eq 'GET') {
        # カテゴリマスタ取得
        #   TODO:MODELに切り出す
        my $category_mst = $c->dbh->selectall_arrayref(
            qq/SELECT * FROM category_mst/,
            {Slice => {}}
        );
        # コンテンツタイプ取得
        # TODO:Modelに切り出す 
        my $contents_type = $c->dbh->selectall_arrayref(
            qq/SELECT * FROM contents_type/,
            {Slice => {}}
        );
        my %contents_type;
        foreach my $type (@$contents_type) {
            $contents_type{$type->{id}} = $type->{name};
        }

        $c->render(
            'publishe/create.tt',
            {
                login_name    => $c->login_name,
                category_mst  => $category_mst,
                contents_type => $contents_type,
            }
        );
    } elsif ($c->req->{env}->{REQUEST_METHOD} eq 'POST') {
        my $id;
        my $category_id = $c->req->param('category_id');
        my $type        = $c->req->param('type');
        my $title       = $c->req->param('title');
        my $body        = $c->req->param('body');
        my $link        = $c->req->param('link');
        eval {
            #   TODO:MODELに切り出す
            my $publishes = $c->dbh->selectall_arrayref(
                qq/SELECT * FROM publishes/,
                {Slice => {}}
            );
            #   TODO:MODELに切り出す
            $c->dbh->do_i(q{INSERT INTO publishes }, {
                category_id => $category_id,
                type        => $type,
                title       => $title,
                body        => $body,
                link        => $link,
                author      => $c->session->get('id'),
            });
            $id = $c->dbh->last_insert_id(undef, undef, undef, undef);
        };
        if( $@ ){
            warn "catch!! $@\n";
        }
        $c->redirect("/publishe/view/$id");
    }
}

1;
