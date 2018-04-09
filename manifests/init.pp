# == Class: icingaweb2
#
# This module installs and configures Icinga Web 2.
#
# === Parameters
#
# [*logging*]
#   Whether Icinga Web 2 should log to 'file' or to 'syslog'. Setting 'none' disables logging. Defaults to 'file'.
#
# [*logging_file*]
#   If 'logging' is set to 'file', this is the target log file. Defaults to '/var/log/icingaweb2/icingaweb2.log'.
#
# [*logging_level*]
#   Logging verbosity. Possible values are 'ERROR', 'WARNING', 'INFO' and 'DEBUG'. Defaults to 'INFO'.
#
# [*enable_stacktraces*]
#   Whether to display stacktraces in the web interface or not. Defaults to 'false'.
#
# [*module_path*]
#   Path to module sources. Multiple paths must be separated by colon. Defaults to '/usr/share/icingaweb2/modules'.
#
# [*theme*]
#   The default theme setting. Users may override this settings. Defaults to 'icinga'.
#
# [*theme_disabled*]
#   Whether users can change themes or not. Defaults to `false`.
#
# [*manage_repo*]
#   When set to true this module will install the packages.icinga.com repository. With this official repo you can get
#   the latest version of Icinga Web. When set to false the operating systems default will be used. Defaults to false.
#   NOTE: will be ignored if manage_package is set to false.
#
# [*manage_package*]
#   If set to `false` packages aren't managed. Defaults to `true`.
#
# [*extra_pacakges*]
#  An array of packages to install additionally.
#
# [*import_schema*]
#  Import database scheme. Make sure you have an existing database if you use this option. Defaults to `false`
#
# [*db_type*]
#  Database type, can be either `mysql` or `pgsql`. This parameter is only used if `import_schema` is `true` or
#  `config_backend` is `db`. Defaults to `mysql`
#
# [*db_host*]
#  Database hostname. This parameter is only used if `import_schema` is `true` or
#  `config_backend` is `db`. Defaults to `localhost`
#
# [*db_port*]
#  Port of database host. This parameter is only used if `import_schema` is `true` or
#  `config_backend` is `db`. Defaults to `3306`
#
# [*db_name*]
#  Database name. This parameter is only used if `import_schema` is `true` or
#  `config_backend` is `db`. Defaults to `icingaweb2`
#
# [*db_username*]
#  Username for database access. This parameter is only used if `import_schema` is `true` or
#  `config_backend` is `db`.
#
# [*db_password*]
#  Password for database access. This parameter is only used if `import_schema` is `true` or
#  `config_backend` is `db`.
#
# [*config_backend*]
#  The global Icinga Web 2 preferences can either be stored in a database or in ini files. This parameter can either
#  be set to `db` or `ini`. Defaults to `ini`
#
# [*conf_user*]
#  By default this module expects Apache2 on the server. You can change the owner of the config files with this
#  parameter. Default is dependent on the platform
#
# [*default_domain*]
#  When using domain-aware authentication, you can set a default domain here.
#
# === Examples
#
#
class icingaweb2 (
  $logging             = 'file',
  $logging_file        = '/var/log/icingaweb2/icingaweb2.log',
  $logging_level       = 'INFO',
  $show_stacktraces    = false,
  $module_path         = $::icingaweb2::params::module_path,
  $theme               = 'Icinga',
  $theme_disabled      = false,
  $manage_repo         = false,
  $manage_package      = true,
  $extra_packages      = undef,
  $import_schema       = false,
  $db_type             = 'mysql',
  $db_host             = 'localhost',
  $db_port             = 3306,
  $db_name             = 'icingaweb2',
  $db_username         = undef,
  $db_password         = undef,
  $config_backend      = 'ini',
  $conf_user           = $icingaweb2::params::conf_user,
  $default_domain      = undef,
) inherits ::icingaweb2::params {

  anchor { '::icingaweb2::begin': }
  -> class { '::icingaweb2::repo': }
  -> class { '::icingaweb2::install': }
  -> class { '::icingaweb2::config': }
  -> anchor { '::icingaweb2::end': }

  validate_re($logging,
    [
      'file',
      'syslog',
      'none',
    ],
    "${logging} isn't supported. Valid values are 'file', syslog' and 'none'"
  )
  validate_absolute_path($logging_file)
  validate_re($logging_level,
    [
      'ERROR',
      'WARNING',
      'INFO',
      'DEBUG',
    ],
    "${logging_level} isn't supported. Valid values are 'ERROR', 'WARNING', 'INFO' and 'DEBUG'"
  )
  validate_bool($show_stacktraces)
  validate_absolute_path($module_path)
  validate_string($theme)
  validate_bool($theme_disabled)
  validate_bool($manage_repo)
  validate_bool($manage_package)
  if $extra_pacakges { validate_array($extra_pacakges) }
  validate_bool($import_schema)
  validate_re($db_type,
    [
      'mysql',
      'pgsql',
    ],
    "${db_type} isn't supported. Valid values are 'mysql' and 'pgsql'"
  )
  validate_string($db_host)
  validate_integer($db_port,65535,1)
  validate_string($db_name)
  if $db_username { validate_string($db_username) }
  if $db_password { validate_string($db_password) }
  validate_re($config_backend,
    [
      'ini',
      'db',
    ],
    "${config_backend} isn't supported. Valid values are 'ini' and 'db'"
  )
  validate_string($conf_user)
  if $default_domain { validate_string($default_domain) }
}
