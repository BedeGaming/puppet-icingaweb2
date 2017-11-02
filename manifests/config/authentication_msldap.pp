# == Define: icingaweb2::config::authentication_ldap
#
# Sets up an authentication definition for LDAP.
#
define icingaweb2::config::authentication_msldap (
  $auth_section = $title,
  $auth_resource = undef,
  $backend = 'msldap',
){

  Ini_Setting {
    ensure  => present,
    require => File["${::icingaweb2::config_dir}/authentication.ini"],
    path    => "${::icingaweb2::config_dir}/authentication.ini",
  }

  ini_setting { "icingaweb2 authentication ${title} resource":
    section => $auth_section,
    setting => 'resource',
    value   => "\"${auth_resource}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} backend":
    section => $auth_section,
    setting => 'backend',
    value   => "\"${backend}\"",
  }

}

