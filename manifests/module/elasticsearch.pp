# == Class: icingaweb2::module::elasticsearch
#
# The Elasticsearch module displays events from data stored in Elasticsearch.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
# [*instances*]
#   A hash that configures one or more Elasticsearch instances that this module connects to. The defined type
#   `icingaweb2::module::elasticsearch::instance` is used to create the instance configuration.
#
# [*eventtypes*]
#   A hash oft ypes of events that should be displayed. Event types are always connected to instances. The defined type
#   `icingaweb2::module::elasticsearch::eventtype` is used to create the event types.
#
class icingaweb2::module::elasticsearch(
  $ensure         = 'present',
  $git_repository = 'https://github.com/Icinga/icingaweb2-module-elasticsearch.git',
  $git_revision   = undef,
  $instances      = undef,
  $eventtypes     = undef,
){

  validate_re($ensure,
    [
      'absent',
      'present',
    ],
    "${ensure} isn't supported. Valid values are 'absent' and 'present'"
  )
  validate_string($git_repository)
  if $git_revision { validate_string($git_revision) }
  if $instance { validate_string($instances) }
  if $eventtypes { validate_string($eventtypes) }

  validate_re($ensure,
    [
      'absent',
      'present',
    ],
    "${ensure} isn't supported. Valid values are 'absent' and 'present'"
  )
  validate_string($git_repository)
  if $git_revision { validate_string($git_revision) }

  if $instances {
    $instances.each |$name, $setting| {
      icingaweb2::module::elasticsearch::instance{ $name:
        uri                => $setting['uri'],
        user               => $setting['user'],
        password           => $setting['password'],
        ca                 => $setting['ca'],
        client_certificate => $setting['client_certificate'],
        client_private_key => $setting['client_private_key'],
      }
    }
  }

  if $eventtypes {
    $eventtypes.each |$name, $setting| {
      icingaweb2::module::elasticsearch::eventtype { $name:
        instance => $setting['instance'],
        index    => $setting['index'],
        filter   => $setting['filter'],
        fields   => $setting['fields'],
      }
    }
  }

  icingaweb2::module { 'elasticsearch':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }
}
