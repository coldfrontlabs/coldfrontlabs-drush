define drush::cron ($site_root = undef) {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

	# Build the arguments for the command.
	if validate_absolute_path($site_root) {
    $siteroot = "--root=${site_root}"
  }

  exec {"drush-si-${name}":
    command => "drush $siteroot cron -y",
    timeout => 0,
  }
}
