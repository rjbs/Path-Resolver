package Path::Resolver::Types;
use MooseX::Types -declare => [ qw(AbsFilePath) ];
use MooseX::Types::Moose qw(Str);

use Path::Class::File;

subtype AbsFilePath,
  as class_type('Path::Class::File'),
  where { $_->is_absolute and -r "$_" };

coerce AbsFilePath, from Str, via { Path::Class::File->new($_) };

no MooseX::Types;
1;
