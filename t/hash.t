use strict;
use warnings;

use Test::More 'no_plan';

use Path::Resolver;
use Path::Resolver::Resolver::Hash;

my $hash = {
  README => "This is a readme file.\n",

  t => {
    '00-load.t'   => "Load tests are weak.",
    '99-unload.t' => "This doesn't even make sense.",
  },
};

my $prh = Path::Resolver::Resolver::Hash->new({ hash => $hash });

{
  my $content = $prh->content_for('README');
  is($$content, $hash->{README}, 'README');
}

{
  my $content = $prh->content_for('/README');
  is($$content, $hash->{README}, '/README');
}

{
  my $content = $prh->content_for('t/00-load.t');
  is($$content, $hash->{t}{'00-load.t'}, 't/00-load.t');
}

for my $path (qw(
  foo
  t
  t/foo
  t/00-load.t/README
)) {
  my $content;
  my $ok  = eval { $content = $prh->content_for($path); 1 };
  my $err = $@;

  my ($line) = split /\n/, $err;
  $line =~ s/ at lib.+//;

  ok(! $ok, "error: $path - $line");
}
