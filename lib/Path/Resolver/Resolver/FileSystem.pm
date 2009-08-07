package Path::Resolver::Resolver::FileSystem;
# ABSTRACT: find files in the filesystem
use Moose;
with 'Path::Resolver::Role::FileResolver';

use namespace::autoclean;

use Carp ();
use Cwd ();
use File::Spec;

=attr root

This is the root on the filesystem under which to look.  If it is relative, it
will be resolved to an absolute path when the resolver is instantiated.

=cut

has root => (
  is => 'rw',
  required    => 1,
  default     => sub { Cwd::cwd },
  initializer => sub {
    my ($self, $value, $set) = @_;
    my $abs_dir = File::Spec->rel2abs($value);
    $set->($abs_dir);
  },
);

sub entity_at {
  my ($self, $path) = @_;

  my $abs_path = File::Spec->catfile(
    $self->root,
    @$path,
  );

  return unless -e $abs_path and -f _;

  Path::Class::File->new($abs_path);
}

1;
