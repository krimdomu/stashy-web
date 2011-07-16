package Stashy::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(message => 'Welcome to the Mojolicious Web Framework!');
}

1;
