package Path::Resolver::SimpleEntity;
# ABSTRACT: a dead-simple entity to return, only provides content
use Moose;

use namespace::autoclean;

has content_ref => (is => 'ro');

1;
