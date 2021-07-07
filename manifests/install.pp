# @summary Install MDATP package
#
# @api private
#
class microsoft_defender_atp_agent::install {

    $p = lookup('microsoft_defender_atp_agent::package_name')

    package { $p:
      ensure => latest,
    }
    # This service is installed and started by the package.
    # The service resource here force starts and force enables the service,
    # in case the machine user decides to turn it off.
    -> service { $p:
      ensure => running,
      enable => true,
    }

}
