# == Define: icingaweb2::config::authentication_ldap
#
# Sets up an authentication definition for LDAP.
#
define icingaweb2::config::authentication_msldap (
  $auth_section = $title,
  $auth_resource = undef,
  $backend = 'msldap',
  $filter = '!(objectComputer)',
  $base_dn = undef,
){

  Ini_Setting {
    ensure  => present,
    section => $auth_section,
    require => File["${::icingaweb2::config_dir}/authentication.ini"],
    path    => "${::icingaweb2::config_dir}/authentication.ini",
  }

  ini_setting { "icingaweb2 authentication ${title} resource":
    setting => 'resource',
    value   => "\"${auth_resource}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} backend":
    setting => 'backend',
    value   => "\"${backend}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} filter":
    setting => 'filter',
    value   => "\"${filter}\"",
  }

  ini_setting { "icingaweb2 authentication ${title} base_dn":
    setting => 'base_dn',
    value   => "\"${base_dn}\"",
  }

}

