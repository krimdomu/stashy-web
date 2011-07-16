#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package DB::Model::System;

use strict;
use warnings;

use base qw(DM4P::DM::DataSource::Table);

__PACKAGE__->attr('id', 'Integer');
__PACKAGE__->attr('hostname', 'String');
__PACKAGE__->attr('domainname', 'String');
__PACKAGE__->attr('added', 'DateTime');
__PACKAGE__->attr('os', 'String');
__PACKAGE__->attr('osrelease', 'String');
__PACKAGE__->attr('product_name', 'String');
__PACKAGE__->attr('description', 'Text');

__PACKAGE__->table('systems');
__PACKAGE__->primary_key('id');

__PACKAGE__->has_n('Baseboards' => 'DB::Model::Baseboard', "systems_id");
__PACKAGE__->has_n('Cpus' => 'DB::Model::Cpu', "systems_id");
__PACKAGE__->has_n('Dimms' => 'DB::Model::Dimm', "systems_id");
__PACKAGE__->has_n('NetworkDevices' => 'DB::Model::NetworkDevice', "systems_id");


1;

