#!perl
use strict;
use warnings;
use Test::More 'no_plan';

use Path::Resolver;
use Path::Resolver;
use Path::Resolver;
use Path::Resolver;
use Path::Resolver;
use Path::Resolver;
use Path::Resolver;

use lib 't/lib';

use Path::Resolver;

# test and implement:
#   filesystem
#   sharedir
#   data sections
#   tar entries
#   mux (prefix)
#   mux (overlay)

my $prr  = 'Path::Resolver::Resolver';
my %resolver_for = (
  fs   => "$prr\::FileSystem"->new({ root => 't/eg/fs' }),
  dist => "$prr\::ShareDir"->new({ dist => 'Path-Resolver' }),
  data => "$prr\::DataSection"->new({ module => 'Test::Path::Resolver::DS' }),
  tar  => "$prr\::Archive::Tar"->new({ archive => 't/eg/tar/archive.tar' }),
);

my $prefix = "$prr\::Mux::Prefix"->new({
  prefixes => \%resolver_for,
});

my $order  = "$prr\::Mux::Ordered"->new({
  resolvers => [
    (map {; $resolver_for{$_} } qw(fs dist data tar)),
  ],
});
