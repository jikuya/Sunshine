use strict;
use warnings;
use Test::More;

use_ok $_ for qw(
    Sunshine
    Sunshine::PC
    Sunshine::PC::Dispatcher
    Sunshine::PC::C::Root
    Sunshine::PC::C::Account
    Sunshine::Admin
    Sunshine::Admin::Dispatcher
    Sunshine::Admin::C::Root
);

done_testing;
