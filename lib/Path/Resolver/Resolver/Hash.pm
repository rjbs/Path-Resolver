package Path::Resolver::Resolver::Hash;
# ABSTRACT: glorified hash lookup
use Moose;
with 'Path::Resolver::Role::Resolver';

use namespace::autoclean;

use Moose::Util::TypeConstraints;
use Path::Resolver::SimpleEntity;

sub native_type { class_type('Path::Resolver::SimpleEntity') }

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

sub __str_path {
  my ($self, $path) = @_;

  my $str = join '/', map { my $part = $_; $part =~ s{/}{\\/}g; $part } @$path;
}

sub entity_at {
  my ($self, $path) = @_;

  my @path = @$path;
  shift @path if $path[0] eq '';

  my $cwd = $self->{hash};
  my @path_so_far;
  while (defined (my $name = shift @path)) {
    push @path_so_far, $name;

    my $entry = $cwd->{ $name};

    if (! @path) {
      return unless defined $entry;

      return if ref $entry;
      #Carp::confess("not a leaf entity: " . $self->__str_path(\@path_so_far))
      #  if ref $entry;

      return Path::Resolver::SimpleEntity->new({ content_ref => \$entry });
    }

    # Carp::confess("not a parent entity: " . $self->__str_path(\@path_so_far))
    return 
      unless ref $entry and ref $entry eq 'HASH';

    $cwd = $entry;
  }

  Carp::confess("this should never be reached -- rjbs, 2009-04-28")
}

1;
