package Sunshine::PC::Dispatcher;
use strict;
use warnings;
use utf8;
use Router::Simple::Declare;
use Mouse::Util qw(get_code_package);
use String::CamelCase qw(decamelize);
use Module::Pluggable::Object;

# define roots here.
my $router = router {
    # connect '/' => {controller => 'Root', action => 'index' };
    connect '/signup/begin'           => {controller => 'Signup',   action => 'begin' };
    connect '/signup/complete/:token' => {controller => 'Signup',   action => 'complate' };
    connect '/category/:id'           => {controller => 'Category', action => 'index' };
    connect '/publishe/view/:id'      => {controller => 'Publishe', action => 'view' };
};

my @controllers = Module::Pluggable::Object->new(
    require     => 1,
    search_path => ['Sunshine::PC::C'],
)->plugins;
{
    no strict 'refs';
    for my $controller (@controllers) {
        my $p0 = $controller;
        $p0 =~ s/^Sunshine::PC::C:://;
        my $p1 = $p0 eq 'Root' ? '' : decamelize($p0) . '/';

        for my $method (sort keys %{"${controller}::"}) {
            next if $method =~ /(?:^_|^BEGIN$|^import$)/;
            my $code = *{"${controller}::${method}"}{CODE};
            next unless $code;
            next if get_code_package($code) ne $controller;
            my $p2 = $method eq 'index' ? '' : $method;
            my $path = "/$p1$p2";
            $router->connect($path => {
                controller => $p0,
                action     => $method,
            });
            print STDERR "map: $path => ${p0}::${method}\n" unless $ENV{HARNESS_ACTIVE};
        }
    }
}

sub dispatch {
    my ($class, $c) = @_;
    my $req = $c->request;
    if (my $p = $router->match($req->env)) {
        my $action = $p->{action};
        $c->{args} = $p;
        "@{[ ref Amon2->context ]}::C::$p->{controller}"->$action($c, $p);
    } else {
        $c->res_404();
    }
}

1;
