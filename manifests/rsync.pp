define drush::rsync ($source,
                     $dest,
                     $exclude_conf = true,
                     $exclude_files = false,
                     $exclude_other_sites = undef,
                     $exclude_paths = undef,
                     $exclude_sites = false,
                     $include_conf = false,
                     $include_paths = undef,
                     $include_vcs = false,
                     $mode = undef,
                     $rsync_options = undef,
                     $onlyif = 'test !'
                )
{


  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

  if $exclude_conf {
    $excludeconf = "--exclude-conf"
  }

  if $exclude_files {
    $excludefiles = "--exclude-files"
  }

  if $exclude_other_sites {
    $excludeothersites = "--exclude-other-sites=${exclude_other_sites}"
  }

  if $exclude_paths {
    $excludepaths = "--exclude-paths=${exclude_paths}"
  }

  if $exclude_sites {
    $excludesites = "--exclude-sites"
  }

  if $include_paths {
    $includepaths = "--include-paths=${include_paths}"
  }

  if $include_vcs {
    $includevcs = "--include-vcs"
  }

  if $mode {
    $m = "--mode=${mode}"
  }

  # @todo add rsync options

  exec {"drush-rsync-${name}":
    command => "drush rsync $source $destination $excludeconf $excludefiles $excludeothersites $excludepaths $excludesites $includepaths $includevcs $m -y",
    onlyif  => $onlyif,
    timeout => 0,
    require => [
      Exec['drush_status_check'],
    ]
  }
}
