# Add an instance of an *.aliases.drushrc.php file
define drush::policy($name, $policy) {
  file_line{"drush-policy-${name}":
    path => "/etc/drush/policy.drush.inc",
    line => "${policy}",
    ensure => 'present',
  }
}