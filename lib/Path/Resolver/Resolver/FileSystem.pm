package Path::Resolver::Resolver::FileSystem;
# ABSTRACT: find files in the filesystem
use Moose;
with 'Path::Resolver::Role::Resolver';

use Carp ();
use File::Spec;
use Path::Resolver::Util;

=attr root

This is the root on the filesystem under which to look.  If it is relative, it
will be resolved to an absolute path when the resolver is instantiated.

=cut

has root => (
  is => 'rw',
  required    => 1,
  initializer => sub {
    my ($self, $value, $set) = @_;
    my $abs_dir = File::Spec->abs2rel($value);
    $set->($abs_dir);
  },
);

sub content_for {
  my ($self, $path) = @_;

  my $abs_path = File::Spec->catfile(
    $self->root,
    @$path,
  );

  return Path::Resolver::Util->_content_at_abs_path($abs_path);
}

no Moose;
__PACKAGE__->meta->make_immutable;
