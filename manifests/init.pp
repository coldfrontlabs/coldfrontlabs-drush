class drush ($version = '6.*', $composer_home = '/usr/local/share/composer') {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }
  package { ['zip', 'unzip']: ensure => present}

  file {"${composer_home}":
    ensure => 'directory',
  }

  class { 'composer':
    target_dir      => '/usr/local/bin',
    composer_file   => 'composer', # could also be 'composer.phar'
    download_method => 'curl',     # or 'wget'
    logoutput       => true,
    tmp_path        => '/tmp',
    php_bin         => 'php', # could also i.e. be 'php -d "apc.enable_cli=0"' for more fine grained control
    suhosin_enabled => true,

    composer_home   => $composer_home,
    require         => File['/usr/local/share/composer'],
  }

  composer::require {"drush_global":
    project_name => 'drush/drush',
    global => true,
    version => "${version}",
    require => Class['composer'],
  }

  file {"/usr/bin/drush":
    ensure => 'link',
    target => "${composer_home}/vendor/bin/drush",
    require => Composer::Require['drush_global'],
  }
}