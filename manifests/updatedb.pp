define drush::updatedb () {
  include drush
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

  drush::cc {"drush-cc-for-updatedb-${name}":args => 'drush'}
  ->exec {"drush-updatedb":
    command     => "drush cc drush && drush updatedb -y",
    cwd         => $sitepath,
  }
}
