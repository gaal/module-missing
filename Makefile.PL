use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Module::Missing',
    AUTHOR              => q{Gaal Yahas <gaal@forum2.org>},
    VERSION_FROM        => 'lib/Module/Missing.pm',
    ABSTRACT_FROM       => 'lib/Module/Missing.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'mit')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Module-Missing-*' },
);
