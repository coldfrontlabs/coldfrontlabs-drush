
class drush (
  $version = '8.*',
  $drush_cmd = $::drush::params::drush_cmd,
  $composer_home = $::drush::params::composer_home,
  $composer_bin_dir = $::drush::params::composer_bin_dir
  ) inherits ::drush::params {


  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }

  ensure_packages(['zip', 'unzip', 'gzip', 'tar', 'bash-completion'])

  file {"${composer_home}":
    ensure => 'directory',
  }

  class { '::composer':
    command_name => 'composer',
    target_dir   => $composer_home,
    auto_update => true,
    download_timeout => '100',
    require      => File["${composer_home}"],
  }

  if str2bool("$hasdrush") {
    file {"${drush_cmd}":
      ensure => 'link',
      target => "${composer_bin_dir}/drush",
    }
  } else {
    exec {"drush_global":
      command => 'composer global require drush/drush${version}',
      cwd => $composer_home,
      require => Class['composer'],
    }
    -> file {"${drush_cmd}":
      ensure => 'link',
      target => "${composer_bin_dir}/drush",
      require => Exec['drush_global'],
    }
    -> exec{"drush-global-status":
      command => "drush status",
      cwd => "${composer_home}",
      require => File["${drush_cmd}"],
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

  file {'/etc/bash_completion.d/drush.complete.sh':
    ensure => 'link',
    owner => 'root',
    target => "${composer_bin_dir}/drush.complete.sh",
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
