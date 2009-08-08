package Path::Resolver::Types;
# ABSTRACT: types for use with Path::Resolver
use MooseX::Types -declare => [ qw(AbsFilePath) ];
use MooseX::Types::Moose qw(Str);

use namespace::autoclean;

use Path::Class::File;

=head1 OVERVIEW

This library will contain any new types needed for use with Path::Resolver.

=head1 TYPES

=head2 AbsFilePath

This type validates Path::Class::File objects that are absolute paths and
readable.  They can be coerced from strings by creating a new Path::Class::File
from the string.

=cut

subtype AbsFilePath,
  as class_type('Path::Class::File'),
  where { $_->is_absolute and -r "$_" };

coerce AbsFilePath, from Str, via { Path::Class::File->new($_) };

1;
