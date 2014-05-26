define drush::cc ($args = 'all') {
  include drush
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin", $::composer_home ] }

  exec {"drush-cc-${name}":
    command => "drush cc $args -y",
    cwd     => $sitepath,
  }
}
