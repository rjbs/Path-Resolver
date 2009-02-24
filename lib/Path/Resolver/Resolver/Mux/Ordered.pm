package Path::Resolver::Resolver::Mux::Ordered;
# ABSTRACT: multiplex resolvers by checking them in order
use Moose;
with 'Path::Resolver::Role::Resolver';

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

sub content_for {
  my ($self, $path) = @_;

  for my $resolver ($self->resolvers) {
    next unless my $ref = $resolver->content_for($path);
    return $ref;
  }

  return;
}
  
no Moose;
__PACKAGE__->meta->make_immutable;
