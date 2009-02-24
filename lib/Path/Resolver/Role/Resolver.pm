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
  my @input_path;

  if (ref $path) {
    @input_path = @$path;
  } else {
    Carp::confess("invalid path: empty") unless defined $path and length $path;

    @input_path = File::Spec::Unix->splitdir($path);
  }

  Carp::confess("invalid path: empty") unless @input_path;
  Carp::confess("invalid path: ends with non-filename")
    if $input_path[-1] eq '';

  my @return_path;
  push @return_path, (shift @input_path) if $input_path[0] eq '';
  push @return_path, grep { defined $_ and length $_ } @input_path;

  return $self->$orig(\@return_path);
};

no Moose::Role;
1;
