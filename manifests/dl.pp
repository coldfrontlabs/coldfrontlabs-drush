define drush::dl ($destination = undef,
                  $source = undef,
                  $project_name = undef,
                  $default_major = undef,
                  $drupal_project_rename = undef,
                  $onlyif = true)
{
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

  $args = ''

  if $destination {
    $args = "${args} --destination=${destination}"
  }

  if $source {
    $args = "${args} --source=${source}"
  }

  if !$project_name {
    $project_name = $name
  }

  if $default_major {
    $args = "${args} --default-major=${default_major}"
  }

  if $drupal_project_rename {
    $args = "${args} --drupal-project-rename=${drupal_project_rename}"
  }

  exec {"drush-dl-${name}":
    command => "drush ${args} dl ${project_name} -y",
    cwd     => $sitepath,
    onlyif => $onlyif
  }

  if defined(Exec["drush-en-${name}"]) {
    Exec["drush-dl-${name}"] {
      before  => Exec["drush-en-${name}"],
    }
  }
}