define drush::dis () {
  exec {"drush-dis-${name}":
    command     => "drush dis ${name} -y",
    cwd         => $sitepath,
#    onlyif      => "drush -r ${sitepath} pmi ${name} | grep Status | grep disabled",
  }
}
