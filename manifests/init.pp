# @summary Puppet manifest to install Microsoft Defender for Endpoint on Linux.
#
# @param ensure False uninstalls the agent, true installs it. Default: true
# @param channel The release channel based on your environment, insiders-fast, insiders-slow, or prod. Default: prod
#
# @example
#   include ms_defender_atp_agent # installs
#   class { 'ms_defender_atp_agent': ensure => false } # removes
class ms_defender_atp_agent (
  $ensure  = true,
  $channel = prod,
) {

  case $ensure {

    false:   { # Get the uninstaller out of the way early in the code

      package { 'mdatp':
        ensure => 'purged',
      }

    }

    default: {

      # I run a lot of armhf Pis and this endpoint thing won't work on them because the [packages](https://packages.microsoft.com/debian/10/prod/pool/main/m/mdatp/)
      # only come as amd64, so filter out non-amd64 architectures.

      case $::facts['os']['architecture']  {

        'amd64': {
          # Do useful things
        }

        default: {
          notify { 'needs_amd64':
            message => "${::facts['os']['architecture']} is currently not supported."
          }
        }
      }
    }

  }

}
