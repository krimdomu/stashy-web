#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package DB::Model::RaidController;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource::Table);

__PACKAGE__->attr('id', 'Integer');
__PACKAGE__->attr('systems_id', 'Integer');
__PACKAGE__->attr('type', 'String');
__PACKAGE__->attr('model', 'String');
__PACKAGE__->attr('serial_number', 'String');
__PACKAGE__->attr('cache_status', 'Integer');

__PACKAGE__->table('raidcontroller');
__PACKAGE__->primary_key('id');

__PACKAGE__->belongs_to("System" => "DB::Model::System", "systems_id");
__PACKAGE__->has_n('RaidShelfs' => 'DB::Model::RaidShelf', "raidcontroller_id");


1;

