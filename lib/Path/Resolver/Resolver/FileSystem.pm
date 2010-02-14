package Path::Resolver::Resolver::FileSystem;
# ABSTRACT: find files in the filesystem
use Moose;
with 'Path::Resolver::Role::FileResolver';

use namespace::autoclean;

use Carp ();
use Cwd ();
use File::Spec;

=head1 SYNOPSIS

  my $resolver = Path::Resolver::Resolver::FileSystem->new({
    root => '/etc/myapp_config',
  });

  my $simple_entity = $resolver->entity_at('foo/bar.txt');

This resolver looks for files on disk under the given root directory.

This resolver does the
L<Path::Resolver::Role::FileResolver|Path::Resolver::Role::FileResolver> role,
meaning its native type is Path::Resolver::Types::AbsFilePath and it has a
default converter to convert to Path::Resolver::SimpleEntity.

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
