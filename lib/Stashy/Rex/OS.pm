package Stashy::Rex::Os;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

sub list {

   my $self = shift;
   my $name = $self->param("name");

   my $oss;

   if($name) {
      $oss = DB::Model::System->all( DB::Model::System->os % $name )->group("#os");
   }
   else {
      $oss = DB::Model::System->all->group("#os");
   }

   my @oss;
   while(my $os = $oss->next) {
      push @oss, $os->os;
   }

   return $self->render_json(\@oss);

}

1;

