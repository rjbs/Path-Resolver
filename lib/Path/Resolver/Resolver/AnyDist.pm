package Path::Resolver::Resolver::AnyDist;
# ABSTRACT: find content in any installed CPAN distribution's "ShareDir"
use Moose;
with 'Path::Resolver::Role::Resolver';

use File::ShareDir ();
use File::Spec;
use Path::Resolver::Util;

sub content_for {
  my ($self, $path) = @_;
  my $dist_name = shift @$path;
  my $dir = File::ShareDir::dist_dir($dist_name);

  Carp::confess("invalid path: empty after dist specifier") unless @$path;

  my $abs_path = File::Spec->catfile(
    $dir,
    File::Spec->catfile(@$path),
  );

  return Path::Resolver::Util->_content_at_abs_path($abs_path);
}

no Moose;
__PACKAGE__->meta->make_immutable;
