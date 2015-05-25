define drush::cron ($uri = undef,
                    $onlyif = 'test !',
                    $site_root = undef
                    )
{

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }

	# Build the arguments for the command.
	if $site_root {
    validate_absolute_path($site_root)
    $siteroot = "--root=${site_root}"
  }

	if $uri {
    $u = "--l=${uri}"
  }

  exec {"drush-si-${name}":
    command => "drush cron $siteroot $u -y",
    onlyif => $onlyif,
    timeout => 0,
  }
}
