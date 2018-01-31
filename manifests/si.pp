# Drush Site Install
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
                  $settings = '', # key=value... settings to pass in optionally
                  $site_root,
                  $onlyif = 'test !'
                )
{

	validate_absolute_path($site_root)

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }

  $siteroot = "--root=$site_root"

  if $db_url {
    $dburl = "--db-url=${db_url}"

    #if $db_url =~ /^pgsql:/ {
    #  $php_pgsql_package = hiera('php::pgsql_package', 'php-pgsql')
    ##  ensure_packages([$php_pgsql_package], {'ensure' => 'installed'})
    #  $db_require = Php::Extension['pgsql']
    #} else {
      #$php_mysql_package = hiera('php::mysql_package', 'php-mysql')
    #  #ensure_packages([$php_mysql_package], {'ensure' => 'installed'})
      #$db_require = Php::Extension['mysql']
    #}
  }

  if $account_name {
    $accountname = "--account-name='${account_name}'"
  }

  if $account_pass {
    $accountpass = "--account-pass='${account_pass}'"
  }

  if $account_mail {
    $accountmail = "--account-mail='${account_mail}'"
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
    $sitename = "--site-name='${site_name}'"
  }

  if $sites_subdir {
    $sitessubdir = "--sites-subdir=${sites_subdir}"
  }

  exec {"drush-si-${name}":
    command => "drush si $profile $settings $siteroot $dburl $accountname $accountpass $accountmail $cleanurl $dbprefix $dbsu $dbsupw $lcl $sitemail $sitename $sitessubdir -y",
    cwd     => $site_root,
    onlyif  => $onlyif,
    timeout => 0,
    require => [
      #File["${$site_root}"],
      Exec['drush-global-download'],
      Class['php::cli'],
      Php::Extension['mbstring'],
      Php::Extension['pdo'],
      Php::Extension['process'],
      Php::Extension['xml'],
      Php::Extension['gd'],
      #$db_require,
    ]
  }
}
