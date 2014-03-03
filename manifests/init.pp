class drush ($version = $::version) {
  include composer

  if ($version) {
    # Do nothing
  } else {
    $version = '6.x'
  }

  class {'composer':
    provider => 'drush/drush:${version}',
    ensure => present,
    require => Package[php-cli],
  }
}
