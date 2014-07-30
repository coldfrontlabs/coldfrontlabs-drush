# Add an instance of an *.aliases.drushrc.php file
define drush::site_alias_file($name, $group, $uri = undef, $remote_user = undef, $remote_host = undef, $os = undef) {

  file {"/etc/drush/${name}.aliases.drushrc.php":
    ensure => 'file',
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('drush/aliases.drushrc.php.erb'),
    require => [
      File['/etc/drush'],
      Drush::Site_alias_group["drush-site_alias_group-${group}"],
    ]
  }
}