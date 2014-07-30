# Add an instance of an *.aliases.drushrc.php file
define drush::site_alias_group($name, $description = undef) {

  file {"/etc/drush/${name}.aliases.drushrc.php":
    ensure => 'file',
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('drush/php.erb'),
    require => [
      File['/etc/drush'],
    ]
  }
}