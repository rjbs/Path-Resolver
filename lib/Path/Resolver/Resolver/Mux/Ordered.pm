package Path::Resolver::Resolver::Mux::Ordered;
use Moose;
with 'Path::Resolver::Role::Resolver';

has resolvers => (
  is  => 'ro',
  isa => 'ArrayRef',
  required   => 1,
  auto_deref => 1,
);

sub content_for {
  my ($self, $path) = @_;
}
  

no Moose;
__PACKAGE__->meta->make_immutable;
