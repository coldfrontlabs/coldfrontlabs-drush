Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }

class drush (
  $version = '6.*',
  $drush_cmd = $::drush::params::drush_cmd,
  $composer_home = $::drush::params::composer_home
  ) inherits ::drush::params {


#  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }
  ensure_packages(['zip', 'unzip', 'gzip', 'tar', 'bash-completion'])

  file {"${composer_home}":
    ensure => 'directory',
  }

  class { 'composer':
    logoutput       => true,
    composer_home   => $composer_home,
    require         => File["${composer_home}"],
  }

  if str2bool("$hasdrush") {
    file {"${drush_cmd}":
      ensure => 'link',
      target => "${composer_home}/vendor/bin/drush",
    }
  } else {
    composer::require {"drush_global":
      project_name => 'drush/drush',
      global => true,
      version => "${version}",
      require => Class['composer'],
    }
    -> file {"${drush_cmd}":
      ensure => 'link',
      target => "${composer_home}/vendor/bin/drush",
      require => Composer::Require['drush_global'],
    }
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
  }

  file {'/etc/bash_completion.d/drush.complete.sh':
    ensure => 'link',
    owner => 'root',
    target => "${composer_home}/vendor/drush/drush/drush.complete.sh",
    require => [
      Package['bash-completion'],
      Exec['drush_status_check'],
    ],
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
