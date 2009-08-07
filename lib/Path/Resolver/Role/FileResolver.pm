package Path::Resolver::Role::FileResolver;
use Moose::Role;
with 'Path::Resolver::Role::Resolver' => { excludes => 'default_converter' };

use Path::Resolver::SimpleEntity;
use Path::Resolver::Types qw(AbsFilePath);

sub native_type { AbsFilePath }

sub default_converter {
  return sub {
    my ($abs_path) = @_;

    open my $fh, '<', "$abs_path" or Carp::confess("can't open $abs_path: $!");
    my $content = do { local $/; <$fh> };
    Path::Resolver::SimpleEntity->new({
      content_ref => \$content,
    });
  };
}

no Moose::Role;
1;
