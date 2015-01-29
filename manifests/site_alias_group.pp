# Add an instance of an *.aliases.drushrc.php file
define drush::site_alias_group($name, $aliases = undef, $description = undef) {

  concat {"/etc/drush/${name}.aliases.drushrc.php":
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  concat::fragment {"drush-site-alias-{$name}":
    target => "/etc/drush/${name}.aliases.drushrc.php",
    content => template('drush/php.erb','drush/aliases.drushrc.erb'),
    order => 1,
    require => [
      File['/etc/drush'],
    ]
  }
}