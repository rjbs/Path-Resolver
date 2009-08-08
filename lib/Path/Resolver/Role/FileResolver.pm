package Path::Resolver::Role::FileResolver;
# ABSTRACT: a resolver that natively finds absolute file paths
use Moose::Role;
with 'Path::Resolver::Role::Resolver' => { excludes => 'default_converter' };

use namespace::autoclean;

use Path::Resolver::SimpleEntity;
use Path::Resolver::Types qw(AbsFilePath);
use Path::Resolver::CustomConverter;

use MooseX::Types;

=head1 SYNOPSIS

The FileResolver role is a specialized form of the Resolver role, and can be
used in its place.  (Anything that does the FileResolver role automatically
does the Resolver role, too.)

FileResolver classes have a native type of Path::Resolver::Types::AbsFilePath
(from L<Path::Resolver::Types>).  Basically, they will natively return a
Path::Class::File pointing to an absolute file path.

FileResolver classes also have a default converter that will convert the
AbsFilePath to a L<Path::Resolver::SimpleEntity>, meaning that by default a
FileResolver's C<entity_at> will return a SimpleEntity.

=cut

sub native_type { AbsFilePath }

my $converter = Path::Resolver::CustomConverter->new({
  input_type  => AbsFilePath,
  output_type => class_type('Path::Resolver::SimpleEntity'),
  converter   => sub {
    my ($converter, $abs_path) = @_;

    open my $fh, '<', "$abs_path" or Carp::confess("can't open $abs_path: $!");
    my $content = do { local $/; <$fh> };
    Path::Resolver::SimpleEntity->new({ content_ref => \$content });
  },
});

sub default_converter { $converter }

1;
