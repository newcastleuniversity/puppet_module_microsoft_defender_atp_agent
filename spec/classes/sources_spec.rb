# frozen_string_literal: true

require 'spec_helper'

describe 'microsoft_defender_atp_agent::sources' do
  ubuntu = {
    supported_os: [
      {
        'operatingsystem'        => 'Ubuntu',
        'operatingsystemrelease' => ['18.04', '20.04', '22.04'],
      },
    ],
  }
  context 'Bare essential parameters' do
    let(:pre_condition) { 'class { microsoft_defender_atp_agent: onboarding_json_file => "puppet:///modules/my_defender_agent/mtapd_onboard.json"}' }

    context 'should fail on Arch' do
      let(:facts) do
        {
          'operatingsystem' => 'ArchLinux'
        }
      end

      it { is_expected.not_to compile } # this is how to test for the 'fail' built-in function because 'fail' results in a compilation error
    end # end of the unsupported OS context

    context 'Should compile on all suuported OSes' do
      on_supported_os.each do |_os, os_facts|
        let(:facts) { os_facts }

        it { is_expected.to compile.with_all_deps }
      end # on_supported_os
    end # compile test on all supported OSes

    context 'Ubuntu tests' do
      on_supported_os(ubuntu).each do |_os, os_facts|
        let(:facts) { os_facts }

        it {
          is_expected.to contain_apt__source('microsoftpackages').with(
            'location' => %r{ubuntu},
            'key'      => {
              'server' => 'hkps://keyserver.ubuntu.com:443',
              'id'     => 'BC528686B50D79E339D3721CEB3E94ADBE1229CF',
            },
          )
        }
      end # on_supported_os
    end # Ubuntu tests

    context 'Ubuntu 22.02 tests' do
      ubuntu22 = {
        supported_os: [
          {
            'operatingsystem'        => 'Ubuntu',
            'operatingsystemrelease' => ['22.04'],
          },
        ],
      }

      on_supported_os(ubuntu22).each do |_os, os_facts|
        let(:facts) { os_facts }

        it { is_expected.to contain_apt__source('microsoftpackages').with('release' => 'jammy') }
      end # on_supported_os
    end # U 22.04

    context 'Debian tests' do
      debian = {
        supported_os: [
          {
            'operatingsystem'        => 'Debian',
            'operatingsystemrelease' => ['9', '10', '11'],
          },
        ],
      }

      on_supported_os(debian).each do |_os, os_facts|
        let(:facts) { os_facts }

        it {
          is_expected.to contain_apt__source('microsoftpackages').with(
            'location' => %r{debian},
            'key'      => {
              'server' => 'hkps://keyserver.ubuntu.com:443',
              'id'     => 'BC528686B50D79E339D3721CEB3E94ADBE1229CF',
            },
          )
        }
      end # on_supported_os
    end # Debian

    context 'CentOS 7 tests' do
      centos7 = {
        supported_os: [
          {
            'operatingsystem'        => 'CentOS',
            'operatingsystemrelease' => ['7'],
          },
        ],
      }

      on_supported_os(centos7).each do |_os, os_facts|
        let(:facts) { os_facts }

        it { is_expected.to contain_yumrepo('microsoftpackages').with('baseurl' => %r{centos}) }
      end # on_supported_os
    end # Centos 7 tests

    context 'RHEL tests' do
      rhel = {
        supported_os: [
          {
            'operatingsystem'        => 'RedHat',
            'operatingsystemrelease' => ['7', '8'],
          },
          {
            'operatingsystem'        => 'OracleLinux',
            'operatingsystemrelease' => ['7', '8', '9'],
          },
          {
            'operatingsystem'        => 'CentOS',
            'operatingsystemrelease' => ['8'],
          },
        ],
      }

      on_supported_os(rhel).each do |_os, os_facts|
        let(:facts) { os_facts }

        it { is_expected.to contain_yumrepo('microsoftpackages').with('baseurl' => %r{rhel}) }
      end # on_supported_os
    end # RHEL tests
  end # Bare essential parameters

  context 'Ubuntu tests with custom source filename' do
    let(:pre_condition) do
      [ 'class { microsoft_defender_atp_agent:',
        'onboarding_json_file => "puppet:///modules/my_defender_agent/mtapd_onboard.json",',
        'sourcename           => "microsoft",',
        '}']
    end

    on_supported_os(ubuntu).each do |_os, os_facts|
      let(:facts) { os_facts }

      it {
        is_expected.to contain_apt__source('microsoft').with(
          'location' => %r{ubuntu},
          'key'      => {
            'server' => 'hkps://keyserver.ubuntu.com:443',
            'id'     => 'BC528686B50D79E339D3721CEB3E94ADBE1229CF',
          },
        )
      }
    end # on_supported_os
  end # Ubuntu tests with custom source filename
end # describe
