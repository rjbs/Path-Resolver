package Path::Resolver::Resolver::DistDir;
# ABSTRACT: find content in a prebound CPAN distribution's "ShareDir"
use Moose;
with 'Path::Resolver::Role::FileResolver';

use File::ShareDir ();
use File::Spec;
use Path::Resolver::Util;

=attr dist_name

This is the name of a dist (like "Path-Resolver").  When looking for content,
the resolver will look in the dist's shared content directory, as located by
L<File::ShareDir|File::ShareDir>.

=cut

has dist_name => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

sub entity_at {
  my ($self, $path) = @_;
  my $dir = File::ShareDir::dist_dir($self->dist_name);

  my $abs_path = File::Spec->catfile(
    $dir,
    File::Spec->catfile(@$path),
  );

  return Path::Class::File->new($abs_path);
}

no Moose;
__PACKAGE__->meta->make_immutable;
