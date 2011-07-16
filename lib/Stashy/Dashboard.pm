package Stashy::Dashboard;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub index {
   my $self = shift;

   my $servers = DB::Model::System->all()->order("added")->desc()->limit(4);

   $self->render(servers => $servers);
}

1;
