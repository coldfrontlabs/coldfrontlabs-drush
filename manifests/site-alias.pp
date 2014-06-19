define drush::sa ($site_root,
                  $site = undef,
                  $alias_name = undef,
                  $field_labels = undef,
                  $fields = undef,
                  $format = undef,
                  $full = undef,
                  $local = undef,
                  $no_db = undef,
                  $pipe = undef,
                  $with_db = undef,
                  $with_db_url = undef,
                  $with_optional = undef,
) {


  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ] }

  $siteroot = "--root=$site_root"

  if $site {
    $s = "${site}"
  }

  if $alias_name {
    $an = "--alias-name=${account_name}"
  }

  if $field_labels {
    $fl = "--field-labels"
  }

  if $fields {
    $f = "--fields=${fields}"
  }

  if $format {
    $fmt = "--format=${format}"
  }

  if $full {
    $fu = "--full"
  }

  if $local {
    $l = "--local"
  }

  if $no_db {
    $nodb = "--no-db"
  }

  if $pipe {
    $p = "--pipe"
  }

  if $with_db {
    $wdb = "--with-db"
  }

  if $with_db_url {
    $wdbu = "--with-db-url"
  }

  if $with_optional {
    $wo = "--with-optional"
  }

  exec {"drush-sa-${name}":
    command => "drush sa $s $an $fl $f $fmt $fu $l $nodb $p $wdb $wdbu $wdo $siteroot -y",
    cwd     => $site_root,
    require => [
      File["${$site_root}"],
    ]
  }
}
