define drush::command ($args = '') {
  include drush
  drush::cc {"drush-cc-for-command-${name}":args => 'drush'}

  ->exec {"drush-command-${name}":
    command => "drush ${name} $args -y",
    cwd     => $sitepath,
  }
}
