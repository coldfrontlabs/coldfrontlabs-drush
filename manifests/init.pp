
# Installs Drush Launcher.
class drush (
  String $launcher_version = '2.0.0'
) {


  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin'] }

  ensure_packages(['zip', 'unzip', 'gzip', 'tar', 'bash-completion'])

  # Download Drush launcher
  $version_actual = $launcher_version
  $drush_cmd = '/usr/bin/drush'

  # Drush launcher is not compatible with drush 12 so we need to use a different launcher packaged with this module.
  # exec{'drush-global-download':
  #   command => "/usr/bin/wget -O ${drush_cmd} https://github.com/drush-ops/drush-launcher/releases/download/${version_actual}/drush.phar",
  #   creates => $drush_cmd,
  #   returns => [0],
  #   require => Package['wget'],
  # }

  file {$drush_cmd:
    ensure  => 'present',
    mode    => '+rx',
    source  => "puppet:///modules/drush/drush-launcher",
  }

  file {'/etc/drush':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File[$drush_cmd],
  }

  # Add global commands directory
  file {'/etc/drush/commands':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/etc/drush'],
  }

  # Build global drush.ini file
  $options = hiera_hash('drush::ini', {})

  file { 'drush-ini-config':
    path    => '/etc/drush/drush.ini',
    content => template('drush/ini.erb', 'drush/drush.ini.erb'),
    mode    => '0644',
    require => File['/etc/drush'],
  }
}
