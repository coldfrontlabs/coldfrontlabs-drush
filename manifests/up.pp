define drush::up () {
  include drush
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

  drush::en {'update':}

  ->drush::cc {"drush-cc-for-up-${name}":args => 'drush'}

  ->exec {"drush-up":
    command     => "drush pm-update -y",
    cwd         => $sitepath,
  }
}
