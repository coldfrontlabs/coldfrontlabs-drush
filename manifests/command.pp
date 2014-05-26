define drush::command ($args = '') {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

  drush::cc {"drush-cc-for-command-${name}":args => 'drush'}

  ->exec {"drush-command-${name}":
    command => "drush ${name} $args -y",
    cwd     => $sitepath,
    require => Exec['drush_status_check'],
  }
}
