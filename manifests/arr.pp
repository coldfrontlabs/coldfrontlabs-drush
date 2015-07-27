define drush::arr ($file,
                  $sitename = undef,
                  $destination,
                  $db_prefix = undef,
                  $db_su = undef,
                  $db_su_pw = undef,
                  $db_url = undef,
                  $overwrite = false,
                  $tar_options = false,
) {
  validate_bool($overwrite)
  validate_string($sitename)
	validate_absolute_path($file)
	validate_absolute_path($destination)

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }

	# Build the arguments for the command.

  $dest = "--destination=${dest}"

  if $db_prefix {
    $dbprefix = "--db-prefix=${db_prefix}"
  }

  if $db_su {
    $dbsu = "--db-su=${db_su}"
  }

  if $db_su_pw {
    $dbsupw = "--db-su-pw=${db_su_pw}"
  }

  if $db_url {
    $dburl = "--db-url=${db_url}"
  }

  if $overwrite {
    $ovr = "--overwrite"
  }

  if $tar_options {
    $tar = "--db-prefix=${tar_options}"
  }

  exec {"drush-sa-${name}":
    command => "drush archive-restore $file $sitename $dest $dbprefix $dbsu $dbsupw $dburl $ovr $tar -y",
    require => [
      File["${file}"],
    ]
  }
}
