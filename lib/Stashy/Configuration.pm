package Stashy::Configuration;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;
use Cwd qw(getcwd);

sub index {
   my $self = shift;
   $self->render;
}

sub scm {
   my $self = shift;

   my $scm_entry;
   $scm_entry = DB::Model::Scm->find(1);

   if($self->param("url") && $self->param("name")) {
      $self->stash("url", $self->param("url"));
      $self->stash("name", $self->param("name"));


      if($scm_entry) {
         $scm_entry->name = $self->param("name");
         $scm_entry->url  = $self->param("url");
         $scm_entry->update;
      }
      else {
         $scm_entry = DB::Model::Scm->new(
            name => $self->param("name"),
            url  => $self->param("url"),
         );
         $scm_entry->save;
      }
   }
   else {
      if($scm_entry) {
         $self->stash("url", $scm_entry->url);
         $self->stash("name", $scm_entry->name);
      }
   }

   $self->render;
}

sub update_scm {
   my $self = shift;
   my $scm_entry = DB::Model::Scm->find(1);

   my $cwd= getcwd;
   chdir($Stashy::SCM_CHECKOUT_PATH);
   if(-d ".git") {
      system("git pull >/dev/null 2>&1");
   }
   else {
      system("git clone " . $scm_entry->url . " . >/dev/null 2>&1");
   }
   chdir($cwd);

   $self->render_json({retcode => $?});
}



1;
