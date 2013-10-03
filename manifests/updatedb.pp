define drush::updatedb () {
  drush::cc {"drush-cc-for-updatedb-${name}":args => 'drush'}
  ->exec {"drush-updatedb":
    command     => "drush cc drush && drush updatedb -y",
    cwd         => $sitepath,
  }
}
