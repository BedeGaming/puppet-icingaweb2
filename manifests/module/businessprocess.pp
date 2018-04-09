# == Class: icingaweb2::module::businessprocess
#
# Install and enable the businessprocess module.
#
# === Parameters
#
# [*ensure*]
#   Enable or disable module. Defaults to `present`
#
# [*git_repository*]
#   Set a git repository URL. Defaults to github.
#
# [*git_revision*]
#   Set either a branch or a tag name, eg. `master` or `v2.1.0`.
#
class icingaweb2::module::businessprocess(
  $ensure         = 'present',
  $git_repository = 'https://github.com/Icinga/icingaweb2-module-businessprocess.git',
  $git_revision   = undef,
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

  icingaweb2::module {'businessprocess':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
  }
}
