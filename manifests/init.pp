class drush ($version = '6.*') {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }
  package { ['zip', 'unzip']: ensure => present}

  file {'/usr/local/share/composer':
    ensure => 'directory',
  }

  class { 'composer':
    composer_home   => '/usr/local/share/composer',
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
    target => "${::composer_home}/vendor/bin/drush",
    require => Composer::Require['drush_global'],
  }
}