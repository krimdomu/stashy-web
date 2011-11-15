#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package DB::Model::Scm;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource::Table);

__PACKAGE__->attr('id', 'Integer');
__PACKAGE__->attr('name', 'String');
__PACKAGE__->attr('url', 'String');
__PACKAGE__->attr('username', 'String');
__PACKAGE__->attr('password', 'String');

__PACKAGE__->table('scms');
__PACKAGE__->primary_key('id');


1;

