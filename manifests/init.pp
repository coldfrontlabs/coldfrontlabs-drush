class drush ($version = $::version) {
  package { ['zip', 'unzip']: ensure => present}

  if $hasdrush == 'not-installed' {
    include composer

    file {'/tmp/drushme':
      mode => '0755',
      ensure => 'directory'
    }

    file {'/tmp/drushme/composer.json':
      content => '{"name":"drushme","require":{"php":">=5.3.0"},"config":{"bin-dir":"/usr/local/bin","vendor-dir":"/usr/local/share/composer"},"require":{"drush/drush":">=6"}}',
      require => File['/tmp/drushme'],
      mode => '0644',
      ensure => 'present',
    }

    composer::exec {'install-drush':
      cmd => 'install',
      cwd => '/tmp/drushme',
      require => File['/tmp/drushme/composer.json'],
    }
    ->exec {'drush_status':
      command => 'drush status',
      path => ['/usr/local/bin'],
    }
  }
}