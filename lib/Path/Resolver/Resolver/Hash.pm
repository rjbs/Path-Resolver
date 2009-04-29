package Path::Resolver::Resolver::Hash;
# ABSTRACT: glorified hash lookup
use Moose;
with 'Path::Resolver::Role::Resolver';

use Carp ();

=attr hash

This is a hash reference in which lookups are performed.  References to copies
of the string values are returned.

In the future, nested hashes may emulate directories.  For now, this is not the
case.

=cut

has hash => (
  is       => 'ro',
  isa      => 'HashRef',
  required => 1,
);

sub content_for {
  my ($self, $path) = @_;

  my @path = @$path;
  shift @path if $path[0] eq '';

  Carp::confess("deep lookups not supported") if @path > 1;

  my $fn = $path[0];

  Carp::confess("no such entry found: $fn")
    unless defined $self->hash->{ $fn };

  my $content = $self->hash->{ $fn };

  return \$content;
}

no Moose;
__PACKAGE__->meta->make_immutable;
