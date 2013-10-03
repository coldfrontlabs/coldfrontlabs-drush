define drush::uninstall () {
  drush::dis {"${name}":}
  ->exec {"drush-uninstall-${name}":
    command     => "drush pm-uninstall ${name} -y",
    cwd         => $sitepath,
  }
}
