package Path::Resolver::Role::Resolver;
use Moose::Role;

use File::Spec::Unix;

requires 'content_for';

around content_for => sub {
  my ($orig, $self, $path) = @_;
  return $self->$orig($path) if ref $path;
  return $self->$orig([ 
    File::Spec::Unix->splitdir($path)
  ]);
};

no Moose::Role;
1;
