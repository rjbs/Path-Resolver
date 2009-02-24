package Path::Resolver::Resolver::Mux::Prefix;
# ABSTRACT: multiplex resolvers by using path prefix
use Moose;
with 'Path::Resolver::Role::Resolver';

=attr prefixes

This is a hashref of path prefixes with the resolver that should be used for
paths under that prefix.  If a resolver is given for the empty prefix, it will
be used for relative paths.  Otherwise, relative paths will always fail.

=cut

has prefixes => (
  is  => 'ro',
  isa => 'HashRef',
  required => 1,
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

  return unless $self->prefixes->{''};

  return $self->prefixes->{''}->content_for(\@path);
}

no Moose;
__PACKAGE__->meta->make_immutable;
