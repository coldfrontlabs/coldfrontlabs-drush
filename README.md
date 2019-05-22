Drush Puppet
===============

Manages the installation and configuration of Drush globally. Either using Drush Launcher (Drush >=9) or Drush as a global command (Drush < 9).

Features
--------

- Drush cli installation
- Execute core drush commands from puppet
    - site-install
    - pm-enable
    - pm-download
    - etc...
- Enables auto-complete configuration (see [drush.complete.sh](https://github.com/drush-ops/drush/blob/master/drush.complete.sh))
- Configure /etc/drush/drush.ini file through Hiera

Dependencies
------------

Since Drush requires composer to be installed, this module depends on the feature-20 branch of [tPl0ch/composer](https://forge.puppetlabs.com/tPl0ch/composer) to install drush.

Testing
-------

This module is primarily tested on CentOS. If someone wants to test and commit patches for other Linux distros please do so.

Sample Configuration
--------------------

#### Include drush
````puppet
include drush
````

or

````puppet
class {'drush':
  version => '6.*',  # Version options include specific values like '6.2.0', latest stable as '6.*' or dev with 'dev-master'
  drush_cmd => '/usr/bin/drush', # Directory to place the drush executable
  composer_home => '/usr/local/share/composer', # Directory where composer will install drush
}
````

#### Running commands
````puppet
drush::si {"drush-si-${name}":
    profile => $profile,
    db_url => $db_url,
    site_root => $site_root,
    account_name => $account_name,
    account_pass => $account_pass,
    account_mail => $account_mail,
    clean_url => $clean_url,
    db_prefix => $db_prefix,
    db_su => $db_su,
    db_su_pw => $db_su_pw,
    locale => $locale,
    site_mail => $site_mail,
    site_name => $site_name,
    sites_subdir => $sitessubdir,
    settings => $keyvalue,
    onlyif => "test ! -f ${site_root}/sites/${sitessubdir}/settings.php -a -f ${site_root}/index.php",
    require => [
      Drupalsi::Distro[$distro],
    ]
  }
````

#### Hiera Configuration

Some configuration options can be passed in through Hiera

##### /etc/drush/drush.ini

````yaml
drush::ini:
    memory_limit: 128M
    max_execution_time: 300
    error_reporting: E_ALL | E_NOTICE | E_STRICT
    display_errors: stderr
````
##### /home/myuser/.drush/drushrc.php

````yaml
drush::drushrc:
  myuser:
    user: myuser
    settings:
      - $options['my_drush_option'] = 'value';
      - $aliases['another_option']['array'] = 'another value';
  global:
    user: root
    settings:
      - $options['global_option'] = 'value';
    location: /etc/drush
````

#### /etc/drush/<aliasgroup>.aliases.drushrc.php

Some options require you to embed the actual section of the PHP array normally found in your site aliases file.
This is true for any option which has an indefinite set of options. The commands include

- shell_aliases
- command_specific
- target_command_specific
- source_command_specific
- variables

To denote the block of text use the '>' operator in your YAML configuration. See "command_specific" in the example below.

````yaml
drush::site_alias_group:
  dropfort:
    name: 'dfapp'
    description: "Dropfort Group Aliases"
    aliases:
      local:
        name: 'local'
        uri: 'app.dflocal.net:8080'
        os: 'Linux'
        root: /var/www/html/app
      qa:
        name: 'qa'
        uri: 'appqa.dropfort.com'
        remote_host: 'windsor.dropfort.com'
        parent: 'prod'
      prod:
        name: 'prod'
        uri: 'app.dropfort.com'
        root: '/var/www/html/app'
        remote_host: 'stirling.dropfort.com'
        command_specific: >
          'sql-sync' => array(
            'no-cache' => TRUE,
          ),
````

#### /etc/drush/policy.drush.inc

Enfore policies when running certain commands. Best example would be to limit sql-sync with production sites. Name the policy and use the '>' text block operator to wrap your PHP code.

````yaml
drush::policies:
  sql_sync: >
    /**
     * Implement of drush_hook_COMMAND_validate().
     *
     * Prevent catastrophic braino. Note that this file has to be local to the machine
     * that intitiates sql-sync command.
     */
    function drush_policy_sql_sync_validate($source = NULL, $destination = NULL) {
      if ($destination == '@prod') {
        return drush_set_error('POLICY_DENY', dt('Per examples/policy.drush.inc, you may never overwrite the production database.'));
      }
    }
````

## More Info
For more examples, see the [Drupal Site Install puppet module](https://github.com/coldfrontlabs/coldfrontlabs-drupalsi).
