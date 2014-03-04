class drush ($version = $::version) {
  include composer

  composer::requirepack {'drush/drush:${version}':
      cwd                  => '/usr/local/bin', # REQUIRED
      global               => true,  # Add global requirement
      prefer_source        => false,
      prefer_dist          => false,
      dry_run              => false, # Just simulate actions
      custom_installers    => false, # No custom installers
      scripts              => false, # No script execution
      interaction          => false, # No interactive questions
      optimize             => false, # Optimize autoloader
      dev                  => false, # Install dev dependencies
}
