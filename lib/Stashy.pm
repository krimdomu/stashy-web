package Stashy;
use Mojo::Base 'Mojolicious';

use Rex;
use Rex::Config;
use Rex::Commands;


use DM4P;
use DM4P::Connection::Server::MySQL;
use DM4P::DM;

use DB::Model::System;
use DB::Model::Baseboard;
use DB::Model::Cpu;
use DB::Model::Dimm;
use DB::Model::NetworkDevice;
use DB::Model::NetworkDeviceConfiguration;
use DB::Model::Software;
use DB::Model::MemoryArray;
use DB::Model::Storage;
use DB::Model::RaidController;
use DB::Model::RaidShelf;
use DB::Model::RaidVolume;
use DB::Model::Scm;



# This method will run once at server start
sub startup {
   my $self = shift;

   # Documentation browser under "/perldoc" (this plugin requires Perl 5.10)
   $self->plugin("PODRenderer");
   my $config = $self->plugin("Config");

   # Routes
   my $r = $self->routes;

   # Normal route to controller
   $r->route('/')->to('dashboard#index', active_li => "li_dashboard");
   $r->route('/search/:servername')->to('dashboard#search', active_li => "li_dashboard");

   # nur get eigentlich
   $r->route('/server/add')->via('GET')->to('server#add');

   $r->route('/server/:serverid')->to('server#index', active_li => "li_server");

   $r->route('/server/get_information/:serverid')->to('server#get_information');
   $r->route('/server/software/:serverid')->to('server#software', active_li => "li_server");
   $r->route('/server/reboot/:serverid')->to('server#reboot', active_li => "li_server");

   $r->route('/designer')->to('designer#index', active_li => "li_designer");

   $r->route('/rex/orders')->to('rex#orders');

   $r->route('/rex/server/list')->to(controller => 'rex-server', action => 'list');
   $r->route('/rex/server/list/:name')->to(controller => 'rex-server', action => 'list');
   $r->route('/rex/server/list/:type/:name')->to(controller => 'rex-server', action => 'list');

   $r->route('/rex/os/list')->to(controller => 'rex-os', action => 'list');
   $r->route('/rex/os/list/:name')->to(controller => 'rex-os', action => 'list');

   $r->route('/configuration')->to("configuration#index", active_li => "li_configuration");
   $r->route('/configuration/scm')->to("configuration#scm", active_li => "li_configuration");
   $r->route('/configuration/scm/update')->to("configuration#update_scm");

   # initialize database
   DM4P::setup(default => "MySQL://" 
                        . $config->{"db"}->{"server"}
                        . "/"
                        . $config->{"db"}->{"schema"}
                        . "?username="
                        . $config->{"db"}->{"user"}
                        . "&password="
                        . $config->{"db"}->{"password"});

   eval {
      my $db = DM4P::get_connection("default");
      $db->connect;

      DB::Model::System->set_data_source($db);
      DB::Model::Baseboard->set_data_source($db);
      DB::Model::Cpu->set_data_source($db);
      DB::Model::Dimm->set_data_source($db);
      DB::Model::NetworkDevice->set_data_source($db);
      DB::Model::NetworkDeviceConfiguration->set_data_source($db);
      DB::Model::Software->set_data_source($db);
      DB::Model::MemoryArray->set_data_source($db);
      DB::Model::Storage->set_data_source($db);
      DB::Model::RaidController->set_data_source($db);
      DB::Model::RaidShelf->set_data_source($db);
      DB::Model::RaidVolume->set_data_source($db);
      DB::Model::Scm->set_data_source($db);
   };

   if($@) {
      die("Can't connect to database.");
   }

   # initlialize rex
   user $config->{"rex"}->{"user"};
   require Rex::Stashy::Server::Commands;

   require Rex::Commands::DB;
   Rex::Commands::DB->import({
                        dsn => "DBI:mysql:database="
                                          . $config->{"db"}->{"schema"}
                                          . ";host="
                                          . $config->{"db"}->{"server"},
                        user => $config->{"db"}->{"user"},
                        password => $config->{"db"}->{"password"},
                     });

}

1;
