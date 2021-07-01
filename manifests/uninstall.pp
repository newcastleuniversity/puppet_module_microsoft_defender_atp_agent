# @summary Uninstalls MS Defender ATP agent, removes onboarding file
#
# @api public
#
# @example
#   include ms_defender_atp_agent::uninstall
#
class ms_defender_atp_agent::uninstall {

  $package_name     = lookup('ms_defender_atp_agent::package_name')
  $target_json_path = lookup('ms_defender_atp_agent::target_json_path')

  package { $package_name:
    ensure => purged,
  }

  file { $target_json_path:
    ensure => absent,
  }

}
