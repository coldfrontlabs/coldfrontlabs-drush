define drush::si ($profile = undef,
                  $db_url = undef,
                  $account_name = undef,
                  $account_pass = undef,
                  $account_mail = undef,
                  $clean_url = undef,
                  $db_prefix = undef,
                  $db_su = undef,
                  $db_su_pw = undef,
                  $locale = undef,
                  $site_mail = undef,
                  $site_name = undef,
                  $sites_subdir = undef,
                  $settings = undef,
                  $site_root,
                  $onlyif = true
                )
{
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

  if $db_url {
    $dburl = "--db-url=${db_url}"
  }
  else {
    $dburl = ""
  }

  if $account_name {
    $accountname = "--account-name=${account_name}"
  }
  else {
    $accountname = ""
  }

  if $account_pass {
    $accountpass = "--account-pass=${account_pass}"
  }
  else {
    $accountpass = ""
  }

  if $account_mail {
    $accountmail = "--account-mail=${account_mail}"
  }
  else {
    $accountmail = ""
  }

  if $clean_url {
    $cleanurl = "--clean-url=1"
  }
  else {
    $cleanurl = "--clean-url=0"
  }

  if $db_prefix {
    $dbprefix = "--db-prefix=${db_prefix}"
  }
  else {
    $dbprefix = ""
  }

  if $db_su {
    $dbsu = "--db-su=${db_su}"
  }
  else {
    $dbsu = ""
  }

  if $db_su_pw {
    $dbsupw = "--db-su-pw=${$db_su_pw}"
  }
  else {
    $dbsupw = ""
  }
  if $locale {
    $lcl = "--locale=${locale}"
  }
  else {
    $lcl = ""
  }
  if $site_mail {
    $sitemail = "--site-mail=${site_mail}"
  }
  else {
    $sitemail = ""
  }

  if $site_name {
    $sitename = "--site-name=${site_name}"
  }
  else {
    $sitename = ""
  }
  if $sites_subdir {
    $sitessubdir = "--sites-subdir=${sites_subdir}"
  }
  else {
    $sitessubdir = ""
  }

  exec {"drush-si-${name}-${profile}":
    command => "drush si $profile $settings --root=$siteroot $dburl $accountname $accountpass $accountmail $cleanurl $dbprefix $dbsu $dbsupw $lcl $sitemail $sitename $sitessubdir -y",
    cwd     => $site_root,
    onlyif  => $onlyif
  }

  if defined(Exec["drush-si-${name}"]) {
    Exec["drush-si-${name}"] {
      before  => Exec["drush-si-${name}"],
    }
  }
}