Facter.add('hasdrush') do
  setcode do
    if File.exist? "/usr/local/bin/drush"
      'installed'
    else
      'not-installed'
    end
  end
end
