package UNIVERSAL::AUTHORITY;

use 5.005;
use strict;

BEGIN {
	$UNIVERSAL::AUTHORITY::AUTHORITY = 'cpan:TOBYINK';
	$UNIVERSAL::AUTHORITY::VERSION   = '0.001';
}

use Carp qw[croak];
use Scalar::Util qw[blessed];
use UNIVERSAL qw[];

sub UNIVERSAL::AUTHORITY
{
	my ($invocant, $test) = @_;	
	my $authority = do {
		no strict 'refs';
		${"$invocant\::AUTHORITY"};
		};
	
	if (scalar @_ > 1)
	{
		if (defined $authority)
		{
			croak("Invocant ($invocant) has authority '$authority'.")
				unless _reasonably_smart_match($authority, $test);
		}
		else
		{
			croak("Invocant ($invocant) has no authority defined.")
				unless _reasonably_smart_match($authority, $test);
		}
	}
	
	return $authority;
}

sub _reasonably_smart_match
{
	my ($a, $b) = @_;
	
	if (!defined $b)
	{
		return !defined $a;
	}
	elsif (ref $b eq 'CODE')
	{
		return $b->($a);
	}
	elsif (ref $b eq 'HASH')
	{
		return unless defined $a;
		return exists $b->{$a};
	}
	elsif (ref $b eq 'ARRAY')
	{
		return grep { _reasonably_smart_match($a, $_) } @$b;
	}
	elsif (ref $b eq 'Regexp')
	{
		return ($a =~ $b);
	}
	else
	{
		return ($a eq $b);
	}
}

1;

__END__

=head1 NAME

UNIVERSAL::AUTHORITY - adds an AUTHORITY method to UNIVERSAL

=head1 SYNOPSIS

 if (HTML::HTML5::Writer->AUTHORITY ne HTML::HTML5::Builder->AUTHORITY)
 {
   warn "Closely intertwined modules with different authors!\n";
   warn "There may be trouble ahead...";
 }

 # Only trust STEVAN's releases
 Moose->AUTHORITY('cpan:STEVAN'); # dies if doesn't match

=head1 DESCRIPTION

This module adds an C<AUTHORITY> function to the C<UNIVERSAL> package, which
works along the same lines as the C<VERSION> function. Because it is defined
in C<UNIVERSAL>, it becomes instantly available as a method for any blessed
objects, and as a class method for any package.

The authority of a package can be defined like this:

 package MyApp;
 BEGIN { $MyApp::AUTHORITY = 'cpan:JOEBLOGGS'; }

The authority should be a URI identifying the person, team, organisation
or trained chimp responsible for the release of the package. The
pseudo-URI scheme C<< cpan: >> is the most commonly used identifier.

=head2 C<< UNIVERSAL::AUTHORITY >>

Called with no parameters returns the authority of a CPAN release.

=head2 C<< UNIVERSAL::AUTHORITY($test) >>

If passed a test, will croak if the test fails. The authority is tested
against the test using something approximating Perl 5.10's smart match
operator. (Briefly, you can pass a string for C<eq> comparison, a regular
expression, a code reference to use as a callback, or an array reference
that will be grepped.)

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=UNIVERSAL-AUTHORITY>.

=head1 SEE ALSO

L<UNIVERSAL>,
L<UNIVERSAL::which>,
L<UNIVERSAL::dump>,
L<UNIVERSAL::DOES>,
&c.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2011 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

