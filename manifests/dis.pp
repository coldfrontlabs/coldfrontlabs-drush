define drush::dis ($project_name = undef,
                   $site_root = undef,
                   $uri = undef
                  )
{

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

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

  exec {"drush-dis-${name}":
    command     => "drush dis $project_name $u $siteroot -y",
    # @todo add a check here that the module is enabled. That way
    # puppet doesn't constantly run drush dis and clear the drupal cache
    require => Exec['drush_status_check'],
  }
}
