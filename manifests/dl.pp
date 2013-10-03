define drush::dl ($destination = undef, $source = undef) {

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

  exec {"drush-dl-${name}":
    command => "drush $dst $src dl ${name} -y",
    cwd     => $sitepath,
  }

  if defined(Exec["drush-en-${name}"]) {
    Exec["drush-dl-${name}"] {
      before  => Exec["drush-en-${name}"],
    }
  }
}
