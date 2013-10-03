define drush::up () {
  drush::en {'update':}

  ->drush::cc {"drush-cc-for-up-${name}":args => 'drush'}

  ->exec {"drush-up":
    command     => "drush pm-update -y",
    cwd         => $sitepath,
  }
}
