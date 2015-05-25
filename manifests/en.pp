define drush::en ($project_name = undef,
                  $uri = undef,
                  $site_root = undef,
                  $onlyif = 'test !',
                 )
{

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }

	# Build the arguments for the command.
	if $site_root {
    validate_absolute_path($site_root)
    $siteroot = "--root=${site_root}"
  }

  if !$project_name {
    $project_name = $name
  }

	# Build the arguments to the command.
	if $uri {
    $u = "--l=${uri}"
  }

  exec {"drush-en-${name}":
    command     => "drush en $project_name $u $siteroot -y",
    onlyif => $onlyif,
    # @todo add a check here that the module is not enabled. That way
    # puppet doesn't constantly run drush en and clear the drupal cache
    require => Exec['drush_status_check'],
  }
}
