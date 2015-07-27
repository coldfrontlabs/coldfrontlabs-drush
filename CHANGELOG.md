v0.5.0
  - tPl0ch/composer v2.0.0 support
  - drush rsync command
  - drush arr command

v0.4.2
  - Fix missing HOME environment variable during puppet exec
  - Add dropfort_userauth_token and dropfort_url options to drush make
  - Auto deploy dropfort_update when using auth or url options

v0.4.1
  - Migrate to metadata.json format
  - Add support for managing policy.drush.inc file

v0.4.0
  - Add support for update-db
  - Add support for sql-sync
  - Add support for complex site alias settings (command_specific, target_command_specific, variables, shell_aliases, etc...)

v 0.3.8
 - Fix bug where curlrc / wgetrc files aren't found

v 0.3.7
 - Restored facts to lib/facter
 - Switch to use :root_home fact from stdlib

v 0.3.6
 - Moved facts to facts.d

v 0.3.5
 - Add support for make files from private GitHub repos

v 0.3.0
 - Add support for drushrc.php file management
 - Refactor init params
 - Support for CentOS 7

v 0.2.1
 - Add support for global /etc/drush/drush.ini configuration

v 0.1.5
- General bug fixes
- Add support for drush aliases and drush alias groups

v 0.1.0
- Initial version
- Support basic drush commands (e.g. si, en, dis, cc)