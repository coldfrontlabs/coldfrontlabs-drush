Facter.add('hasdrush') do
  if File.exist? "/usr/local/bin/drush"
    "installed"
  end
end

Facter.add('hasdrush') do
  setcode do
    if File.exist? "/usr/local/bin/drush"
      true
    else
      false
    end
  end
end