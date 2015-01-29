# Add an instance of the drushrc.php file in the given location
define drush::drushrc($user,
                      $description = undef,
                      $settings,
                      $location = undef
) {

  # Try to auto detect the location of the user's home directory
  if !$location {
    # Work around to dynamically load a user's home directory location
    # @see https://ask.puppetlabs.com/question/5373/how-to-reference-a-users-home-directory/
    $home_var = "homedir_${user}"
    $directory = inline_template("<%= scope.lookupvar(@home_var) %>")
    if !$directory {
      # Fallback
      # @todo add support for Windows? Or make a better fallback...
      $dir = "/home/${user}/.drush"
    }
    else {
      $dir = "${directory}/.drush"
    }
  }

  file { "${dir}/drushrc.php":
    ensure => 'present',
    owner => $user,
    mode => '0644',
    content => template('drush/php.erb','drush/drushrc.php.erb'),
    require => [
      File["drushrc-location-${user}"],
    ]
  }

  file { "drushrc-location-${user}":
    path => $dir,
    ensure => 'directory',
    owner => $user,
    mode => 0700,
    require => [User[$user]],
  }
}
