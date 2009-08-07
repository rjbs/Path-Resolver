package Path::Resolver::Role::Converter;
use Moose::Role;
use namespace::autoclean;

requires 'input_type';
requires 'convert';
requires 'output_type';

1;
