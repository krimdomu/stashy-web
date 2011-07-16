#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package Rex::Stashy::Server::Commands;

use strict;
use warnings;

use Rex::Commands;
use Rex::Commands::Run;

task "reboot", sub {

   run "reboot";

};

1;
