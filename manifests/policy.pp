# Add an instance of an policy.drushrc.php file
define drush::policy($name, $policy) {
  file_line{"drush-policy-${name}":
    path => "/etc/drush/policy.drushrc.php",
    line => "${policy}",
    ensure => 'present',
    require => File['/etc/drush/policy.drushrc.php'],
  }
}