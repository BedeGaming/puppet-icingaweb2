# == Define: icingaweb2::module::elasticsearch::eventtype
#
# Manage an Elasticsearch event types
#
# === Parameters
#
# [*name*]
#   Name of the event type.
#
# [*instance*]
#   Elasticsearch instance to connect to.
#
# [*index*]
#   Elasticsearch index pattern, e.g. `filebeat-*`.
#
# [*filter*]
#   Elasticsearch filter in the Icinga Web 2 URL filter format. Host macros are evaluated if you encapsulate them in
#   curly braces, e.g. `host={host.name}&location={_host_location}`.
#
# [*fields*]
#   Comma-separated list of field names to display. One or more wildcard asterisk (`*`) patterns are also accepted.
#   Note that the `@timestamp` field is always respected.
#
define icingaweb2::module::elasticsearch::eventtype(
  $instance = undef,
  $index    = undef,
  $filter   = undef,
  $fields   = undef,
){
  assert_private("You're not supposed to use this defined type manually.")

  validate_string($instance)
  validate_string($index)
  validate_string($filter)
  validate_string($fields)

  $conf_dir        = $::icingaweb2::params::conf_dir
  $module_conf_dir = "${conf_dir}/modules/elasticsearch"

  $eventtype_settings = {
    'instance' => $instance,
    'index'    => $index,
    'filter'   => $filter,
    'fields'   => $fields,
  }

  icingaweb2::inisection { "elasticsearch-eventtype-${name}":
    section_name => $name,
    target       => "${module_conf_dir}/eventtypes.ini",
    settings     => delete_undef_values($eventtype_settings)
  }
}
