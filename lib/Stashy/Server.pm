package Stashy::Server;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;
use Rex::Task;

sub get_information {
   my $self = shift;

   my $server = DB::Model::System->all( DB::Model::System->id == $self->param("serverid") )->next;
   my $base_board = $server->Baseboards->next;
   my $cpus = $server->Cpus;
   my $dimms = $server->Dimms;
   my $eths  = $server->NetworkDevices;

   $self->render(server => $server, 
                  base_board => $base_board,
                  dimms => $dimms,
                  eths  => $eths,
                  cpus => $cpus);
}

sub index {
   my $self = shift;

   my $server = DB::Model::System->all( DB::Model::System->id == $self->param("serverid") )->next;
   my $base_board = $server->Baseboards->next;
   my $cpus = $server->Cpus;
   my $dimms = $server->Dimms;
   my $eths  = $server->NetworkDevices;
   my $raidctrl = $server->RaidControllers;

   $self->render(server => $server, 
                  base_board => $base_board,
                  dimms => $dimms,
                  eths  => $eths,
                  cpus => $cpus,
                  raid_controller => $raidctrl);

}

sub software {
   my $self = shift;

   my $server    = DB::Model::System->all( DB::Model::System->id == $self->param("serverid") )->next;
   my $software  = $server->Software->order("name")->asc();

   $self->render(server => $server, 
                  software => $software);

}

sub deploy {
   my $self = shift;

   my $server = DB::Model::System->all( DB::Model::System->id == $self->param("serverid") )->next;
}

sub reboot {
   my $self = shift;

   my $server = DB::Model::System->all( DB::Model::System->id == $self->param("serverid") )->next;

#   Rex::Task->run("Stashy:Server:Commands:reboot", $server->hostname . "." . $server->domainname);

   $self->render(server => $server);
}

# add a new system
sub add {
   my $self = shift;
   my $server = $self->tx->remote_address;

   Rex::Task->run("Stashy:Server:Commands:inventory", $server);

   $self->render_json({retcode => 0});
}

1;
