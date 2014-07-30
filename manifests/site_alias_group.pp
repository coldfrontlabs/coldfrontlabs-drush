# Add an instance of an *.aliases.drushrc.php file
define drush::site_alias_group($name, $aliases = undef, $description = undef) {

  file {"/etc/drush/${name}.aliases.drushrc.php":
    ensure => 'file',
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('drush/php.erb'),
    require => [
      File['/etc/drush'],
    ]
  }

  concat::fragment {"drush-site-alias-{$name}":
    target => "/etc/drush/${name}.aliases.drushrc.php",
    content => template('drush/aliases.drushrc.erb'),
    require => [
      File['/etc/drush'],
    ]
  }
}

#  <% if uri != "" %>'uri' => '<%= uri %>',<% end %>
#  <% if db_url != "" %>'db-url' => '<%= db_url %>',<% end %>
#  <% if remote_host != "" %>'remote-host' => '<%= remote_host %>',<% end %>
#  <% if remote_user != "" %>'remote-user' => '<%= remote_user %>',<% end %>
#  <% if os != "" %>'os' => '<%= os %>',<% end %>
#