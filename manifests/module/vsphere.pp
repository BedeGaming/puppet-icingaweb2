# == Class: icingaweb2::module::vsphere
#
# The vSphere module extends the Director. It provides import sources for virtual machines and physical hosts
# from vSphere.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
#
class icingaweb2::module::vsphere(
  $ensure           = 'present',
  $git_repository   = 'https://github.com/Icinga/icingaweb2-module-vsphere.git',
  $git_revision     = undef,
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

  icingaweb2::module { 'vsphere':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }
}
