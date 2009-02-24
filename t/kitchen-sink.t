#!perl
use strict;
use warnings;
use Test::More 'no_plan';

use Path::Resolver;
use Path::Resolver::Resolver::FileSystem;
use Path::Resolver::Resolver::DistDir;
use Path::Resolver::Resolver::DataSection;
use Path::Resolver::Resolver::Archive::Tar;
use Path::Resolver::Resolver::Mux::Prefix;
use Path::Resolver::Resolver::Mux::Ordered;

use lib 't/lib';

my $prr  = 'Path::Resolver::Resolver';
my %resolver_for = (
  fs   => "$prr\::FileSystem"->new({ root => 't/eg/fs' }),
  dist => "$prr\::DistDir"->new({ dist => 'Path-Resolver' }),
  data => "$prr\::DataSection"->new({ module => 'Test::Path::Resolver::DS' }),
  tar  => "$prr\::Archive::Tar"->new({
    archive => 't/eg/archive.tar',
    root    => 'fs',
  }),
);

my $prefix = "$prr\::Mux::Prefix"->new({
  prefixes => \%resolver_for,
});

my $order  = "$prr\::Mux::Ordered"->new({
  resolvers => [
    (map {; $resolver_for{$_} } qw(fs dist data tar)),
  ],
});

for my $type (qw(fs data tar)) {
  like(
    ${ $resolver_for{ $type }->content_for('raven.txt') },
    qr{once upon a midnight dreary}i,
    "$type: found a file in a raven.txt",
  );

  is(
    ${ $resolver_for{ $type }->content_for('quotes/raven.txt') },
    "Nevermore!\n",
    "$type: and also quotes/raven.txt",
  );

  is(
    ${ $resolver_for{ $type }->content_for("$type.txt") },
    "Resolver of type $type\n",
    "$type: the unique $type.txt file",
  );

  my @content = $resolver_for{ $type }->content_for('404.html');
  is(@content, 0, "$type: return false for no-such-entry");
}
