define drush::make ($makefile, $dir = undef, $options = undef) {

  # Run the make
  exec {"drush-make-${makefile}":
    command => "drush make $makefile $dir -y $options",
  }
}