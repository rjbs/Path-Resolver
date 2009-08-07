package Path::Resolver::Resolver::Mux::Prefix;
# ABSTRACT: multiplex resolvers by using path prefix
use Moose;

use namespace::autoclean;

use MooseX::AttributeHelpers;
use MooseX::Types;
use MooseX::Types::Moose qw(Any HashRef);

=attr prefixes

This is a hashref of path prefixes with the resolver that should be used for
paths under that prefix.  If a resolver is given for the empty prefix, it will
be used for content that did not begin with registered prefix.

=cut

has prefixes => (
  is  => 'ro',
  isa => HashRef[ role_type('Path::Resolver::Role::Resolver') ],
  required  => 1,
  metaclass => 'Collection::Hash',
  provides  => {
    set => 'set_resolver_for',
    get => 'get_resolver_for',
    delete => 'delete_resolver_for',
  },
);

has native_type => (
  is  => 'ro',
  isa => class_type('Moose::Meta::TypeConstraint'),
  required => 1,
  default  => Any,
);

with 'Path::Resolver::Role::Resolver';

sub entity_at {
  my ($self, $path) = @_;
  my @path = @$path;

  shift @path if $path[0] eq '';

  if (my $resolver = $self->prefixes->{ $path[0] }) {
    shift @path;
    return $resolver->entity_at(\@path);
  }

  return unless my $resolver = $self->prefixes->{ '' };

  return $resolver->entity_at(\@path);
}

1;
