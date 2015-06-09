define drush::make ($makefile,
                    $build_path = '.',
                    $concurrency = undef,
                    $contrib_destination = undef,
                    $dev = false,
                    $download_mechanism = undef,
                    $force_complete = false,
                    $ignore_checksums = false,
                    $libraries = undef,
                    $make_update_default_url = undef,
                    $md5 = undef,
                    $no_cache = false,
                    $no_clean = false,
                    $no_core = false,
                    $no_gitinfofile = false,
                    $no_patch_txt = false,
                    $prepare_install = false,
                    $projects = undef,
                    $source = undef,
                    $tar = false,
                    $test = false,
                    $translations = undef,
                    $version = false,
                    $working_copy = false,
                    $dropfort_userauth_token = undef,
                    $dropfort_url = undef,
                    $onlyif = 'test !'
                    )
{
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }

  # Check boolean variables
  validate_bool($dev)
  validate_bool($force_complete)
  validate_bool($ignore_checksums)
  validate_bool($no_cache)
  validate_bool($no_clean)
  validate_bool($no_core)
  validate_bool($no_gitinfofile)
  validate_bool($no_patch_txt)
  validate_bool($prepare_install)
  validate_bool($tar)
  validate_bool($test)
  validate_bool($version)
  validate_bool($working_copy)


  #$combined_onlyif = "test ! -e ${build_path} && ${onlyif}"

  if $concurrency {
    $cnc = "--concurrency=${concurrency}"
  }

  if $contrib_destination {
    $cd = "--contrib-destination=${contrib_destination}"
  }

  if $dev {
    $d = "--dev"
  }

  if $download_mechanism {
    $dm = "--download-mechanism=${download_mechanism}"
  }

  if $force_complete {
    $fc = "--force-complete"
  }
  if $ignore_checksums {
    $ic = "--ignore-checksums"
  }
  if $libraries {
    $lib = "--librariries=$libraries"
  }
  if $make_update_default_url {
    $mudu = "--make-update-default-url=$make_update_default_url"
  }
  if $md5 {
    $m5 = "--md5=$md5"
  }
  if $no_cache {
    $nca = "--no-cache"
  }
  if $no_clean {
    $ncl = "--no-clean"
  }
  if $no_core {
    $nco = "--no-core"
  }
  if $no_gitinfofile {
    $ngi = "--no-gitinfofile"
  }
  if $no_patch_txt {
    $npt = "--no-patch-txt"
  }
  if $prepare_install {
    $pi = "--prepare-install"
  }
  if $projects {
    $proj = "--projects=$projects"
  }
  if $source {
    $src = "--source=$source"
  }
  if $tar {
    $tr = "--tar"
  }
  if $test {
    $tst = "--test"
  }
  if $translations {
    $trans = "--translations=$translations"
  }
  if $version {
    $v = "--version"
  }
  if $working_copy {
    $wc = "--working-copy"
  }
  if $dropfort_userauth_token {
    $dut = "--dropfort_userauth_token=${dropfort_userauth_token}"
  }
  if $dropfort_url {
    $durl = "--dropfort_url=${dropfort_url}"
  }

  $filehash = md5("${makefile}-${build_path}")

  file {"/tmp/drush_make_prep-${filehash}.sh":
    ensure => 'present',
    source => ["puppet:///modules/drush/drush_make_prep.sh"],
    mode => 0755,
  }

  # If the make is from the github api...
  if $makefile =~ /^(https?:\/\/api.github.com)/ {
    file_line{"drush-make-addcurlrc-${filehash}":
      before  => Exec["drush-make-${filehash}"],
      path => "${::root_home}/.curlrc",
      line => '-H "Accept: application/vnd.github.v3.raw"',
      require => File["drush-make-exist-curlrc", "drush-make-exist-wgetrc"]
    }->
    file_line{"drush-make-addwgetrc-${filehash}":
      before  => Exec["drush-make-${filehash}"],
      path => "${::root_home}/.wgetrc",
      line => 'header = Accept: application/vnd.github.v3.raw',
      require => File["drush-make-exist-curlrc", "drush-make-exist-wgetrc"]
    }
  }

  # If the dropfort commands are in use, ensure dropfort_update is available
  if $dropfort_userauth_token or $dropfort_url {
    drush::dl{"root-dropfort_update-${filehash}":
      project_name => 'dropfort_update',
      destination => "${::root_home}/.drush",
      require => [File['drush-dir-exist'], File['drush-root-drushrc']],
      before => Exec["drush-make-${filehash}"]
    }
    if $dropfort_userauth_token {
      file_line{"drush-make-root-drushrc-token-${filehash}":
        path => "${::root_home}/.drush/drushrc.php",
        line => "\$options['dropfort_userauth_token'] = '${dropfort_userauth_token}';",
        require => Drush::Dl["root-dropfort_update-${filehash}"],
        before => Exec["drush-make-${filehash}"],
        ensure => 'present',
      }
    }
    if $dropfort_url {
      file_line{"drush-make-root-drushrc-url-${filehash}":
        path => "${::root_home}/.drush/drushrc.php",
        line => "\$options['dropfort_url'] = '${dropfort_url}';",
        require => Drush::Dl["root-dropfort_update-${filehash}"],
        before => Exec["drush-make-${filehash}"],
        ensure => 'present',
      }
    }
  }

  drush::cc{"root-dropfort-update-cc-${filehash}":
    cache => 'drush',
    onlyif => ["/tmp/drush_make_prep-${filehash}.sh ${build_path}", "${onlyif}"],
  }->
  exec {"drush-make-${filehash}":
    command => "drush make '$makefile' $build_path $cnc $cd $d $dm $fc $ic $lib $mudu $m5 $nca $ncl $ncl $nco $ngi $npt $pi $proj $src $tr $tst $trans $v $wc $durl $dut -y",
    cwd => '/tmp',
    require => [Exec['drush_status_check'], File["/tmp/drush_make_prep-${filehash}.sh"]],
    timeout => 0,  # Drush make can take a while. We disable timeouts for this reason
    onlyif => ["/tmp/drush_make_prep-${filehash}.sh ${build_path}", "${onlyif}"]
  }->
  file_line{"drush-make-rmcurlrc-${filehash}":
    path => "${::root_home}/.curlrc",
    line => '-H "Accept: application/vnd.github.v3.raw"',
    ensure => 'absent',
  }->
  file_line{"drush-make-rmwgetrc-${filehash}":
    path => "${::root_home}/.wgetrc",
    line => 'header = Accept: application/vnd.github.v3.raw',
    ensure => 'absent',
  }->
  file_line{"remove-drush-make-root-drushrc-token-${filehash}":
    path => "${::root_home}/.drush/drushrc.php",
    line => "\$options['dropfort_userauth_token'] = '${dropfort_userauth_token}';",
    ensure => 'present',
  }->
  file_line{"remove-drush-make-root-drushrc-url-${filehash}":
    path => "${::root_home}/.drush/drushrc.php",
    line => "\$options['dropfort_url'] = '${dropfort_url}';",
    ensure => 'absent',
  }
}
