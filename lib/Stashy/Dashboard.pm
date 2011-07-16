package Stashy::Dashboard;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub index {
   my $self = shift;

   my $servers = DB::Model::System->all()->order("added")->desc()->limit(4);

   $self->render(servers => $servers);
}

sub search {
   my $self = shift;

   my $search_name = "%" . $self->param("servername") . "%";
   my $servers = DB::Model::System->all( DB::Model::System->hostname % $search_name )->order("hostname")->asc();

   $self->render(servers => $servers);
}

1;
