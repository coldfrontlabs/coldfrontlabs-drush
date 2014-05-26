define drush::en () {
  include drush
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin", $::composer_home ] }

  exec {"drush-en-${name}":
    command     => "drush en ${name} -y",
    cwd         => $sitepath,
#    onlyif      => "drush -r ${sitepath} pmi ${name} | grep Status | grep enabled",
    require => Composer::Require['drush_global'],
  }
}
