package Path::Resolver::Role::Resolver;
# ABSTRACT: resolving paths is just what resolvers do!
use Moose::Role;

use File::Spec::Unix;

=head1 DESCRIPTION

Classes implementing this role must provide a C<content_for> method.  It is
expected to receive an arrayref of path parts and to return either false or a
reference to a string containing the content of the file-like entity at the
path.

This role will wrap the C<content_for> method to convert strings into arrayrefs
by splitting them with File::Spec::Unix.  This means that paths should always
be given to C<content_for> following unix conventions.

Empty path parts are removed -- except for the first, which would represent the
root are skipped, and the last, which would imply that you provided a path
ending in /, which is a directory.

=cut

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
