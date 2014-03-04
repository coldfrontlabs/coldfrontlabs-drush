Facter.add('hasdrush') do
  setcode 'which drush'
end