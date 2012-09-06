use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Sunshine',
    AUTHOR        => 'Some Person <person@example.com>',
    VERSION_FROM  => 'lib/Sunshine.pm',
    PREREQ_PM     => {
        # Amon2
        'Amon2'                           => '3.53',
        'Text::Xslate'                    => '1.5006',
        'Test::More'                      => '0.98',
        'Amon2::DBI'                      => '0.06',
        'DBD::SQLite'                     => '1.33',
        'HTML::FillInForm::Lite'          => '1.09',
        'JSON'                            => '2.50',
        'Module::Pluggable::Object'       => '0',
        'Mouse'                           => '0.95',
        'Plack'                           => '1.0002',
        'Plack::Middleware::ReverseProxy' => '0.09',
        'Plack::Middleware::Session'      => '0',
        'Plack::Session'                  => '0.14',
        'String::CamelCase'               => '0.02',
        'Test::WWW::Mechanize::PSGI'      => '0',
        'Time::Piece'                     => '1.20',
        # Sunshine
        'Starman'                         => '0.3001',
        'Server::Starter'                 => '0.11',
        'Net::Server::SS::PreFork'        => '0.05',
        'DBD::mysql'                      => '4.021',
        'Email::Sender::Simple'           => '0.120001',
        'Data::Recursive::Encode'         => '0.04',
    },
    MIN_PERL_VERSION => '5.008001',
    (-d 'xt' and $ENV{AUTOMATED_TESTING} || $ENV{RELEASE_TESTING}) ? (
        test => {
            TESTS => 't/*.t xt/*.t',
        },
    ) : (),
);
