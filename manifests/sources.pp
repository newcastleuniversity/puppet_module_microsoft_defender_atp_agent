# @summary This sets up the Apt or Yum sources so that your computer or server can install Defender.
#
# @api private
#
# @see https://github.com/MicrosoftDocs/microsoft-365-docs/blob/public/microsoft-365/security/defender-endpoint/linux-install-with-puppet.md#contents-of-install_mdatpmanifestsinitpp
# @see https://github.com/voxpupuli/facterdb
#
class microsoft_defender_atp_agent::sources {

  case $microsoft_defender_atp_agent::distro {

    /(debian|ubuntu)/: {

      include apt

      apt::source { 'microsoftpackages' :
        location => "https://packages.microsoft.com/${microsoft_defender_atp_agent::distro}/${microsoft_defender_atp_agent::version}/prod",
        release  => $microsoft_defender_atp_agent::channel,
        repos    => 'main',
        key      => {
          'id'     => 'BC528686B50D79E339D3721CEB3E94ADBE1229CF',
          'server' => $microsoft_defender_atp_agent::keyserver,
        },
      }

    }

    /(centos|rhel)/: {

      yumrepo { 'microsoftpackages' :
        baseurl  => "https://packages.microsoft.com/${microsoft_defender_atp_agent::distro}/${microsoft_defender_atp_agent::version}/${microsoft_defender_atp_agent::channel}",
        descr    => "packages-microsoft-com-prod-${microsoft_defender_atp_agent::channel}",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'https://packages.microsoft.com/keys/microsoft.asc'
      }
    }

    default: {
      fail('Your GNU/Linux distribution is not supported.') # Should never get to this, install.pp should have already failed compilation
    }

  }

}
