# drush/lib/facter/homedir.rb
#
# Detect the home directories of all users on the machine

require 'etc'
Etc.passwd do |user|
  Facter.add("homedir_#{user.name}".intern) do
    setcode { user.dir }
  end
end