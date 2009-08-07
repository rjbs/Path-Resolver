package Path::Resolver::Resolver::Mux::Ordered;
# ABSTRACT: multiplex resolvers by checking them in order
use Moose;
with 'Path::Resolver::Role::Resolver';

use MooseX::Types::Moose qw(Any);

=attr resolvers

This is an array of other resolvers.  When asked for content, the Mux::Ordered
resolver will check each resolver in this array and return the first found
content, or false if none finds any content.

=cut

has resolvers => (
  is  => 'ro',
  isa => 'ArrayRef',
  required   => 1,
  auto_deref => 1,
);

sub native_type { Any } # XXX: So awful! -- rjbs, 2009-08-06

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
