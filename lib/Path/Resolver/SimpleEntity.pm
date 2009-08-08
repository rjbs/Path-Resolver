package Path::Resolver::SimpleEntity;
# ABSTRACT: a dead-simple entity to return, only provides content
use Moose;

use MooseX::Types::Moose qw(ScalarRef);

use namespace::autoclean;

=head1 SYNOPSIS

  my $entity = Path::Resolver::SimpleEntity->new({
    content_ref => \$string,
  });

  printf "Content: %s\n", $entity->content; 

This class is used as an extremely simple way to represent hunks of stringy
content.

=attr content_ref

This is the only real attribute of a SimpleEntity.  It's a reference to a
string that is the content of the entity.

=cut

has content_ref => (is => 'ro', isa => ScalarRef, required => 1);

=method content

This method returns the dereferenced content from the C<content_ref> attribuet.

=cut

sub content { return ${ $_[0]->content_ref } }

=method length

This method returns the length of the content.

=cut

sub length  {
  length ${ $_[0]->content_ref }
}

1;
