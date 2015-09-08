#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.10';
use Data::Dumper;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";

use DBIx::DataModel::Schema::Generator;

use DBIC::IMG_Core;
use Carp;

my $gen = DBIx::DataModel::Schema::Generator->new( schema => 'DataModel::IMG_Core');

$gen->parse_DBIx_Class('DBIC::IMG_Core');

say $gen->perl_code;
