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
                    $onlyif = 'test !'
                    )
{
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

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

  $filehash = md5("${makefile}-${build_path}")

  file {"/tmp/drush_make_prep-${filehash}.sh":
    ensure => 'present',
    source => ["puppet:///modules/drush/drush_make_prep.sh"],
    mode => 0755,
  }

  file {"drush-make-exist-curlrc":
    ensure => 'present',
    path => "${::root_home}/.curlrc"
  }->
  file {"drush-make-exist-wgetrc":
    ensure => 'present',
    path => "${::root_home}/.wgetrc"
  }

  # If the make is from the github api...
  if $makefile =~ /^(https?:\/\/api.github.com)/ {
    file_line{"drush-make-addcurlrc-${filehash}":
      before  => Exec["drush-make-${filehash}"],
      path => "${::root_home}/.curlrc",
      line => '-H "Accept: application/vnd.github.v3.raw"',
      require => File['drush-make-exist-curlrc', 'drush-make-exist-wgetrc']
    }->
    file_line{"drush-make-addwgetrc-${filehash}":
      before  => Exec["drush-make-${filehash}"],
      path => "${::root_home}/.wgetrc",
      line => 'header = Accept: application/vnd.github.v3.raw',
      require => File['drush-make-exist-curlrc', 'drush-make-exist-wgetrc']
    }
  }

  exec {"drush-make-${filehash}":
    command => "drush make '$makefile' $build_path $cnc $cd $d $dm $fc $ic $lib $mudu $m5 $nca $ncl $ncl $nco $ngi $npt $pi $proj $src $tr $tst $trans $v $wc -y",
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
  }
}