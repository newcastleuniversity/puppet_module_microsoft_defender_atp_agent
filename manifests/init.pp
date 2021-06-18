# @summary Puppet manifest to install Microsoft Defender for Endpoint on Linux.
#
# @param ensure False uninstalls the agent, true installs it. Note: false does not remove repositories nor the onboarding file at this time.
# @param channel The release channel based on your environme
# @param onboarding_json_file Path to the JSON file you extracted from the onboarding package that your Defender manager gave you.
# @param manage_sources Allows you to manage the repository sources yourself (false) or allow this module to manage them for you.
#
# @examp
#   class { 'ms_defender_atp_agent': onboarding_json_file => /path/to/your/file.json } # instal
#   class { 'ms_defender_atp_agent': ensure => false } # remov
#
class ms_defender_atp_agent (
  Boolean $ensure                                       = lookup('ms_defender_atp_agent::default_ensure'),
  String $distro                                        = lookup('ms_defender_atp_agent::default_distro'),
  String $version                                       = lookup('ms_defender_atp_agent::default_version'),
  Enum['prod','insiders-fast','insiders-slow'] $channel = lookup('ms_defender_atp_agent::default_channel'),
  Stdlib::Filesource $onboarding_json_file              = lookup('ms_defender_atp_agent::default_onboarding_json_file'),
  Boolean $manage_sources                               = lookup('ms_defender_atp_agent::default_manage_sources')
) {

  # I run a lot of armhf Pis and this endpoint thing won't work on them because the
  # packages only come as amd64, so filter out non-amd64 architectures.
  # @see https://packages.microsoft.com/debian/10/prod/pool/main/m/mdatp/
  if !($::facts['os']['architecture'] in ['amd64','x86_64']) { # This horrible conditional because RedHat calls amd64 x86_64
    fail("Microsoft make no Defender agent for ${::facts['os']['architecture']}.")
  } # No "else"" needed because "fail" halts compilation.

  case $ensure {

    false:   { # Get the uninstaller out of the way early in the code

      class { 'ms_defender_atp_agent::install': ensure => false }

    }

    default: {

      if $onboarding_json_file == '/dev/null' {
        fail('Supply the Defender onboarding package for your site, see README.md for details')
      }

      contain ms_defender_atp_agent::config
      contain ms_defender_atp_agent::install

      case $manage_sources {

        false: {

          Class['ms_defender_atp_agent::config']
          ~> Class['ms_defender_atp_agent::install']

        }

        default: {

          class { 'ms_defender_atp_agent::sources':
            distro  => $distro,
            version => $version,
            channel => $version,
          }

          ~> Class['ms_defender_atp_agent::config']
          ~> Class['ms_defender_atp_agent::install']

        }

      }
    }

  }

}
