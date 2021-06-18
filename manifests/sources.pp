# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @api private
#
# @see https://github.com/MicrosoftDocs/microsoft-365-docs/blob/public/microsoft-365/security/defender-endpoint/linux-install-with-puppet.md#contents-of-install_mdatpmanifestsinitpp
# @see https://github.com/voxpupuli/facterdb
#
class ms_defender_atp_agent::sources (
  String $distro  = lookup('ms_defender_atp_agent::default_distro'),
  String $version = lookup('ms_defender_atp_agent::default_version'),
  String $channel = lookup('ms_defender_atp_agent::default_channel')
) {

  if $version != 'nonesuch' {
    $real_version = $version
  } else {
    $real_version = $::facts['os']['release']['major']
  }

  if $distro == 'nonesuch' {
    # > Note your distribution and version and identify the closest entry for it under https://packages.microsoft.com/config/
    # > In the below commands, replace [distro] and [version] with the information you've identified:
    # > [!NOTE] In case of RedHat, Oracle EL, and CentOS 8, replace [distro] with 'rhel'.
    #
    # I got the OS name and version strings from FacterDB and made in-module Hiera under the data directory to cope with the
    # mapping of actual distribution to the string MS want me to use.
    #
    $real_distro = lookup('ms_defender_atp_agent::calculated_distro')
  } else {
    $real_distro = $distro
  }

  case $real_distro {

    /(debian|ubuntu)/: {

      include apt

      apt::source { 'microsoftpackages' :
        location => "https://packages.microsoft.com/${real_distro}/${real_version}/prod",
        release  => $channel,
        repos    => 'main',
        key      => {
          'id'     => 'BC528686B50D79E339D3721CEB3E94ADBE1229CF',
          'server' => 'keyserver.ubuntu.com',
        },
      }

    }

    /(centos|rhel)/: {

      yumrepo { 'microsoftpackages' :
        baseurl  => "https://packages.microsoft.com/${real_distro}/${real_version}/${channel}",
        descr    => "packages-microsoft-com-prod-${channel}",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'https://packages.microsoft.com/keys/microsoft.asc'
      }
    }

    default: {
      fail('Your GNU/Linux distribution is not supported.')
    }

  }

}
