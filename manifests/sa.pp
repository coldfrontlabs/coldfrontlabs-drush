define drush::sa ($site_root,
                  $site = undef,
                  $alias_name = undef,
                  $field_labels = false,
                  $fields = undef,
                  $format = undef,
                  $full = false,
                  $local = false,
                  $no_db = false,
                  $pipe = false,
                  $with_db = false,
                  $with_db_url = false,
                  $with_optional = false,
) {
  validate_bool($field_labels)
  validate_bool($full)
  validate_bool($local)
  validate_bool($no_db)
  validate_bool($pipe)
  validate_bool($with_db)
  validate_bool($with_db_url)
  validate_bool($with_optional)

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
