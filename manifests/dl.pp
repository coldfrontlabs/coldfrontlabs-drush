define drush::dl ($destination = undef, $source = undef, $project_name = undef, $default_major = undef) {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

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

  if !$default_major {
    $dm = ""
  } else {
    $dm = "--default-major=$default_major"
  }

  exec {"drush-dl-${name}":
    command => "drush $dst $src $dm dl ${project_name} -y",
    cwd     => $sitepath,
  }

  if defined(Exec["drush-en-${name}"]) {
    Exec["drush-dl-${name}"] {
      before  => Exec["drush-en-${name}"],
    }
  }
}


# -cache                                   Cache release XML and tarballs
#                                           or git clones. Git clones use
#                                           git's --reference option.
#   --cache-duration-releasexml             Expire duration (in seconds) for
#                                           release XML. Defaults to 86400
#                                           (24 hours).
# --default-major=<6>                       Specify the default major
#                                           version of modules to download
#                                           when there is no bootstrapped
#                                           Drupal site.  Defaults to "7".
# --destination=<path>                      Path to which the project will
#                                           be copied. If you're providing a
#                                           relative path, note it is
#                                           relative to the drupal root (if
#                                           bootstrapped).
# --dev                                     Work with development releases
#                                           solely.
# --drupal-project-rename                   Alternate name for "drupal-x.y"
#                                           directory when downloading
#                                           Drupal project. Defaults to
#                                           "drupal".
# --notes                                   Show release notes after each
#                                           project is downloaded.
# --pipe                                    Returns a list of the names of
#                                           the extensions (modules and
#                                           themes) contained in the
#                                           downloaded projects.
# --select                                  Select the version to download
#                                           interactively from a list of
#                                           available releases.
#   --all                                   Shows all available releases
#                                           instead of a short list of
#                                           recent releases.
# --skip                                    Skip automatic downloading of
#                                           libraries (c.f. devel).
# --source                                  The base URL which provides
#                                           project release history in XML.
#                                           Defaults to
#                                           http://updates.drupal.org/releas
#                                           e-history.
# --use-site-dir                            Force to use the site specific
#                                           directory. It will create the
#                                           directory if it doesn't exist.
#                                           If --destination is also present
#                                           this option will be ignored.
# --variant=<full>                          Only useful for install
#                                           profiles. Possible values:
#                                           'full', 'projects',
#                                           'profile-only'.