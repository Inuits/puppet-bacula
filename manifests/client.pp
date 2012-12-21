define bacula::client (
  $storage_server   = $::bacula::params::default_storage_server,
  $storage_path     = $::bacula::params::default_storage_path,
  $storage_password = $::bacula::params::default_storage_password,
  $device_owner     = $::bacula::params::default_device_owner,
  $device_group     = $::bacula::params::default_device_group,
  $fd_port          = $::bacula::params::fd_port,
  $sd_server        = $::bacula::params::sd_server,
  $sd_port          = $::bacula::params::sd_port,
  $sd_password      = $::bacula::params::sd_password,
  $config_root      = $::bacula::params::config_root,
) {

  concat{"${config_root}/clients.d/${title}.conf":
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
  }

  concat::fragment{"${config_root}/clients.d/${title}.conf-client":
    target  => "${config_root}/clients.d/${title}.conf",
    content => template('bacula/client.erb'),
    order   => 01,
  }

  @@bacula::storage{$title:
    config_root => $config_root,
    sd_server   => $sd_server,
    sd_port     => $sd_port,
    sd_password => $sd_password,
  }

  @@bacula::device{$title:
    config_root => $config_root,
    path        => "${storage_path}/${title}",
    owner       => $device_owner,
    group       => $device_group,
  }

}
