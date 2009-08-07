package Path::Resolver::Resolver::DataSection;
# ABSTRACT: find content in a package's Data::Section content
use Moose;
with 'Path::Resolver::Role::Resolver';

use File::Spec::Unix;
use Moose::Util::TypeConstraints;
use Path::Resolver::SimpleEntity;

sub native_type { class_type('Path::Resolver::SimpleEntity') }

=head1 DESCRIPTION

This class assumes that you will give it the name of another package and that
that package uses L<Data::Section|Data::Section> to retrieve named content from
its C<DATA> blocks and those of its parent classes.

=cut

=attr module

This is the name of the module to load and is also used as the package (class)
on which to call the data-finding method.

=cut

has module => (
  is       => 'ro',
  isa      => 'Str',
  required => 1,
);

=attr data_method

This attribute may be given to supply a method name to call to find content in
a package.  The default is Data::Section's default: C<section_data>.

=cut

has data_method => (
  is  => 'ro',
  isa => 'Str',
  default => 'section_data',
);

sub BUILD {
  my ($self) = @_;
  my $module = $self->module;
  eval "require $module; 1" or die;
}

sub entity_at {
  my ($self, $path) = @_;

  my $filename = File::Spec::Unix->catfile(@$path);
  my $method   = $self->data_method;
  my $content_ref = $self->module->$method($filename);

  return unless defined $content_ref;

  return Path::Resolver::SimpleEntity->new({ content_ref => $content_ref });
}

no Moose;
__PACKAGE__->meta->make_immutable;
