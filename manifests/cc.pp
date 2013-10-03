define drush::cc ($args = 'all') {
  exec {"drush-cc-${name}":
    command => "drush cc $args -y",
    cwd     => $sitepath,
  }
}
