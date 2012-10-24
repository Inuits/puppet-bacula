# TODO: Remove include concat::setup and replace with require.
# TODO: Change commands to templates.
# TODO: Put some stuff in params.
# TODO: Remove firewall rules / put them in a split off class (make it optional)
# TODO: Update documentation.
#
class bacula::director {

  include concat::setup

  package{'bacula-director-mysql':
    ensure   => 'latest',
    require  => Package['mysql-server'],
  }

  file{'/usr/sbin/bacula-dir.mysql':
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  file{'/etc/bacula/clients.d':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
  }

  file{'/etc/bacula/filesets.d':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
  }

  file{'/etc/bacula/schedules.d':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
  }

  file{'/etc/bacula/jobdefs.d':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
  }

  file{'/etc/bacula/bacula-dir.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package['bacula-director-mysql'],
    notify  => Service['bacula-dir'],
    content => template('bacula/bacula-dir.conf.erb'),
  }

  mysql::db{$::bacula::dbname:
    user => $::bacula::dbuser,
    host => $::bacula::dbhost,
  }

  exec{'bacula-db-tables':
    command     => $::operatingsystem ? {
      centos => "/usr/libexec/bacula/make_bacula_tables -u${::bacula::dbuser} -p${::bacula::dbpassword}",
      debian => "/usr/share/bacula-director/make_mysql_tables -u${::bacula::dbuser} -p${::bacula::dbpassword}",
    },
    environment => "db_name=${::bacula::dbname}",
    subscribe   => Package['bacula-director-mysql'],
    require     => Mysql::Db[$::bacula::dbname],
    unless      => "/usr/bin/mysqlshow -uroot -p${::bacula::dbpassword} ${::bacula::dbname} | grep Version",
    before      => Service['bacula-dir'],
  }

  service{'bacula-dir':
    name      => $::operatingsystem ? {
      default => 'bacula-dir',
      debian  => 'bacula-director',
    },
    ensure    => 'running',
    enable    => true,
    hasstatus => $::operatingsystem ? {
      default => undef,
      debian  => false,
    },
    require   => [
      Package['bacula-director-mysql'],
      Service['mysqld']
    ],
  }

  Bacula::Client <<| |>>
  Bacula::Fileset <<| |>>

}
