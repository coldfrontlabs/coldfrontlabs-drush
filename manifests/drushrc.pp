# Add an instance of the drushrc.php file in the given location
define drush::drushrc($name) {

  # Work around to dynamically load a user's home directory location
  # @see https://ask.puppetlabs.com/question/5373/how-to-reference-a-users-home-directory/
  $home_var = "homedir_${name}"
  $dir = inline_template("<%= scope.lookupvar(@home_var) %>")

  file {"${dir}/.drush/drushrc.php":
    ensure => 'present',
    owner => ${name},
    group => ${name},
    mode => '0644',
    content => template('drush/php.erb','drush/drushrc.php.erb'),
    require => [
      File['${dir}/.drush'],
    ]
  }

  file {"${dir}/.drush":
    ensure => 'directory',
    owner => ${name},
    group => ${name},
    mode => 0744,
    require => User[${name}],
  }
}
