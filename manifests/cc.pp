define drush::cc ($args = 'all') {
  include drush
  exec {"drush-cc-${name}":
    command => "drush cc $args -y",
    cwd     => $sitepath,
  }
}
