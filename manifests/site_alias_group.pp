# Add an instance of an *.aliases.drushrc.php file
define drush::site_alias_group($name, $aliases = undef, $description = undef) {

  concat {"/etc/drush/${name}.aliases.drushrc.php":
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  concat::fragment {"drush-site-alias-sig-{$name}":
    target => "/etc/drush/${name}.aliases.drushrc.php",
    content => template('drush/php.erb'),
    order => 1,
    require => [
      File['/etc/drush'],
    ],
  }

  concat::fragment {"drush-site-alias-{$name}":
    target => "/etc/drush/${name}.aliases.drushrc.php",
    content => template('drush/aliases.drushrc.erb'),
    order => 2,
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