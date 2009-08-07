package Path::Resolver::Role::Resolver;
# ABSTRACT: resolving paths is just what resolvers do!
use Moose::Role;

use namespace::autoclean;

use File::Spec::Unix;
use MooseX::Types;

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

requires 'native_type';
requires 'entity_at';

around entity_at => sub {
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

  my $entity = $self->$orig(\@return_path);

  return unless defined $entity;

  if (my $conv = $self->converter) {
    return $conv->convert($entity);
  } else {
    my $native_type = $self->native_type;

    if (my $error = $native_type->validate($entity)) {
      confess $error;
    }

    return $entity;
  }
};

sub effective_type {
  my ($self) = @_;
  return $self->native_type unless $self->converter;
  return $self->converter->output_type;
}

has converter => (
  is      => 'ro',
  isa     => maybe_type( role_type('Path::Resolver::Role::Converter') ),
  builder => 'default_converter',
);

sub default_converter { return }

sub content_for {
  my ($self, $path) = @_;
  return unless my $entity = $self->entity_at($path);

  confess "located entity can't perform the content_ref method"
    unless $entity->can('content_ref');

  return $entity->content_ref;
}

1;
