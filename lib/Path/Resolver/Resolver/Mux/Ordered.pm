package Path::Resolver::Resolver::Mux::Ordered;
# ABSTRACT: multiplex resolvers by checking them in order
use Moose;

use namespace::autoclean;

use MooseX::AttributeHelpers;
use MooseX::Types;
use MooseX::Types::Moose qw(Any ArrayRef);

=head1 SYNOPSIS

  my $resolver = Path::Resolver::Resolver::Mux::Ordered->new({
    resolvers => [
      $resolver_1,
      $resolver_2,
      ...
    ],
  });

  my $simple_entity = $resolver->entity_for('foo/bar.txt');

This resolver looks in each of its resolvers in order and returns the result of
the first of its sub-resolvers to find the named entity.  If no entity is
found, it returns false as usual.

The default native type of this resolver is Any, meaning that is is much more
lax than other resolvers.  A C<native_type> can be specified while creating the
resolver.

=attr resolvers

This is an array of other resolvers.  When asked for content, the Mux::Ordered
resolver will check each resolver in this array and return the first found
content, or false if none finds any content.

=method unshift_resolver

This method will add a resolver to the beginning of the list of consulted
resolvers.

=method push_resolver

This method will add a resolver to the end of the list of consulted resolvers.

=cut

has resolvers => (
  is  => 'ro',
  isa => ArrayRef[ role_type('Path::Resolver::Role::Resolver') ],
  required   => 1,
  auto_deref => 1,
  metaclass => 'Collection::Array',
  provides  => {
    push    => 'push_resolver',
    unshift => 'unshift_resolver',
  },
);

has native_type => (
  is  => 'ro',
  isa => class_type('Moose::Meta::TypeConstraint'),
  default  => sub { Any },
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
  
1;
