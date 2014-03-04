class drush ($version = $::version) {
  include composer

  composer::requirepack {'drush/drush:${version}':
      project_name => 'drush/drush:6.*',
      cwd                  => '/usr/local/bin', # REQUIRED
      global               => true,  # Add global requirement
  }
}
