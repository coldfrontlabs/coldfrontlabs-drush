class drush ($version = $::version) {
  class {'composer':
    provider => 'wget', # @todo make this check if php-composer is available
    require => Package[php-cli],
    before => Exec['drush/drush:${version}'],
  }

  exec {'drush/drush:${version}':
    command     => "composer global require ${title} --quiet",
    unless => "drush --version | grep -c 'version'",
    }->
  exec{'set-composer-path':
    command => "sed -i '1i export PATH=\"$HOME/.composer/vendor/bin:$PATH\"' $HOME/.bashrc"
  }
}
