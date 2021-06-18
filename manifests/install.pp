# @summary Install or uninstall Defender agent
#
# @api private

class ms_defender_atp_agent::install (
  Boolean $ensure = true,
) {

  if $ensure == false {

    package { 'mdatp': ensure => 'purged' }

  } else {

    package { 'mdatp': ensure => 'latest' }

  }

}
