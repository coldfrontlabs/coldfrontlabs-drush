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
                  $settings = '',
                  $site_root,
                  $onlyif = 'test !'
                )
{


  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

  $siteroot = "--root=$site_root"

  if $db_url {
    $dburl = "--db-url=${db_url}"
  }

  if $account_name {
    $accountname = "--account-name=${account_name}"
  }

  if $account_pass {
    $accountpass = "--account-pass=${account_pass}"
  }

  if $account_mail {
    $accountmail = "--account-mail=${account_mail}"
  }

  if $clean_url {
    $cleanurl = "--clean-url"
  }

  if $db_prefix {
    $dbprefix = "--db-prefix=${db_prefix}"
  }

  if $db_su {
    $dbsu = "--db-su=${db_su}"
  }

  if $db_su_pw {
    $dbsupw = "--db-su-pw=${$db_su_pw}"
  }

  if $locale {
    $lcl = "--locale=${locale}"
  }

  if $site_mail {
    $sitemail = "--site-mail=${site_mail}"
  }

  if $site_name {
    $sitename = "--site-name=${site_name}"
  }

  if $sites_subdir {
    $sitessubdir = "--sites-subdir=${sites_subdir}"
  }

  exec {"drush-si-${name}":
    command => "drush si $profile $settings $siteroot $dburl $accountname $accountpass $accountmail $cleanurl $dbprefix $dbsu $dbsupw $lcl $sitemail $sitename $sitessubdir -y",
    cwd     => $site_root,
    onlyif  => $onlyif,
    timeout => 0,
    require => [File["${$site_root}"], Composer::Require['drush_global']]
  }
}