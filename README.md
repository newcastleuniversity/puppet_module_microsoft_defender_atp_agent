# ms_defender_atp_agent

## Table of Contents

1. [Description](#description)
1. [Beginning with ms_defender_atp_agent](#beginning-with-ms_defender_atp_agent)
   * [Soft dependencies](#soft-dependencies)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

  Installs the Microsoft Defender for Endpoint agent (herein, "the agent") onto supported GNU/Linux systems.  Attempts to automate many of the steps in the [official MS Defender Puppet documentation][1].

##  Beginning with ms_defender_atp_agent

You will need to get the "onboarding package" from whoever is responsible for managing the Microsoft Defender for Endpoint subscription for your site and put the JSON file that it contains somewhere that Puppet agents can see it. The location of this JSON file is a parameter for this module.

### Soft dependencies

* On Debian and derivatives, you need the *puppetlabs/apt* module.
* On RedHat and derivatives, you need the *puppetlabs/yumrepo_core* module.

## Usage

### Installation and configuration of the agent with "roles and profiles" pattern

[Roles and profiles primer][1] for the unfamiliar.

In *yourcontrolrepo/Puppetfile*, add an entry to include this repo as a Puppet module.

In *yourcontrolrepo/site/profiles*, say `pdk new class my_defender_agent` (or whatever name you find useful).

Drop the *mdatp_onboard.json* file into *yourcontrolrepo/site/profiles/files/mdatp_onboard.json* (or a sub-folder of *files* if you find that useful).

*my_defender_atp.pp* should say something like:

```
class { ms_defender_atp_agent: onboarding_json_file => 'puppet:///modules/my_defender_agent/mtapd_onboard.json' }
```

Then your roles classes just say `include my_defender_agent`.

### Uninstallation of the agent

```
class { ms_defender_atp_agent: ensure => false }
```

## Limitations



## Development

How to contribute to this repo:
- Raise bug reports in the issue page,
  - that contain what Puppet version you were using, what supporting modules and their versions, your manifest, etc,
  - that show what you expected to see versus what you actually saw.
- Request features in the issue page,
  - that state a clear user story for the new feature.
- Submit pull requests,
  - with unit tests,
  - with a clear statement of what the PR adds or fixes.
- For the above, be civil.
  - Don't harass people.
  - Don't treat people unfairly on the basis of actual or perceived [age, disability, gender reassignment, marriage or civil partnership, pregnancy or maternity, race, religion or belief, sex, or sexual orientation][2].
  - Presume good faith because second-language English speakers and some neurological conditions (e.g. autism) can seem rude without meaning to.
  - If you think @threepistons (project owner) has been uncivil, please ping @ChrisRitson. TODO check that Chris is OK with this continuing post-Evolution.
- For the above, give a name you are willing to be known as in the Contributors list, unless you are happy for me to glean it from your GitHub profile card.

## Release Notes/Contributors/Etc.

Based on code samples made by [Microsoft][3].

### Contributors

[1]: https://puppet.com/docs/pe/2019.8/osp/the_roles_and_profiles_method.html
[2]: https://www.legislation.gov.uk/ukpga/2010/15/section/4/enacted
[3]: https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/linux-install-with-puppet
