package Module::Missing;

use 5.006;
use strict;
use warnings;

=head1 NAME

Module::Missing - Prints nicer error messages when a module isn't found

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

# Like this:  push @INC, \&missing_handler;
# But safer against weird double inclusions.
@INC = ((grep { $_ ne \&missing_handler } @INC), \&missing_handler);

my $Moving;  # Am I swiping myself to the end of @INC?

sub missing_handler {
    my($me, $want) = @_;

    # This hander wants to be last in @INC. If it isn't, it tries to
    # move itself. Because someone else may be crazy like us, don't
    # insist.

    if ($INC[-1] ne $me) {
        return if $Moving;

        $Moving = 1;
        @INC = (\&cleaner, (grep { $_ ne $me } @INC), $me);
        return;
    }

    # That's it, we're going to die. Throw the error ourselves instead
    # of letting perl do it.

    # TODO(gaal): Respect perl's i18n? Maybe by something crazy like:
    # eval { local @INC = grep { $_ != $me } @INC ; require package($want) };
    # die $@ . our message

    local $" = " ";  # This is Perl's default. Just making sure!
    die "Can't locate $want in \@INC (\@INC contains: @INC .).\n" .
        pretty_message($want);
}

sub cleaner {
    my($me, $want) = @_;
    @INC = grep { $_ ne $me } @INC;
    $Moving = 0;
    return;
}

sub pretty_message {
    my($file) = @_;
    my $package = pkg($file);
    my $deb = deb($package);

    # TODO(gaal): Detect if we're on other kinds of systems and suggest
    # the suitable package management command.

    return <<"EOF";

*** Looks like your system is missing the $package package.

    You might try your luck running the following command:

      sudo apt-get install $deb

    If that doesn't work, try this:

      cpan $package
EOF
}

sub pkg {
    my($file) = @_;

    $file =~ s{[/\\]}{::}g;
    $file =~ s/\.pm//;

    return $file;
}

sub deb {
    my($package) = @_;

    $package = lc $package;
    $package =~ s/::/-/g;

    return "lib$package-perl";
}

=head1 SYNOPSIS

Perl has a standard error message that it prints whenever a dependency
for "use", "require" etc. aren't found. It's very useful for programmers,
because it contains a dump of the module search path, but for mere mortals
it can be a bit daunting.

Module::Missing catches these failures and adds some actionable tips
for the user.

    use Module::Missing;
    use Acme::Transmogrifier;  # not installed

    Can't locate Acme::Transmogrifier in @INC (@INC contains: ... .).
    Try this:
      sudo apt-get install libacme-transmogrifier-perl

=head1 AUTHOR

Gaal Yahas, C<< <gaal at forum2.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-module-missing at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Module-Missing>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Module::Missing


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Missing>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Module-Missing>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Module-Missing>

=item * Search CPAN

L<http://search.cpan.org/dist/Module-Missing/>

=item * Source repository

L<http://github.com/gaal/module-missing/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Gaal Yahas.

This program is distributed under the MIT (X11) License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.


=cut

6;
