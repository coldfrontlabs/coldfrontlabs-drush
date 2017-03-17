
class drush (
  $version = '8.1.10',
  $drush_cmd = $::drush::params::drush_cmd,
  $drush_release_url = $::drush::params::drush_release_url
  ) inherits ::drush::params {


  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }

  ensure_packages(['zip', 'unzip', 'gzip', 'tar', 'bash-completion'])

  $drush_dl_url = "${drush_release_url}/${version}/drush.phar"


  exec{'drush-global-download':
    command => "/usr/bin/wget -q ${drush_dl_url} -O ${drush_cmd}",
    creates => "${drush_cmd}",
    require => Package['wget'],
  }

  file {"${drush_cmd}":
    ensure => 'present',
    mode => '+x',
    require => Exec['drush-global-download'],
  }
  -> exec{"drush-global-status":
    command => "drush status",
  }
  -> exec{"drush-global-init":
    command => "drush init",
  }

  file {"/etc/drush":
    ensure => 'directory',
    owner => 'root',
    group => 'root',
    mode => '0755',
    require => File["${drush_cmd}"],
  }
  -> exec {'drush_status_check':
    command => 'drush status',
    require => File["${drush_cmd}"],
    refreshonly => 'true',
  }

  # Add global commands directory
  file {"/etc/drush/commands":
    ensure => 'directory',
    owner => 'root',
    group => 'root',
    mode => '0755',
    require => File["/etc/drush"],
  }

  # Files for controlling requests during drush make operations
  file {"drush-make-exist-curlrc":
    ensure => 'present',
    path => "${::root_home}/.curlrc"
  }

  file {"drush-make-exist-wgetrc":
    ensure => 'present',
    path => "${::root_home}/.wgetrc"
  }

  # Files for controlling requests during drush make operations
  file {"drush-dir-exist":
    ensure => 'directory',
    path => "${::root_home}/.drush"
  }

  file {"drush-root-drushrc":
    ensure => 'present',
    path => "${::root_home}/.drush/drushrc.php",
    content => template('drush/php.erb'),
    replace => 'no',
  }

  # Build site aliase files
  $groups = hiera_hash('drush::site_alias_group', {})
  create_resources(drush::site_alias_group, $groups)

  # Build global drush.ini file
  $options = hiera_hash('drush::ini', {})

  file { 'drush-ini-config':
    path    => "/etc/drush/drush.ini",
    content => template('drush/ini.erb', 'drush/drush.ini.erb'),
    mode    => '0644',
    require => File["/etc/drush"],
  }

  # Build drushrc.php files
  $rcs = hiera_hash('drush::drushrc', {})
  create_resources(drush::drushrc, $rcs)

  # Build policy.drushrc.php file
  $policies = hiera_hash('drush::policies', {})
  create_resources(drush::policy, $policies)
}
