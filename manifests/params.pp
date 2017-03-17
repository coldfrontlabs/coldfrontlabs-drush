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

  if $::operatingsystem == 'Ubuntu' or $::osfamily == 'Debian' {
    $drush_cmd = '/usr/bin/drush'
    $composer_home = '/usr/local/bin'
    $composer_bin_dir = '/root/.config/vendor/bin'
  } elsif $::osfamily == 'RedHat' {
    $composer_home = '/usr/local/bin'
    $drush_cmd = '/usr/bin/drush'
    $composer_bin_dir = '/root/.config/vendor/bin'
    case $::operatingsystemmajrelease {
      '7': {

      }
      default: {
        include epel
      }
    }
  } elsif $::osfamily == 'FreeBSD' {
    $drush_cmd = '/usr/local/bin/drush'
    $composer_home = '/usr/local/bin'
    $composer_bin_dir = '/root/.config/vendor/bin'
  }
}
