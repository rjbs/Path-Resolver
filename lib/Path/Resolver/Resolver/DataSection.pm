package Path::Resolver::Resolver::DataSection;
use Moose;
with 'Path::Resolver::Role::Resolver';

use File::Spec::Unix;

has module => (
  is       => 'ro',
  isa      => 'Str',
  required => 1,
);

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

sub content_for {
  my ($self, $path) = @_;

  my $filename = File::Spec::Unix->catfile(@$path);
  my $method   = $self->data_method;
  my $content_ref = $self->module->$method($filename);

  return unless defined $content_ref;
  return $content_ref;
}

no Moose;
__PACKAGE__->meta->make_immutable;
