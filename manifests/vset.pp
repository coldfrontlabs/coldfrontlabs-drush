define drush::vset ($variable,
                  $value,
                  $exact = false,
                  $format = undef,
                  $pipe = false,
                  $uri = undef,
                  $site_root,
                  $onlyif = 'test !'
                )
{
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

	# Build the arguments for the command.
	if $site_root {
    validate_absolute_path($site_root)
    $siteroot = "--root=${site_root}"
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

	if $uri {
    $u = "--l=${uri}"
  }

  $hash = md5("$site_root-$uri-$variable-$value")

  exec {"drush-vset-${hash}":
    command => "drush vset $variable $value $f $e $p $siteroot $u -y",
    onlyif => $onlyif,
    require => Exec['drush_status_check'],
  }
}