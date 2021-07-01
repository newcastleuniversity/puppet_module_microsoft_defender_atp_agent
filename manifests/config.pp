# @summary This installs the "onboarding" file, aka your Defender site licence.
#
# @api private
#
class ms_defender_atp_agent::config {

  $directories = lookup('ms_defender_atp_agent::target_json_tree')

  file { $directories:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  file { 'mtapd_onboard.json':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    path   => lookup('ms_defender_atp_agent::target_json_path'),
    source => $ms_defender_atp_agent::onboarding_json_file,
  }

}
