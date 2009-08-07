package Path::Resolver::Resolver::Mux::Ordered;
# ABSTRACT: multiplex resolvers by checking them in order
use Moose;

use MooseX::AttributeHelpers;
use MooseX::Types;
use MooseX::Types::Moose qw(ArrayRef);

=attr resolvers

This is an array of other resolvers.  When asked for content, the Mux::Ordered
resolver will check each resolver in this array and return the first found
content, or false if none finds any content.

=cut

has resolvers => (
  is  => 'ro',
  isa => ArrayRef[ role_type('Path::Resolver::Role::Resolver') ],
  required   => 1,
  auto_deref => 1,
  metaclass => 'Collection::Array',
  provides  => {
    push => 'push_resolver',
    pop  => 'pop_resolver',
  },
);

has native_type => (
  is  => 'ro',
  isa => class_type('Moose::Meta::TypeConstraint'),
  required => 1,
);

with 'Path::Resolver::Role::Resolver';

sub entity_at {
  my ($self, $path) = @_;

  for my $resolver ($self->resolvers) {
    my $entity = $resolver->entity_at($path);
    next unless defined $entity;
    return $entity;
  }

  return;
}
  
no Moose;
__PACKAGE__->meta->make_immutable;
