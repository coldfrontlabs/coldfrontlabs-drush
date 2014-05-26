class drush ($version = $::version) {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin", $::composer_home ] }
  package { ['zip', 'unzip']: ensure => present}

    include composer

#    file {'/tmp/drushme':
#      mode => '0755',
#      ensure => 'directory'
#    }

    composer::require {"drush_global":
      project_name => 'drush/drush',
      global => true,
      version => "6.*",
    }
#    ->
#    exec {'drush-env-refresh':
#      command => 'bash',
#    }->
#    exec {'drush-status-check':
#      command => 'drush status',
#    }
}