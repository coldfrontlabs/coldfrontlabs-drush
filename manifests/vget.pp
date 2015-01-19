# Drush Variable Get
define drush::vget ($variable = undef,
                  $exact = false,
                  $format = undef,
                  $pipe = false,
                  $uri = undef,
                  $site_root,
                  $onlyif = 'test !'
                )
{

	validate_absolute_path($site_root)

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

  if $variable {
    $v = "${variable}"
  }

  if $format {
    $f = "--format=${format}"
  }

  if $exact {
    $e = "--exact"
  }

  if $pipe {
    $p = "--pipe"
  }

	# Build the arguments for the command.
	if $site_root {
    validate_absolute_path($site_root)
    $siteroot = "--root=${site_root}"
  }

	# Build the arguments to the command.
	if $uri {
    $u = "--l=${uri}"
  }

  exec {"drush-vget-${name}":
    command => "drush vget $v $f $e $p $siteroot $u -y",
    cwd     => $site_root,
    onlyif  => $onlyif,
    timeout => 0,
    require => [
      Exec['drush_status_check'],
    ]
  }
}
