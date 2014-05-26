define drush::dis () {
  include drush
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

  exec {"drush-dis-${name}":
    command     => "drush dis ${name} -y",
    cwd         => $sitepath,
#    onlyif      => "drush -r ${sitepath} pmi ${name} | grep Status | grep disabled",
  }
}
