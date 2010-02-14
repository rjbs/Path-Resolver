package Path::Resolver::Resolver::AnyDist;
# ABSTRACT: find content in any installed CPAN distribution's "ShareDir"
use Moose;
with 'Path::Resolver::Role::FileResolver';

use namespace::autoclean;

use File::ShareDir ();
use File::Spec;
use Path::Class::File;

=head1 SYNOPSIS

  my $resolver = Path::Resolver::Resolver::AnyDist->new;

  my $simple_entity = $resolver->entity_at('/MyApp-Config/foo/bar.txt');

This resolver looks for files on disk in the shared resource directory of the
distribution named by the first part of the path.  For more information on
sharedirs, see L<File::ShareDir|File::ShareDir>.

This resolver does the
L<Path::Resolver::Role::FileResolver|Path::Resolver::Role::FileResolver> role,
meaning its native type is Path::Resolver::Types::AbsFilePath and it has a
default converter to convert to Path::Resolver::SimpleEntity.

=cut

sub entity_at {
  my ($self, $path) = @_;
  my $dist_name = shift @$path;
  my $dir = File::ShareDir::dist_dir($dist_name);

  Carp::confess("invalid path: empty after dist specifier") unless @$path;

  my $abs_path = File::Spec->catfile(
    $dir,
    File::Spec->catfile(@$path),
  );

  return Path::Class::File->new($abs_path);
}

1;
