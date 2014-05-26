define drush::uninstall () {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

  drush::dis {"${name}":}
  ->exec {"drush-uninstall-${name}":
    command     => "drush pm-uninstall ${name} -y",
    cwd         => $sitepath,
  }
}
