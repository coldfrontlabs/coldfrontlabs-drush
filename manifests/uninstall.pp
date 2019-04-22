define drush::uninstall () {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }

  drush::dis {"${name}":}
  ->exec {"drush-uninstall-${name}":
    command     => "drush pm-uninstall ${name} -y",
    cwd         => $sitepath,
    require     => Exec['drush-global-download'],
  }
}
