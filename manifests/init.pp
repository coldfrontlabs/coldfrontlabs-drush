class drush ($version = $::version) {
  if ($hasdrush == '') {
    include composer

    file {'/tmp/drushme':
      type => 'directory',
    }

    file {'/tmp/drushme/composer.json':
      type => 'file',
      content => '{"name":"drushme","require":{"php":">=5.3.0"},"config":{"bin-dir":"/usr/local/bin","vendor-dir":"/usr/local/share/composer"},"require":{"drush/drush":">=6"}}',
      require => File['/tmp/drushme'],
    }

    composer::exec {'install-drush':
      cmd => 'install',
      cwd => '/tmp/drushme',
      require => File['/tmp/drushme/composer.json'],
    }
  }
}
