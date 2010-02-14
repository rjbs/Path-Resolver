package Path::Resolver::Resolver::Archive::Tar;
# ABSTRACT: find content inside a tar archive
use Moose;
use Moose::Util::TypeConstraints;
with 'Path::Resolver::Role::Resolver';

use namespace::autoclean;

use Archive::Tar;
use File::Spec::Unix;
use Path::Resolver::SimpleEntity;

=head1 SYNOPSIS

  my $resolver = Path::Resolver::Resolver::Archive::Tar->new({
    archive => 'archive-file.tar.gz',
  });

  my $simple_entity = $resolver->entity_at('foo/bar.txt');

This resolver looks for files inside a tar archive or a compressed tar archive.
It uses L<Archive::Tar|Archive::Tar>, and can read any archive understood by
that library.

The native type of this resolver is a class type of
L<Path::Resolver::SimpleEntity|Path::Resolver::SimpleEntity> and it has no
default converter.

=cut

sub native_type { class_type('Path::Resolver::SimpleEntity') }

=attr archive

This attribute stores the Archive::Tar object in which content will be
resolved.  A simple string may be passed to the constructor to be used as an
archive filename.

=cut

has archive => (
  is  => 'ro',
  required    => 1,
  initializer => sub {
    my ($self, $value, $set) = @_;

    my $archive = ref $value ? $value : Archive::Tar->new($value);

    confess("$value is not a valid archive value")
      unless class_type('Archive::Tar')->check($archive);
    
    $set->($archive);
  },
);

=attr root

If given, this attribute specifies a root inside the archive under which to
look.  This is useful when dealing with an archive in which all content is
under a common directory.

=cut

has root => (
  is => 'ro',
  required => 0,
);

sub entity_at {
  my ($self, $path) = @_;
  my $root = $self->root;
  my @root = (length $root) ? $root : ();

  my $filename = File::Spec::Unix->catfile(@root, @$path);
  return unless $self->archive->contains_file($filename);
  my $content = $self->archive->get_content($filename);

  Path::Resolver::SimpleEntity->new({ content_ref => \$content });
}

1;
