define drush::arr ($filename,
                  $sitename = undef,
                  $destination,
                  $db_prefix = undef,
                  $db_su = undef,
                  $db_su_pw = undef,
                  $db_url = undef,
                  $overwrite = false,
                  $tar_options = false,
                  $onlyif = 'test !'
) {
  validate_bool($overwrite)
  validate_string($sitename)
	validate_absolute_path($filename)
	validate_absolute_path($destination)

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }

	# Build the arguments for the command.

  $dest = "--destination=${destination}"

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

    if $db_url =~ /^pgsql:/ {
      ensure_packages(['php-pgsql'], {'ensure' => 'installed'})
      $db_require = Php::Extension['pgsql']
    } else {
      ensure_packages(['php-mysql'], {'ensure' => 'installed'})
      $db_require = Php::Extension['mysql']
    }
  }

  if $overwrite {
    $ovr = "--overwrite"
  }

  if $tar_options {
    $tar = "--db-prefix=${tar_options}"
  }

  exec {"drush-arr-${name}":
    command => "drush archive-restore ${filename} ${sitename} ${dest} ${dbprefix} ${dbsu} ${dbsupw} ${dburl} ${ovr} ${tar} -y",
    onlyif  => $onlyif,
    creates => "${destination}/index.php",
    timeout => 0,
    require => [
      Exec['drush_status_check'],
      Class['php::cli'],
      Php::Extension['mbstring'],
      Php::Extension['pdo'],
      Php::Extension['process'],
      Php::Extension['xml'],
      Php::Extension['gd'],
      $db_require,
    ],
  }
}
