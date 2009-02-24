package Path::Resolver::Resolver::Mux::Prefix;
use Moose;
with 'Path::Resolver::Role::Resolver';

has prefixes => (
  is  => 'ro',
  isa => 'HashRef',
  required => 1,
);

sub content_for {
  my ($self, $path) = @_;
  my @path = @$path;

  Carp::confess("relative path resolution not yet implemented")
    unless (shift @path) eq '';

  my $prefix = shift @path;
  Carp::confess("unknown prefix '$prefix'")
    unless my $resolver = $self->prefixes->{ $prefix };

  return $resolver->content_for(\@path);
}

no Moose;
__PACKAGE__->meta->make_immutable;
