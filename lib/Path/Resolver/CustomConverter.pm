package Path::Resolver::CustomConverter;
# ABSTRACT: a one-off converter between any two types using a coderef
use Moose;
use namespace::autoclean;

use MooseX::Types;
use MooseX::Types::Moose qw(CodeRef);

=head1 SYNOPSIS

  my $converter = Path::Resolver::CustomConverter->new({
    input_type  => SomeType,
    output_type => AnotherType,
    converter   => sub { ...return an AnotherType value... },
  });

  my $resolver = Path::Resolver::Resolver::Whatever->new({
    converter => $converter,
    ...
  });

  my $another = $resolver->entity_at('/foo/bar/baz.txt');

This class lets you produce one-off converters between any two types using an
arbitrary hunk of code.

=attr input_type

This is the L<Moose::Meta::TypeConstraint> for objects that the converter
expects to be handed as input.

=attr output_type

This is the L<Moose::Meta::TypeConstraint> for objects that the converter
promises to return as output.

=cut

has [ qw(input_type output_type) ] => (
  is  => 'ro',
  isa => class_type('Moose::Meta::TypeConstraint'),
  required => 1,
);

=attr converter

This is the coderef that will perform the conversion.  It will be called like a
method:  the first argument will be the converter object, followed by the value
to convert.

=cut

has converter => (
  is  => 'ro',
  isa => CodeRef,
  required => 1,
);

=method convert

This method accepts an input value, passes it to the converter coderef, and
returns the result.

=cut

sub convert {
  $_[0]->converter->(@_);
}

with 'Path::Resolver::Role::Converter';
1;
