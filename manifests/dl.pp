define drush::dl ($destination = undef, $source = undef, $project_name = undef) {

  if !$destination {
    $dst = ""
  } else {
    $dst = "--destination=$destination"
  }

  if !$source {
    $src = ""
  } else {
    $src = "--source=$source"
  }

  if !$project_name {
    $project_name = $name
  }

  exec {"drush-dl-${name}":
    command => "drush $dst $src dl ${project_name} -y",
    cwd     => $sitepath,
  }

  if defined(Exec["drush-en-${name}"]) {
    Exec["drush-dl-${name}"] {
      before  => Exec["drush-en-${name}"],
    }
  }
}
