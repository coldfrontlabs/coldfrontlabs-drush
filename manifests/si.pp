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
    $db_url = "--db-url=${db_url}"
  }

  if $account_name {
    $account_name = "--account-name=${account_name}"
  }
  if $account_pass {
    $account_pass = "--account-pass=${account_pass}"
  }
  if $account_mail {
    $account_mail = "--account-mail=${account_mail}"
  }
  if $clean_url {
    $clean_url = "--clean-url=1"
  }
  if $db_prefix {
    $db_prefix = "--db-prefix=${db_prefix}"
  }
  if $db_su {
    $db_su = "--db-su=${db_su}"
  }
  if $db_su_pw {
    $db_su_pw = "--db-su-pw=${$db_su_pw}"
  }
  if $locale {
    $locale = "--locale=${locale}"
  }
  if $site_mail {
    $site_mail = "--site-mail=${site_mail}"
  }
  if $site_name {
    $site_name = "--site-name=${site_name}"
  }
  if $sites_subdir {
    $sites_subdir = "--sites-subdir=${sites_subdir}"
  }

  exec {"drush-si-${name}-${profile}":
    command => "drush si $profile $settings --root=$site_root $db_url $account_name $account_pass $account_mail $clean_url $db_prefix $db_su $db_su_pw $locale $site_mail $site_name $sites_subdir -y",
    cwd     => $site_root,
    onlyif  => $onlyif
  }

  if defined(Exec["drush-si-${name}"]) {
    Exec["drush-si-${name}"] {
      before  => Exec["drush-si-${name}"],
    }
  }
}