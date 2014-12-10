define drush::dis ($project,
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

	# Build the arguments to the command.
	if $uri {
    $u = "--l=${uri}"
  }

  exec {"drush-dis-${name}":
    command     => "drush dis $project $u $siteroot -y",
    require => Exec['drush_status_check'],
  }
}
