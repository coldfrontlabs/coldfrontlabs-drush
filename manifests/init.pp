class drush ($version = $::version) {
  include composer

  composer::requirepack {'drush/drush:${version}':
      cwd                  => '/usr/local/bin', # REQUIRED
      global               => true,  # Add global requirement
  }
}
