package Path::Resolver::Resolver::Mux::Prefix;
use Moose;
with 'Path::Resolver::Role::Resolver';

has prefixes => (
  is  => 'ro',
  isa => 'HashRef',
  required => 1,
);

has relative_resolver => (
  is   => 'ro',
  does => 'Path::Resolver::Role::Resolver',
);

sub content_for {
  my ($self, $path) = @_;
  my @path = @$path;

  if ($path[0] eq '') {
    shift @path; # ditch the "root"

    my $prefix = shift @path;
    Carp::confess("unknown prefix '$prefix'")
      unless my $resolver = $self->prefixes->{ $prefix };

    return $resolver->content_for(\@path);
  }

  return unless $self->relative_resolver;

  return $self->relative_resolver->content_for(\@path);
}

no Moose;
__PACKAGE__->meta->make_immutable;
