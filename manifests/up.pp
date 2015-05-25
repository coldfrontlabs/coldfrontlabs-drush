define drush::up () {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }

  drush::en {'update':}

  ->drush::cc {"drush-cc-for-up-${name}":args => 'drush'}

  ->exec {"drush-up":
    command     => "drush pm-update -y",
    cwd         => $sitepath,
    require     => Exec['drush_status_check'],
  }
}
