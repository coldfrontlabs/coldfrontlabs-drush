# Class: drush::params
#
# This class manages Drush parameters
#
# Parameters:
# - The $verion that Drush runs as
# - The $drush_cmd actual drush command location
# - The $composer_home is the location of composer
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class drush::params {
  $drush_release_url = "https://github.com/drush-ops/drush/releases/download"

if $::operatingsystem == 'Ubuntu' or $::osfamily == 'Debian' {
    $drush_cmd = '/usr/bin/drush'
  } elsif $::osfamily == 'RedHat' {
    $drush_cmd = '/usr/bin/drush'
    case $::operatingsystemmajrelease {
      '7': {

      }
      default: {
        include epel
      }
    }
  } elsif $::osfamily == 'FreeBSD' {
    $drush_cmd = '/usr/local/bin/drush'
  }
}
