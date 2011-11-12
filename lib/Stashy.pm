package Stashy;
use Mojo::Base 'Mojolicious';

use Rex;
use Rex::Config;
use Rex::Commands;
use Rex::Stashy::Server::Commands;


#################################
# DATABASE ACCESS
my $server   = "localhost";
my $db       = "stashy";
my $username = "stashy";
my $password = "stashy";

# SERVER ACCESS
user "root";
# password "";
# pass_auth;
#
# public_key "/path/to/pub.key";
# private_key "/path/to/private.key";
#################################


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


DM4P::setup(default => "MySQL://$server/$db?username=$username&password=$password");

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
};

if($@) {
   die("Can't connect to database.");
}


# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc" (this plugin requires Perl 5.10)
  $self->plugin('PODRenderer');

  # Routes
  my $r = $self->routes;

  # Normal route to controller
  $r->route('/')->to('dashboard#index', active_li => "li_dashboard");
  $r->route('/search/:servername')->to('dashboard#search', active_li => "li_dashboard");

  $r->route('/server/:serverid')->to('server#index', active_li => "li_server");

  $r->route('/server/get_information/:serverid')->to('server#get_information');
  $r->route('/server/software/:serverid')->to('server#software', active_li => "li_server");
  $r->route('/server/reboot/:serverid')->to('server#reboot', active_li => "li_server");

  $r->route('/designer')->to('designer#index', active_li => "li_designer");

  $r->route('/rex/server/list')->to(controller => 'rex-server', action => 'list');
  $r->route('/rex/server/list/:name')->to(controller => 'rex-server', action => 'list');
  $r->route('/rex/server/list/:type/:name')->to(controller => 'rex-server', action => 'list');

  $r->route('/rex/os/list')->to(controller => 'rex-os', action => 'list');
  $r->route('/rex/os/list/:name')->to(controller => 'rex-os', action => 'list');

   $r->route('/configuration')->to("configuration#index", active_li => "li_configuration");

}

1;
