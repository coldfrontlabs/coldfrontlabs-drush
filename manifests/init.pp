class drush ($version = $::version) {
  include composer

  class {'composer':
    provider => 'drush/drush:${version}',
    ensure => present,
    require => Package[php-cli],
  }
}
