use utf8;
package DBIC::IMG_Core::Result::InsurCustLtvSample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::InsurCustLtvSample

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<INSUR_CUST_LTV_SAMPLE>

=cut

__PACKAGE__->table("INSUR_CUST_LTV_SAMPLE");

=head1 ACCESSORS

=head2 customer_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 last

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 first

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 state

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 region

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 sex

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 profession

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 buy_insurance

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 age

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 has_children

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 salary

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 n_of_dependents

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 car_ownership

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 house_ownership

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 time_as_customer

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 marital_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 credit_balance

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 bank_funds

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 checking_amount

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 money_montly_overdrawn

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 t_amount_autom_payments

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 monthly_checks_written

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 mortgage_amount

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 n_trans_atm

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 n_mortgages

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 n_trans_teller

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 credit_card_limits

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 n_trans_kiosk

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 n_trans_web_bank

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 ltv

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 ltv_bin

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "customer_id",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "last",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "first",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "state",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "region",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "sex",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "profession",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "buy_insurance",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "age",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "has_children",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "salary",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "n_of_dependents",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "car_ownership",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "house_ownership",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "time_as_customer",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "marital_status",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "credit_balance",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "bank_funds",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "checking_amount",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "money_montly_overdrawn",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "t_amount_autom_payments",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "monthly_checks_written",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "mortgage_amount",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "n_trans_atm",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "n_mortgages",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "n_trans_teller",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "credit_card_limits",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "n_trans_kiosk",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "n_trans_web_bank",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "ltv",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "ltv_bin",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:E0thJFOizfTSU91wHdqdyA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
