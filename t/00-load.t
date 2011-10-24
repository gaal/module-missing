#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Module::Missing' ) || print "Bail out!\n";
}

diag( "Testing Module::Missing $Module::Missing::VERSION, Perl $], $^X" );
