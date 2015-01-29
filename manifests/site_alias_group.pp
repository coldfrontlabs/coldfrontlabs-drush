# Add an instance of an *.aliases.drushrc.php file
define drush::site_alias_group($name, $aliases = undef, $description = undef) {

  file {"/etc/drush/${name}.aliases.drushrc.php":
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('drush/php.erb','drush/aliases.drushrc.erb'),
    require => [
      File['/etc/drush'],
    ]
  }
}