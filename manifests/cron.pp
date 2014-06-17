define drush::cron ($site_root) {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

	# Build the arguments to the command.
	if $site_root {
    $root_arg = "--root=${site_root}"
  }

  exec {"drush-si-${name}":
    command => "drush $root_arg cron -y",
    cwd     => $site_root,
    timeout => 0,
  }
}
