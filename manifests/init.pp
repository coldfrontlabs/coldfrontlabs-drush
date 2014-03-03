class drush () {
  include composer

  class {'composer':
    provider => 'drush/drush:6.*',
    ensure => present,
    require => Package[php-cli],
  }
}
