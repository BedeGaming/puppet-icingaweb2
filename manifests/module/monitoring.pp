# == Class: icingaweb2::module::monitoring
#
# Manage the monitoring module. This module is mandatory for probably every setup.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
# [*protected_customvars*]
#   Custom variables in Icinga 2 may contain sensible information. Set patterns for custom variables that should be
#   hidden in the web interface. Defaults to `*pw*,*pass*,community`
#
# [*ido_type*]
#   Type of your IDO database. Either `mysql` or `pgsql`. Defaults to `mysql`
#
# [*ido_host*]
#   Hostname of the IDO database.
#
# [*ido_port*]
#   Port of the IDO database. Defaults to `3306`
#
# [*ido_db_name*]
#   Name of the IDO database.
#
# [*ido_db_username*]
#   Username for IDO DB connection.
#
# [*ido_db_password*]
#   Password for IDO DB connection.
#
# [*commandtransports*]
#   A hash of command transports.
#
class icingaweb2::module::monitoring(
  $ensure               = 'present',
  $protected_customvars = ['*pw*', '*pass*', 'community'],
  $ido_type             = 'mysql',
  $ido_host             = undef,
  $ido_port             = 3306,
  $ido_db_name          = undef,
  $ido_db_username      = undef,
  $ido_db_password      = undef,
  $commandtransports    = undef,
){

  validate_re($ensure,
    [
      'absent',
      'present',
    ],
    "${ensure} isn't supported. Valid values are 'absent' and 'present'"
  )
  validate_re($ido_type,
    [
      'mysql',
      'pgsql',
    ],
    "${ido_type} isn't supported. Valid values are 'mysql' and 'pgsql'"
  )
  if $ido_host { validate_string($ido_host) }
  validate_integer($ido_port,65535,1)
  if $ido_name { validate_string($ido_name) }
  if $ido_username { validate_string($ido_username) }
  if $ido_password { validate_string($ido_password) }

  $conf_dir        = $::icingaweb2::params::conf_dir
  $module_conf_dir = "${conf_dir}/modules/monitoring"

  case $::osfamily {
    'Debian': {
      $install_method = 'package'
      $package_name   = 'icingaweb2-module-monitoring'
    }
    default: {
      $install_method = 'none'
      $package_name   = undef
    }
  }

  icingaweb2::config::resource { 'icingaweb2-module-monitoring':
    type        => 'db',
    db_type     => $ido_type,
    host        => $ido_host,
    port        => $ido_port,
    db_name     => $ido_db_name,
    db_username => $ido_db_username,
    db_password => $ido_db_password,
  }

  $backend_settings = {
    'type'     => 'ido',
    'resource' => 'icingaweb2-module-monitoring',
  }

  $security_settings = {
    'protected_customvars' => join($protected_customvars, ',')
  }

  $settings = {
    'module-monitoring-backends' => {
      'section_name' => 'backends',
      'target'       => "${module_conf_dir}/backends.ini",
      'settings'     => delete_undef_values($backend_settings)
    },
    'module-monitoring-security' => {
      'section_name' => 'security',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($security_settings)
    }
  }

  create_resources('icingaweb2::module::monitoring::commandtransport', $commandtransports)

  icingaweb2::module {'monitoring':
    ensure         => $ensure,
    install_method => $install_method,
    package_name   => $package_name,
    settings       => $settings,
  }
}
