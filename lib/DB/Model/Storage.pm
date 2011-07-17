#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package DB::Model::Storage;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource::Table);

__PACKAGE__->attr('id', 'Integer');
__PACKAGE__->attr('systems_id', 'Integer');
__PACKAGE__->attr('bus', 'String');
__PACKAGE__->attr('dev', 'String');
__PACKAGE__->attr('product', 'String');
__PACKAGE__->attr('vendor', 'String');
__PACKAGE__->attr('size', 'Integer');

__PACKAGE__->table('storages');
__PACKAGE__->primary_key('id');

__PACKAGE__->belongs_to('System' => 'DB::Model::System', 'systems_id');


1;

