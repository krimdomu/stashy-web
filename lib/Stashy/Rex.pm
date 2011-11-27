package Stashy::Rex;
use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
use Cwd qw(getcwd realpath);

sub orders {
   my $self = shift;
   my $file = $self->param("file");

   if($file) {
      my $file_to_read = realpath(getcwd() . "/" . $self->stash->{"config"}->{"scm"}->{"checkout_to"} . "/" . $file);
      my $__config_scm_checkout_to = realpath(getcwd() . "/" . $self->stash->{"config"}->{"scm"}->{"checkout_to"});
      if($file_to_read =~ /^$__config_scm_checkout_to/ && -f $file_to_read) {
         my $file_content = eval { local(@ARGV, $/) = ($file_to_read); <>; };
         return $self->render_data($file_content);
      }

   }

   # always fall back to file listing
   $self->render_text($self->__list_orders_dir());
}


sub __list_orders_dir {
   my $self = shift;

   my $ret = "";

   my $pwd = getcwd;
   chdir($self->stash->{"config"}->{"scm"}->{"checkout_to"});
   my @dirs = (".");

   for my $dir (@dirs) {
      opendir(my $dh, $dir) or return "ERROR";
      while(my $entry = readdir($dh)) {
         next if $entry =~ /^\./;
         push @dirs, "$dir/$entry" if -d "$dir/$entry";
         my $p_dir = "$dir/$entry";
         $p_dir =~ s/^\.\///;

         $ret .= "$p_dir\n" if (-f $p_dir);
      }
      closedir($dh);
   }

   chdir($pwd);

   return $ret;
}



1;
