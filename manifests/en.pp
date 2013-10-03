define drush::en () {
  exec {"drush-en-${name}":
    command     => "drush en ${name} -y",
    cwd         => $sitepath,
#    onlyif      => "drush -r ${sitepath} pmi ${name} | grep Status | grep enabled",
  }
}
