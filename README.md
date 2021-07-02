# ms_defender_atp_agent

## Table of Contents

1. [Description](#description)
1. [Beginning with ms_defender_atp_agent](#beginning-with-ms_defender_atp_agent)
   - [Soft dependencies](#soft-dependencies)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Installs the Microsoft Defender for Endpoint agent (herein, "the agent") onto supported GNU/Linux systems.  Attempts to automate many of the steps in the [official MS Defender Puppet documentation][1].

Features include:
- Each Puppet run starts the agent service if, for some reason, it has stopped.
- Two custom facts, *mdatp_is_healthy* and *mdatp_is_licensed*, that show up in your Foreman (or similar) dashboard so you can monitor the agent across your fleet.
- Customisable parameters as outlined in [REFERENCE.md](REFERENCE.md).
- An uninstaller class.

##  Beginning with ms_defender_atp_agent

You will need to get the "onboarding package" from whoever is responsible for managing the Microsoft Defender for Endpoint subscription for your site and put the JSON file that it generates somewhere that Puppet agents can see it. The location of this JSON file is a parameter for this module.

The package I got contained a Python file that generated the JSON file. 

### Soft dependencies

- On Debian and derivatives, you need the *puppetlabs/apt* module.
- On RedHat and derivatives, you need the *puppetlabs/yumrepo_core* module.

## Usage

### Installation and configuration of the agent with "roles and profiles" pattern

[Roles and profiles primer][1] for the unfamiliar.

In *yourcontrolrepo/Puppetfile*, add an entry to include this repo as a Puppet module.

In *yourcontrolrepo/site/profiles*, say `pdk new class my_defender_agent` (or whatever name you find useful).

Drop the *mdatp_onboard.json* file into *yourcontrolrepo/site/profiles/files/mdatp_onboard.json* (or a sub-folder of *files* if you find that useful).

*my_defender_atp.pp* should say something like:

```
class { ms_defender_atp_agent: onboarding_json_file => 'puppet:///modules/profiles/mtapd_onboard.json' }
```

Then your roles classes just say `include my_defender_agent`.

### Uninstallation of the agent and onboarding file

```
include ms_defender_atp_agent::uninstall
```

## Limitations

It doesn't support any GNU/Linux distributions that I don't support in my job. Pull requests are welcome as long as you have written exhaustive RSpec tests.

## Development

How to contribute to this repo:
- Raise bug reports in the issue page,
  - that contain what Puppet version you were using, what supporting modules and their versions, your manifest, etc,
  - that show what you expected to see versus what you actually saw.
- Request features in the issue page,
  - that state a clear user story for the new feature.
- Submit pull requests,
  - with exhaustive tests,
  - with all instances of `it { pp catalogue.resources }` removed or commented out, it's really useful but also really noisy,
  - with new classes and parameters documented and then run `puppet strings generate --format=markdown`,
  - with a clear statement of what the PR adds or fixes.
- For the above, be civil.
  - Don't harass people nor call them names.
  - Don't treat people unfairly on the basis of actual or perceived [age, disability, gender reassignment, marriage or civil partnership, pregnancy or maternity, race, religion or belief, sex, or sexual orientation][2].
  - Incivility can be highlighted to @threepistons (project owner) by @-mentioning me. I will consider barring the uncivil person from contributing, especially if they are persistent in being uncivil.
  - If you think @threepistons (project owner) has been uncivil, please @-mention @ChrisRitson. TODO check that Chris is OK with this continuing post-Evolution.
- For the above, give a name you are willing to be known as in the Contributors list, unless you are happy for me to glean it from your GitHub profile card.

## Release Notes/Contributors/Etc.

Based on code samples made by [Microsoft][3].

### Contributors

[1]: https://puppet.com/docs/pe/2019.8/osp/the_roles_and_profiles_method.html
[2]: https://www.legislation.gov.uk/ukpga/2010/15/section/4/enacted
[3]: https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/linux-install-with-puppet
