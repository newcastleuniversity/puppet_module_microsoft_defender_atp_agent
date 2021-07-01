# @summary Install MDATP package
#
# @api private
#
class ms_defender_atp_agent::install {

    $p = lookup('ms_defender_atp_agent::package_name')

    package { $p :
      ensure => latest,
    }

}
