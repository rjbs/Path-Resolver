package Path::Resolver::Util;
use strict;
use warnings;
# ABSTRACT: random dumping-ground for Path::Resolver snippets

sub _content_at_abs_path {
  my ($self, $abs_path) = @_;
  return unless -e $abs_path;

  open my $fh, '<', $abs_path or Carp::confess("can't open $abs_path: $!");
  my $content = do { local $/; <$fh> };
  return \$content;
}

1;
