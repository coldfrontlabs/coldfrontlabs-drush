define drush::make ($makefile,
                    $build_path = '.',
                    $concurrency = undef,
                    $contrib_destination = undef,
                    $dev = undef,
                    $download_mechanism = undef,
                    $force_complete = undef,
                    $ignore_checksums = undef,
                    $libraries = undef,
                    $make_update_default_url = undef,
                    $md5 = undef,
                    $no_cache = undef,
                    $no_clean = undef,
                    $no_core = undef,
                    $no_gitinfofile = undef,
                    $no_patch_txt = undef,
                    $prepare_install = undef,
                    $projects = undef,
                    $source = undef,
                    $tar = undef,
                    $test = undef,
                    $translations = undef,
                    $version = undef,
                    $working_copy = undef,
                    $onlyif = 'test !'
                    )
{
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }


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

  exec {"drush-make-${makefile}-${build_path}":
    command => "drush make $makefile $build_path $cnc $cd $d $dm $fc $ic $lib $mudu $m5 $nca $ncl $ncl $nco $ngi $npt $pi $proj $src $tr $tst $trans $v $wc -y",
    cwd => '/tmp',
    require => Exec['drush_status_check'],
    timeout => 0,  # Drush make can take a while. We disable timeouts for this reason
    onlyif => ["if [ -d ${build_path} && -z `ls -A ${build_path}` || ! -e ${build_path} ] ; then  rmdir ${build_path} &> /dev/null ; exit 0 ; fi ; exit 1", "${onlyif}"]
  }
}