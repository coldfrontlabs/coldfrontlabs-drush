class drush ($version = $::version) {
  class {'composer':
    provider => 'wget', # @todo make this check if php-composer is available
    require => Package[php-cli],
    before => Composer::Project['drush/drush:${version}'],
  }

  composer::project {'drush/drush:${version}':
    ensure => 'present',
    global => true,
    require_proj => true,
    target => '/usr/local/drush',
    dev => false,
  }
}
