define drush::cc ($cache = 'all',
                  $uri = undef,
                  $onlyif = 'test !',
                  $site_root = undef
                 )
{

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

	# Build the arguments for the command.
	if $site_root {
    validate_absolute_path($site_root)
    $siteroot = "--root=${site_root}"
  }

	if $uri {
    $u = "--l=${uri}"
  }

  exec {"drush-cc-${name}":
    command => "drush cc $cache $siteroot $u -y",
    onlyif => $onlyif,
    require => Exec['drush_status_check'],
  }
}
