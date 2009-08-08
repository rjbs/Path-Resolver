package Path::Resolver::Role::Converter;
# ABSTRACT: something that converts from one type to another
use Moose::Role;

use namespace::autoclean;

=head1 IMPLEMENTING

Classes implementing the Converter role must provide three methods:

=method input_type

This method must return the type of input that's expected.

=method output_type

This method must return the type of input that's promised to be returned.

=method convert

This method performs the actual converstion.  It's passed an object of
C<input_type> and returns an object of C<output_type>.

=cut

requires 'input_type';
requires 'output_type';
requires 'convert';

1;
