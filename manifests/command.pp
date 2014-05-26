define drush::command ($args = '') {
  include drush
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin", $::composer_home ] }

  drush::cc {"drush-cc-for-command-${name}":args => 'drush'}

  ->exec {"drush-command-${name}":
    command => "drush ${name} $args -y",
    cwd     => $sitepath,
  }
}
