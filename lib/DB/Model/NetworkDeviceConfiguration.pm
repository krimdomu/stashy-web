#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package DB::Model::NetworkDeviceConfiguration;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource::Table);

__PACKAGE__->attr('id', 'Integer');
__PACKAGE__->attr('eth_id', 'Integer');
__PACKAGE__->attr('ip', 'String');
__PACKAGE__->attr('netmask', 'String');
__PACKAGE__->attr('broadcast', 'String');

__PACKAGE__->table('network_device_configuration');
__PACKAGE__->primary_key('id');

__PACKAGE__->belongs_to('NetworkDevice' => 'DB::Model::NetworkDevice', 'eth_id');


1;

