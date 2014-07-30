# Add an instance of an *.aliases.drushrc.php file
define drush::site_alias_file($name, $uri = undef, $remote_user = undef, $remote_host = undef, $os = undef, $group = undef) {

  file {"/etc/drush/${name}.aliases.drushrc.php":
    ensure => 'file',
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => tempalte('drush/aliases.drushrc.php.erb'),
    require => [
      File['/etc/drush'],
    ]
  }
}