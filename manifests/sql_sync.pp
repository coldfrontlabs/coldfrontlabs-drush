define drush::sql_sync ( $source,
                         $dest,
                         $cache = undef,
                         $create_db = false,
                         $db_su = undef,
                         $db_su_pw = undef,
                         $dump_dir = undef,
                         $no_cache = false,
                         $no_dump = false,
                         $no_ordered_dump = false,
                         $sanitize = false,
                         $sanitize_password = undef,
                         $sanitize_email = undef,
                         $skip_tables_key = undef,
                         $skip_tables_list = undef,
                         $source_database = undef,
                         $source_remote_host = undef,
                         $source_remote_port    = undef,
                         $structure_tables_key  = undef,
                         $structure_tables_list = undef,
                         $tables_key            = undef,
                         $tables_list           = undef,
                         $target_database       = undef,
                         $target_db_url = undef,
                         $target_dump = undef,
                         $target_remote_host = undef,
                         $target_remote_port = undef,
                         $temp                  = false,
                         $onlyif = 'test !'
                )
{
  validate_bool($create_db)
  validate_bool($no_cache)
  validate_bool($no_dump)
  validate_bool($no_ordered_dump)
  validate_bool($sanitize)
  validate_bool($temp)

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"], environment => ["HOME=${::root_home}"] }


  if $cache {
    $che = "--cache" # @todo add boolean validation
  }
  if $create_db {
    $createdb = "--create-db"
  }
  if $db_su {
    $dbsu = "--db-su='${db_su}'"
  }
  if $db_su_pw {
    $dbsupw = "--db-su-pw='${db_su_pw}'"
  }
  if $dump_dir {
    $dumpdir = "--dump-dir='${dump_dir}'"
  }
  if $no_cache {
    $nocache = "--no-cache"
  }
  if $no_dump {
    $nodump = "--no-dump"
  }
  if $no_ordered_dump {
    $noordereddump = "--no-ordered-dump"
  }
  if $sanitize {
    $san = "--sanitize"
  }
  if $sanitize_password {
    $sanitizepassword = "--sanitize-password='${sanitize_password}'"
  }
  if $sanitize_email {
    $sanitizeemail = "--sanitize-email='${sanitize_email}'"
  }
  if $skip_tables_key {
    $skiptableskey = "--skip-tables-key=${skip_tables_key}"
  }
  if $skip_tables_list {
    $skiptableslist = "--skip-tables-list=${skip_tables_list}" # @todo add validation that this is a comma separated list
  }
  if $source_database {
    $sourcedb = "--source-database=${source_database}"
  }
  if $source_remote_host {
    $sourcerh = "--source-remote-host=${source_remote_host}"
  }
  if $source_remote_port {
    $sourcerp = "--source-remote-port=${source_remote_port}" # @todo add validation that this is a positive int
  }
  if $structure_tables_key {
    $structuretableskey = "--structure-tables-key=${structure_tables_key}"
  }
  if $structure_tables_list {
    $structuretableslist = "--structure-tables-list=${structure_tables_list}"  # @todo add validation that this is a comma separated list
  }
  if $tables_key {
    $tableskey = "--tables-key=${tables_key}"
  }
  if $tables_list {
    $tableslist = "--tables-list=${tables_list}"  # @todo add validation that this is a comma separated list
  }
  if $target_database {
    $targetdb = "--target-database=${target_database}"
  }
  if $target_db_url {
    $targetdburl = "--target-db-url=${target_db_url}"
  }
  if $target_dump {
    $targetdump = "--target-dump=${target_dump}"
  }
  if $target_remote_host {
    $targetremotehost = "--target-remote-host=${target_remote_host}"
  }
  if $target_remote_port {
    $targetremoteport = "--target-remote-port=${target_remote_port}" # @todo add validation positive integer
  }
  if $temp {
    $tmp = "--temp"
  }

  exec {"drush-sql-sync-${name}":
    command => "drush sql-sync $source $destination $che $createdb $dbsu $dbsupw $dumpdir $nocache $nodump $noordereddump $san $sanitizepassword $sanitizeemail $skiptableskey $skiptableslist $sourcedb $sourcerh $sourcerp $structuretableskey $structuretableslist $tableskey $tableslist $targetdb $targetdburl $targetdump $targetremotehost $targetremoteport $tmp  -y",
    onlyif  => $onlyif,
    timeout => 0,
    require => [
      Exec['drush_status_check'],
    ]
  }
}
