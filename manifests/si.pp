define drush::si ($profile = undef, $settings = undef, $options = undef) {

  exec {"drush-si-${name}":
    command => "drush si $profile $settings $options -y",
    cwd     => $sitepath,
  }

  if defined(Exec["drush-si-${name}"]) {
    Exec["drush-si-${name}"] {
      before  => Exec["drush-si-${name}"],
    }
  }
}
