define drush::cron ($site_root = undef) {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

	# Build the arguments to the command.
	if $site_root {
    $siteroot = "--root=${site_root}"
  }

  exec {"drush-si-${name}":
    command => "drush $siteroot cron -y",
    timeout => 0,
  }
}
