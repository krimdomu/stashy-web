package Stashy;
use Mojo::Base 'Mojolicious';

use DM4P;
use DM4P::Connection::Server::MySQL;
use DM4P::DM;

use DB::Model::System;
use DB::Model::Baseboard;
use DB::Model::Cpu;
use DB::Model::Dimm;
use DB::Model::NetworkDevice;
use DB::Model::NetworkDeviceConfiguration;

DM4P::setup(default => "MySQL://localhost/stashy?username=stashy&password=stashy");
my $db;

eval {
   $db = DM4P::get_connection("default");
   $db->connect;

   DB::Model::System->set_data_source($db);
   DB::Model::Baseboard->set_data_source($db);
   DB::Model::Cpu->set_data_source($db);
   DB::Model::Dimm->set_data_source($db);
   DB::Model::NetworkDevice->set_data_source($db);
   DB::Model::NetworkDeviceConfiguration->set_data_source($db);
};

if($@) {
   die("Can't connect to database.");
}


# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc" (this plugin requires Perl 5.10)
  $self->plugin('pod_renderer');

  # Routes
  my $r = $self->routes;

  # Normal route to controller
  $r->route('/')->to('dashboard#index');

  $r->route('/server/get_information/:serverid')->to('server#get_information');
}

1;
