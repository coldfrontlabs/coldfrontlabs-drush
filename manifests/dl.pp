define drush::dl ($project_name = undef,
                  $destination = undef,
                  $source = undef,
                  $default_major = undef,
                  $drupal_project_rename = undef,
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

  if $destination {
    $dst = "--destination=${destination}"
  }

  if $source {
    $src = "--source=${source}"
  }

  if !$project_name {
    $project_name = $name
  }

  if $default_major {
    $dm = "--default-major=${default_major}"
  }

  if $drupal_project_rename {
    $dpr = "--drupal-project-rename=${drupal_project_rename}"
  }

  exec {"drush-dl-${name}":
    command => "drush dl $project_name $dst $src $dm $dpr $siteroot $u -y",
    cwd     => $sitepath,
    onlyif => $onlyif,
    require => Exec['drush_status_check'],
  }

  if defined(Exec["drush-en-${name}"]) {
    Exec["drush-dl-${name}"] {
      before  => Exec["drush-en-${name}"],
    }
  }
}