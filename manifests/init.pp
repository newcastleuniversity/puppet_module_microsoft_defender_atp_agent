# @summary Puppet module to install Microsoft Defender for Endpoint on Linux.
#
# @param onboarding_json_file Source (as in *file* resource attribute called *source*) of the JSON file extracted from your site's Defender onboarding package.
# @param channel The release channel you want to use.
# @param manage_sources Allows you to manage the repository sources yourself (false) or allow this module to manage them for you (true).
# @param distro Allows you to override the distro MS say you should state to get the right package. I calculate this for you in Hiera.
# @param version Allows you to override the distro version you claim to have to get the right package.
#
# @see https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/linux-install-with-puppet?view=o365-worldwide#contents-of-install_mdatpmanifestsinitpp
#
# @api public
#
# @example
#   class { 'microsoft_defender_atp_agent': onboarding_json_file => 'puppet:///path/to/your/file.json' }
#
class microsoft_defender_atp_agent (
  # Automatic parameter lookup never works for me so I used lookup(), which also lets me do these very obvious defaults-with-overrides.
  Stdlib::Filesource $onboarding_json_file,
  # If default_distro isn't in the module Hiera, compilation should fail
  Optional[String] $distro,
  Optional[String] $version = $::facts['os']['release']['major'],
  Optional[Enum['prod','insiders-fast','insiders-slow','nightly','testing']] $channel, # prod
  Optional[Boolean] $manage_sources, # true
  Optional[String] $sourcename, # microsoftpackages
  Optional[String] $keyserver # hkps://keyserver.ubuntu.com:443
) {
  # I run a lot of armhf Pis and this endpoint agent won't work on them because the
  # packages only come as amd64, so I filter out non-amd64 architectures.
  # The Power9 nodes in the HPC won't run the agent either.
  # @see https://packages.microsoft.com/debian/10/prod/pool/main/m/mdatp/
  if !($::facts['os']['architecture'] in ['amd64','x86_64']) { # This horrible conditional because RedHat calls amd64 x86_64
    fail("Microsoft make no Defender agent for ${::facts['os']['architecture']}.")
  } # No "else"" needed because "fail" halts compilation.

  contain microsoft_defender_atp_agent::sources
  contain microsoft_defender_atp_agent::config
  contain microsoft_defender_atp_agent::install

  case $manage_sources {
    false: {
      Class[microsoft_defender_atp_agent::config]
      ~> Class[microsoft_defender_atp_agent::install]
    }

    default: {
      Class[microsoft_defender_atp_agent::sources]
      ~> Class[microsoft_defender_atp_agent::config]
      ~> Class[microsoft_defender_atp_agent::install]
    }
  }
}
