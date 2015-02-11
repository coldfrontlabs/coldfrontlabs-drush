define drush::updatedb ($uri = undef,
                  $site_root = undef,
                  $onlyif = 'test !',
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

  exec {"drush-updb-${name}":
    command => "drush updb $siteroot $u -y",
    cwd     => $site_root,
    onlyif  => $onlyif,
    timeout => 0,
    require => [
      Exec['drush_status_check'],
    ]
  }
}
