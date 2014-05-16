define drush::make ($makefile,
                    $build_path = '',
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
                    $onlyif = true
                    )
{
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }
  $args = ''

  if $concurrency {
   $args = "${args} --concurrency=${concurrency}"
  }

  if $contrib_destination {
    $args = "${args} --contrib-destination=${contrib_destination}"
  }

  if $dev {
    $args = "${args} --dev"
  }

  if $download_mechanism {
    $args = "${args} --download-mechanism=${download_mechanism}"
  }

  if $force_complete {
    $args = "${args} --force-complete"
  }
  if $ignore_checksums {
    $args = "${args} --ignore-checksums"
  }
  if $libraries {
    $args = "${args} --librariries=$libraries"
  }
  if $make_update_default_url {
    $args = "${args} --make-update-default-url=$make_update_default_url"
  }
  if $md5 {
    $args = "${args} --md5=$md5"
  }
  if $no_cache {
    $args = "${args} --no-cache"
  }
  if $no_clean {
    $args = "${args} --no-clean"
  }
  if $no_core {
    $args = "${args} --no-core"
  }
  if $no_gitinfofile {
    $args = "${args} --no-gitinfofile"
  }
  if $no_patch_txt {
    $args = "${args} --no-patch-txt"
  }
  if $prepare_install {
    $args = "${args} --prepare-install"
  }
  if $projects {
    $args = "${args} --projects=$projects"
  }
  if $source {
    $args = "${args} --source=$source"
  }
  if $tar {
    $args = "${args} --tar"
  }
  if $test {
    $args = "${args} --test"
  }
  if $translations {
    $args = "${args} --translations=$translations"
  }
  if $version {
    $args = "${args} --version"
  }
  if $working_copy {
    $args = "${args} --working-copy"
  }

  # Run the make
  exec {"drush-make-${makefile}-${build_path}":
    command => "drush make $makefile $build_path $args -y",
    onlyif => $onlyif,
    cwd => '/tmp',
  }
}