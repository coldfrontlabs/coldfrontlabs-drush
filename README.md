Drush Puppet
===============

Manages the installation and configuration of Drush. This includes

- Site aliases
- Policy files
- drush cli configuration

Dependencies
------------

Since Drush requires composer to be installed, this module depends our fork of [tPl0ch/composer](https://forge.puppetlabs.com/tPl0ch/composer) to install drush until v2 is released with "global" and "require" support.

- [Composer Puppet Module](https://github.com/coldfrontlabs/puppet-composer)

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