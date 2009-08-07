package Path::Resolver::CustomConverter;
# ABSTRACT: a one-off converter between any two types using a coderef
use Moose;
use namespace::autoclean;

use MooseX::Types;
use MooseX::Types::Moose qw(CodeRef);

has [ qw(input_type output_type) ] => (
  is  => 'ro',
  isa => class_type('Moose::Meta::TypeConstraint'),
  required => 1,
);

has converter => (
  is  => 'ro',
  isa => CodeRef,
  required => 1,
);

sub convert {
  $_[0]->converter->(@_);
}

with 'Path::Resolver::Role::Converter';
1;
