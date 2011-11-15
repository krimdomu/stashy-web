package Stashy::Rex;
use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
use Cwd qw(getcwd);

sub orders {
   my $self = shift;
   $self->render_text(__list_orders_dir());
}


sub __list_orders_dir {
   my $ret = "";

   my $pwd = getcwd;
   chdir($Stashy::SCM_CHECKOUT_PATH);
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
