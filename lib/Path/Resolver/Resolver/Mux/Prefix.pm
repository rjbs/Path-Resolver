package Path::Resolver::Resolver::Mux::Prefix;
# ABSTRACT: multiplex resolvers by using path prefix
use Moose;

use namespace::autoclean;

use MooseX::AttributeHelpers;
use MooseX::Types;
use MooseX::Types::Moose qw(Any HashRef);

=head1 SYNOPSIS

  my $resolver = Path::Resolver::Resolver::Mux::Prefix->new({
    prefixes => {
      foo => $foo_resolver,
      bar => $bar_resolver,
    },
  });

  my $simple_entity = $resolver->entity_for('foo/bar.txt');

This resolver looks at the first part of paths it's given to resolve.  It uses
that part to find a resolver (by looking it up in the C<prefixes>) and then
uses that resolver to resolver the rest of the path.

The default native type of this resolver is Any, meaning that is is much more
lax than other resolvers.  A C<native_type> can be specified while creating the
resolver.

=head1 WHAT'S THE POINT?

This multiplexer allows you to set up a virtual filesystem in which each
subtree is handled by a different resolver.  For example:

  my $resolver = Path::Resolver::Resolver::Mux::Prefix->new({
    config   => Path::Resolver::Resolver::FileSystem->new({
      root => '/etc/my-app',
    }),

    template => Path::Resolver::Resolver::Mux::Ordered->new({
      Path::Resolver::Resolver::DistDir->new({ module => 'MyApp' }),
      Path::Resolver::Resolver::DataSection->new({ module => 'My::Framework' }),
    }),
  });

The path F</config/main.cf> would be looked for on disk as
F</etc/my-app/main.cf>.  The path F</template/main.html> would be looked for
first as F<main.html> in the sharedir for MyApp and failing that in the DATA
section of My::Framework.

This kind of resolver allows you to provide a very simple API (that is,
filenames) to find all manner of resources, either files or otherwise.

=attr prefixes

This is a hashref of path prefixes with the resolver that should be used for
paths under that prefix.  If a resolver is given for the empty prefix, it will
be used for content that did not begin with registered prefix.

=method get_resolver_for

This method gets the resolver for the named prefix.

=method set_resolver_for

This method sets the resolver for the named prefix.

=method delete_resolver_for

This method deletes the resolver for the named prefix.

=cut

has prefixes => (
  is  => 'ro',
  isa => HashRef[ role_type('Path::Resolver::Role::Resolver') ],
  required  => 1,
  traits => ['Hash'],
  handles  => {
    get_resolver_for => 'get',
    set_resolver_for => 'set',
    delete_resolver_for => 'delete',
  },
);

has native_type => (
  is  => 'ro',
  isa => class_type('Moose::Meta::TypeConstraint'),
  required => 1,
  default  => sub { Any },
);

with 'Path::Resolver::Role::Resolver';

sub entity_at {
  my ($self, $path) = @_;
  my @path = @$path;

  shift @path if $path[0] eq '';

  if (my $resolver = $self->prefixes->{ $path[0] }) {
    shift @path;
    return $resolver->entity_at(\@path);
  }

  return unless my $resolver = $self->prefixes->{ '' };

  return $resolver->entity_at(\@path);
}

1;
