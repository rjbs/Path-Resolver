use strict;
use warnings;

use Test::More 'no_plan';

use Path::Resolver;
use Path::Resolver::Resolver::Hash;

my $prh = Path::Resolver::Resolver::Hash->new({
  hash => {
    README => "This is a readme file.\n",

    t => {
      '00-load.t'   => "Load tests are weak.",
      '99-unload.t' => "This doesn't even make sense.",
    },
  },
});

{
  my $content = $prh->content_for('README');
  diag $$content;
}

{
  my $content = $prh->content_for('/README');
  diag $$content;
}

{
  my $content = $prh->content_for('t/00-load.t');
  diag $$content;
}

ok(1);
