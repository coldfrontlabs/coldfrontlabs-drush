define drush::uninstall () {
  include drush
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin", $::composer_home ] }

  drush::dis {"${name}":}
  ->exec {"drush-uninstall-${name}":
    command     => "drush pm-uninstall ${name} -y",
    cwd         => $sitepath,
  }
}
