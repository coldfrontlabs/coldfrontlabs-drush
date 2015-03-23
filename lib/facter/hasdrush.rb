Facter.add('hasdrush') do
  setcode do
    system("which drush > /dev/null 2>&1")
  end
end
