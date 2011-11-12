package Stashy::Rex::Server;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

sub list {

   my $self = shift;
   my $name = $self->param("name");

   my $server;

   if($name) {
      $server = DB::Model::System->all( DB::Model::System->hostname % $name );
   }
   else {
      $server = DB::Model::System->all;
   }

   my @servers;
   while(my $srv = $server->next) {
      push @servers, $srv->get_data;
   }

   return $self->render_json(\@servers);

}

1;
