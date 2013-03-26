class bacula::sd (
  $sd_label                   = $::bacula::params::sd_label,
  $sd_port                    = $::bacula::params::sd_port,
  $config_root                = $::bacula::params::config_root,
  $working_dir                = $::bacula::params::working_dir,
  $pid_dir                    = $::bacula::params::pid_dir,
  $max_concurrent_jobs        = $::bacula::params::sd_max_concurrent_jobs,
  $messages                   = $::bacula::params::sd_messages,
  $director_server            = $::bacula::params::director_server,
  $director_password          = $::bacula::params::director_password,
  $bconsole_pkgname           = $::bacula::params::bconsole_pkgname,
  $log_dir                    = $::bacula::params::log_dir,
  $storage_dir                = $::bacula::params::storage_dir,
  $sd_service_name            = $::bacula::params::sd_service_name,
  $sd_service_ensure          = $::bacula::params::sd_service_ensure,
  $sd_service_enable          = $::bacula::params::sd_service_enable,
  $sd_service_hasstatus       = $::bacula::params::sd_service_hasstatus,
  $messages_mailcommand       = $::bacula::params::messages_mailcommand,
  $messages_operatorcommand   = $::bacula::params::messages_operatorcommand,
) inherits ::bacula::params {

  include ::bacula::common

  include ::bacula::sd::install
  include ::bacula::sd::config
  include ::bacula::sd::service

  Class[::bacula::sd::install] -> Class[::bacula::sd::config] -> Class[::bacula::sd::service]

}
