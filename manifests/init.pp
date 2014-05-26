class drush ($version = $::version) {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin", "${::composer_home}/vendor/bin" ] }
  package { ['zip', 'unzip']: ensure => present}

  composer::require {"drush_global":
    project_name => 'drush/drush',
    global => true,
    version => "6.*",
  }

  file {"/usr/bin/drush":
    ensure => 'link',
    target => "${::composer_home}/vendor/bin/drush",
    require => Composer::Require['drush_global'],
  }
}