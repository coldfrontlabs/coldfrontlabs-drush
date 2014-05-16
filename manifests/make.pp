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

  $combined_onlyif = "test ! -e ${build_path} && ${onlyif}"

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

  # Run the make
  exec {"drush-make-${makefile}-${build_path}":
    command => "drush make $makefile $build_path $cnc $cd $d $dm $fc $ic $lib $mudu $m5 $nca $ncl $ncl $nco $ngi $npt $pi $proj $src $tr $tst $trans $v $wc -y",
    onlyif => $combined_onlyif,
    cwd => '/tmp',
  }

  exec { "drush-make-rmdir-${makefile}-${build_path}":
    command  => "rmdir ${build_path} &> /dev/null || true",
    # Check if the path is empty or if the directory exists that it is empty
    onlyif => "[[ -z `ls -A ${build_path} | wc -l` && -d ${build_path} || ! -z `test ! -e ${build_path}` ]]"
  }

  # Since drush make won't overwrite an existing directory, we remove an empty directory if it's there already (say for instance puppet/apache already provisioned it)
  if defined(Exec["drush-make-${makefile}-${build_path}"]) {
    Exec["drush-make-rmdir-${makefile}-${build_path}"] {
      before  => Exec["drush-make-${makefile}-${build_path}"],
    }
  }
}