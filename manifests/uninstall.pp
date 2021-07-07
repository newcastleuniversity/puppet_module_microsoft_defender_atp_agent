# @summary Uninstalls MS Defender ATP agent, removes onboarding file
#
# @api public
#
# @example
#   include microsoft_defender_atp_agent::uninstall
#
class microsoft_defender_atp_agent::uninstall {

  $package_name     = lookup('microsoft_defender_atp_agent::package_name')
  $target_json_path = lookup('microsoft_defender_atp_agent::target_json_path')

  package { $package_name:
    ensure => purged,
  }

  file { $target_json_path:
    ensure => absent,
  }

}
