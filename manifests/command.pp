define drush::command ($args = '') {

  drush::cc {"drush-cc-for-command-${name}":args => 'drush'}

  ->exec {"drush-command-${name}":
    command => "drush ${name} $args -y",
    cwd     => $sitepath,
  }
}
