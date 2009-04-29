package Path::Resolver::Resolver::Mux::Prefix;
# ABSTRACT: multiplex resolvers by using path prefix
use Moose;
with 'Path::Resolver::Role::Resolver';

=attr prefixes

This is a hashref of path prefixes with the resolver that should be used for
paths under that prefix.  If a resolver is given for the empty prefix, it will
be used for content that did not begin with registered prefix.

=cut

has prefixes => (
  is  => 'ro',
  isa => 'HashRef',
  required => 1,
);

sub content_for {
  my ($self, $path) = @_;
  my @path = @$path;

  shift @path if $path[0] eq '';

  if (my $resolver = $self->prefixes->{ $path[0] }) {
    shift @path;
    return $resolver->content_for(\@path);
  }

  return unless my $resolver = $self->prefixes->{ '' };

  return $resolver->content_for(\@path);
}

no Moose;
__PACKAGE__->meta->make_immutable;
