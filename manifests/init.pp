class drush ($version = $::version) {
  class { 'composer':
      target_dir      => '/usr/local/bin',
      composer_file   => 'composer', # could also be 'composer.phar'
      download_method => 'curl',     # or 'wget'
      logoutput       => false,
      tmp_path        => '/tmp',
#      php_package     => 'php5-cli',
#      curl_package    => 'curl',
#      wget_package    => 'wget',
      composer_home   => '/root',
#      php_bin         => 'php', # could also i.e. be 'php -d "apc.enable_cli=0"' for more fine grained control
#      suhosin_enabled => true,
  }


  composer::require {'drush/drush:${version}':
      project_name         => 'drush/drush:6.*',
      target_dir           => '/usr/local/bin', # REQUIRED
      global               => true,  # Add global requirement
  }
}
