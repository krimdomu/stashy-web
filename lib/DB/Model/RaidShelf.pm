#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package DB::Model::RaidShelf;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource::Table);

__PACKAGE__->attr('id', 'Integer');
__PACKAGE__->attr('raidcontroller_id', 'Integer');
__PACKAGE__->attr('type', 'String');
__PACKAGE__->attr('status', 'Integer');

__PACKAGE__->table('raidshelfs');
__PACKAGE__->primary_key('id');

__PACKAGE__->belongs_to('RaidController' => 'DB::Model::RaidController', 'raidcontroller_id');
__PACKAGE__->has_n('RaidVolumes' => 'DB::Model::RaidVolume', "raidshelf_id");


1;

