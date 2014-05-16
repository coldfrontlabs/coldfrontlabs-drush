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

  $args = "--root=$site_root"

  if $db_url {
    $args = "${args} --db-url=${db_url}"
  }

  if $account_name {
    $args = "${args} --account-name=${account_name}"
  }

  if $account_pass {
    $args = "${args} --account-pass=${account_pass}"
  }

  if $account_mail {
    $args = "${args} --account-mail=${account_mail}"
  }

  if $clean_url {
    $args = "${args} --clean-url"
  }

  if $db_prefix {
    $args = "${args} --db-prefix=${db_prefix}"
  }

  if $db_su {
    $args = "${args} --db-su=${db_su}"
  }

  if $db_su_pw {
    $args = "${args} --db-su-pw=${$db_su_pw}"
  }

  if $locale {
    $args = "${args} --locale=${locale}"
  }

  if $site_mail {
    $args = "${args} --site-mail=${site_mail}"
  }

  if $site_name {
    $args = "${args} --site-name=${site_name}"
  }

  if $sites_subdir {
    $args = "${args} --sites-subdir=${sites_subdir}"
  }

  exec {"drush-si-${name}-${profile}":
    command => "drush si $profile $settings $args -y",
    cwd     => $site_root,
    onlyif  => $onlyif
  }

  if defined(Exec["drush-si-${name}"]) {
    Exec["drush-si-${name}"] {
      before  => Exec["drush-si-${name}"],
    }
  }
}