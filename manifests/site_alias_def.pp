# Add an instance of an *.aliases.drushrc.php file
define drush::site_alias_def($group, $uri = undef, $remote_user = undef, $remote_host = undef, $os = undef, $db_url = undef) {

  concat::fragment {"drush-site-alias-def-{$name}-{$group}":
    target => "/etc/drush/${group}.aliases.drushrc.php",
    content => template('drush/aliases.drushrc.erb'),
    require => [
      File['/etc/drush'],
      Drush::Site_alias_group["drush-site_alias_group-${group}"],
    ]
  }
}