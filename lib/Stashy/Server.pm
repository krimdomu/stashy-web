package Stashy::Server;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

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

1;