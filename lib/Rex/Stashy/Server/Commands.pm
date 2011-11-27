#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package Rex::Stashy::Server::Commands;

use strict;
use warnings;

use Rex::Commands::DB;

use Rex::Commands::Inventory;
use Rex::Commands::Gather;
use Rex::Hardware;
use Rex::Hardware::Host;

use Rex::Commands;
use Rex::Commands::Run;
use Rex::Commands::Fs;
use Rex::Commands::File;
use Rex::Commands::Download;
use Rex::Commands::Upload;
use Rex::Commands::Gather;
use Rex::Commands::Kernel;
use Rex::Commands::Pkg;
use Rex::Commands::Service;
use Rex::Commands::Sysctl;
use Rex::Commands::Tail;
use Rex::Commands::Process;


task "reboot", sub {

#   run "reboot";

};

task "inventory", sub {

   my $inventory = inventory;
   #print Dumper($inventory);
   # return;

   my $host_info = $inventory->{"configuration"}->{"host"};

   my $osrelease = Rex::Hardware::Host->get_operating_system_version();

   my ($hostname) = split(/\./, $host_info->{"name"});

   my @s = db select => {
               fields => "id",
               from   => "systems",
               where  => "hostname='" . $hostname . "' AND domainname='" . $host_info->{"domain"} . "'"
            };
   my $in_db = @s?1:0;


   if(! $in_db) {

      db insert => "systems", {
                        hostname => $hostname,
                        domainname => $host_info->{"domain"},
                        added => datetime(),
                        os => get_operating_system(),
                        osrelease => $osrelease,
                        product_name => $inventory->{"system_info"}->{"product_name"},
                     }; 
                     
      my @sys = db select => {
               fields => "id",
               from   => "systems",
               where  => "hostname='" . $hostname . "' AND domainname='" . $host_info->{"domain"} . "'"
            };

      my $system_id = $sys[0]->{"id"};
      my $base_board = $inventory->{"base_board"};

      db insert => "baseboard", {
                        systems_id => $system_id,
                        serialnumber => $base_board->{"serialnumber"} || "",
                        manufacturer => $base_board->{"manufacturer"} || "",
                        product_name => $base_board->{"product_name"} || "",
                     };

     my $cpus = $inventory->{"cpus"};
     for my $cpu (@{$cpus}) {
        my ($speed) = ($cpu->{"max_speed"} =~ m/^(\d+)/);
        db insert => "cpus", {
                        systems_id => $system_id,
                        family => $cpu->{"family"} || "",
                        speed  => $speed || 0,
                     };
     }

     my $dimms = $inventory->{"dimms"};
     for my $dimm (@{$dimms}) {
        my ($speed) = ($dimm->{"speed"} =~ m/^(\d+)/);
        my ($size)  = ($dimm->{"size"} =~ m/^(\d+)/);
        db insert => "dimms", {
                        systems_id => $system_id,
                        serial_number => $dimm->{"serial_number"},
                        locator => $dimm->{"locator"},
                        size => $dimm->{"size"},
                        part_number => $dimm->{"part_number"},
                        speed => $dimm->{"speed"},
                        type => $dimm->{"type"},
                        form_factor => $dimm->{"form_factor"},
                     };
     }

     my $eths = $inventory->{"net"};
     for my $eth (@{$eths}) {
      db insert => "network_devices", {
                        systems_id => $system_id,
                        dev => $eth->{"dev"},
                        product => $eth->{"product"},
                        mac => $eth->{"mac"},
                        vendor => $eth->{"vendor"},
                     };

        my @dev = db select => {
                           fields => "id",
                           from => "network_devices",
                           where => "dev='" . $eth->{"dev"} . "' AND systems_id=$system_id AND mac='" . $eth->{"mac"} . "'",
                        };

       my $eth_id = $dev[0]->{"id"};

       my $net_conf = $inventory->{"configuration"}->{"network"}->{"current_configuration"}->{$eth->{"dev"}};
       if($net_conf) {
         db insert => "network_device_configuration", {
                                 eth_id => $eth_id,
                                 ip => $net_conf->{"ip"},
                                 netmask => $net_conf->{"netmask"},
                                 broadcast => $net_conf->{"broadcast"},
                              };
       }

    }

    for my $pkg (installed_packages()) {
        db insert => "software", {
                           systems_id => $system_id,
                           name => $pkg->{"name"},
                           version => $pkg->{"version"},
                        };
    }

    my $mem_arrays = $inventory->{"mem_arrays"};
      for my $mem_arr (@{$mem_arrays}) {
         my ($max) = ($mem_arr->{"maximum_capacity"} =~ m/^(\d+)/);
         db insert => "memarrays", {
                           systems_id => $system_id,
                           maximum => $max,
                           slots => $mem_arr->{"number_of_devices"},
                        };
      }
       
    my $storages = $inventory->{"storage"};
      for my $st (@{$storages}) {
         next unless $st->{"dev"}; # skip everything without a device
         db insert => "storages", {
                           systems_id => $system_id,
                           bus => $st->{"bus"},
                           dev => $st->{"dev"},
                           product => $st->{"product"},
                           vendor => $st->{"vendor"},
                           size => $st->{"size"},
                        };
      }

   my $raid_controller = $inventory->{"raid"}->{"controller"};
      for my $ctrl (@{$raid_controller}) {
         db insert => "raidcontroller", {
                           systems_id => $system_id,
                           serial_number => $ctrl->{"serial_number"},
                           type => $ctrl->{"type"},
                           model => $ctrl->{"model"},
                           cache_status => $ctrl->{"cache_status"},
                        };
         my ($ctrl_in_db) = db select => {
                           fields => "id",
                           from => "raidcontroller",
                           where => "systems_id=$system_id AND serial_number = '" . $ctrl->{"serial_number"} . "'",
                        };

         if($ctrl_in_db) {
            for my $shelf (keys %{$ctrl->{"shelfs"}}) {
               db insert => "raidshelfs", {
                           raidcontroller_id => $ctrl_in_db->{"id"},
                           type => $ctrl->{"shelfs"}->{$shelf}->{"type"},
                           status => $ctrl->{"shelfs"}->{$shelf}->{"status"},
                        };

               my ($shelf_in_db) = db select => {
                                       fields => "id",
                                       from => "raidshelfs",
                                       where => "raidcontroller_id=" . $ctrl_in_db->{"id"},
                                       order => "id DESC",
                                    };

               if($shelf_in_db) {
                  for my $ld (@{$ctrl->{"shelfs"}->{$shelf}->{"logical_drives"}}) {
                     db insert => "raidvolumes", {
                                 raidshelf_id => $shelf_in_db->{"id"},
                                 dev => $ld->{"dev"},
                                 raid_level => $ld->{"raid_level"},
                                 status => $ld->{"status"},
                                 size => $ld->{"size"},
                              };
                  }
               }
               else {
                  die("Shelf not found :(");
               }
            }
         }
         else {
            die("Controller not found :(");
         }
      }
   
   } # end if


};


# helper functions

sub datetime {
   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
   $year += 1900;
   ++$mon;
   $mon  = sprintf("%02i", $mon);
   $mday = sprintf("%02i", $mday);

   return "$year-$mon-$mday $hour:$min:$sec";
}
 

1;
