class drush ($version = '6.*', $drush_cmd = '/usr/bin/drush', $composer_home = '/usr/local/share/composer') {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }
  package { ['zip', 'unzip', 'gzip', 'tar']: ensure => present}

  file {"${composer_home}":
    ensure => 'directory',
  }

  class { 'composer':
    logoutput       => true,
    composer_home   => $composer_home,
    require         => File['/usr/local/share/composer'],
  }

  composer::require {"drush_global":
    project_name => 'drush/drush',
    global => true,
    version => "${version}",
    require => Class['composer'],
  }
  ->
  file {"${drush_cmd}":
    ensure => 'link',
    target => "${composer_home}/vendor/bin/drush",
    require => Composer::Require['drush_global'],
  }
  -> exec {'drush_status_check':
    command => 'drush status',
    require => File["${drush_cmd}"],
  }
}