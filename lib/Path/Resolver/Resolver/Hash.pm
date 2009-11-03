package Path::Resolver::Resolver::Hash;
# ABSTRACT: glorified hash lookup
use Moose;
with 'Path::Resolver::Role::Resolver';

use namespace::autoclean;

use Moose::Util::TypeConstraints;
use Path::Resolver::SimpleEntity;

=head1 SYNOPSIS

  my $resolver = Path::Resolver::Resolver::Hash->new({
    hash => {
      foo => {
        'bar.txt' => "This is the content.\n",
      },
    }
  });

  my $simple_entity = $resolver->entity_for('foo/bar.txt');

This resolver looks through a has to find string content.  Path parts are used
to drill down through the hash.  The final result must be a string.  Unless you
really know what you're doing, it should be a byte string and not a character
string.

The native type of the Hash resolver is a class type of
Path::Resolver::SimpleEntity.  There is no default converter.

=cut

sub native_type { class_type('Path::Resolver::SimpleEntity') }

=attr hash

This is a hash reference in which lookups are performed.  References to copies
of the string values are returned.

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

  my $cwd = $self->hash;
  my @path_so_far;
  while (defined (my $name = shift @path)) {
    push @path_so_far, $name;

    my $entry = $cwd->{ $name};

    if (! @path) {
      return unless defined $entry;

      # XXX: Should we return because we're at a notional -d instead of -f?
      return if ref $entry;

      return Path::Resolver::SimpleEntity->new({ content_ref => \$entry });
    }

    return unless ref $entry and ref $entry eq 'HASH';

    $cwd = $entry;
  }

  Carp::confess("this should never be reached -- rjbs, 2009-04-28")
}

1;
