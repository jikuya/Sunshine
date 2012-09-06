package Sunshine;
use strict;
use warnings;
use utf8;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.008001;

__PACKAGE__->load_plugin(qw/DBI/);

# initialize database
use DBI;
sub setup_schema {
    my $self = shift;
    my $dbh = $self->dbh();
    my $driver_name = $dbh->{Driver}->{Name};
    my $fname = lc("sql/${driver_name}.sql");
    open my $fh, '<:encoding(UTF-8)', $fname or die "$fname: $!";
    my $source = do { local $/; <$fh> };
    for my $stmt (split /;/, $source) {
        next unless $stmt =~ /\S/;
        $dbh->do($stmt) or die $dbh->errstr();
    }
}

use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Data::Recursive::Encode;
use Encode;
sub send_mail {
    my $self       = shift;
    my $to_name    = shift;
    my $to_address = shift;
    my $subject    = shift;
    my $body       = shift;

    my $email = Email::Simple->create(
        header => Data::Recursive::Encode->encode(
            'MIME-Header-ISO_2022_JP' => [
                To      => qq/"$to_name" <$to_address>/,
                From    => '"Sunshine" <info@sunshine.com>',
                Subject => $subject,
            ]
        ),
        body       => encode('utf-8', $body),
        attributes => {
            content_type => 'text/plain',
            charset      => 'UTF-8',
            encoding     => '7bit',
        },
    );
    sendmail($email);
}

1;
