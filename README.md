Drush Puppet
===============

Manages the installation and configuration of Drush using Composer.

Features
--------

- Drush cli installation
- Enables auto-complete configuration (see [drush.complete.sh](https://github.com/drush-ops/drush/blob/master/drush.complete.sh))

Roadmap Features
----------------

- Site aliases configuration via Hiera
- Policy files via Hiera
- drush.ini configuration
- drushrc.php configuration

Dependencies
------------

Since Drush requires composer to be installed, this module depends on our fork of [tPl0ch/composer](https://forge.puppetlabs.com/tPl0ch/composer) to install drush. Once v2 is released with "global" and "require" support our fork of this puppet module will be deprecated.

- [Composer Puppet Module](https://github.com/coldfrontlabs/puppet-composer)

Testing
-------

This module is primarily tested on CentOS. If someone wants to test and commit patches for other Linux distros please do so.

Sample Configuration
--------------------

````puppet
include drush
````

````puppet
class {'drush':
  version => '6.*',  # Version options include specific values like '6.2.0', latest stable as '6.*' or dev with 'dev-master'
  drush_cmd => '/usr/bin/drush', # Directory to place the drush executable
  composer_home => '/usr/local/share/composer', # Directory where composer will install drush
}
````
