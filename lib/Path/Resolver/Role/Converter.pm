package Path::Resolver::Role::Converter;
# ABSTRACT: something that converts from one type to another
use Moose::Role;

use namespace::autoclean;

requires 'input_type';
requires 'convert';
requires 'output_type';

1;
