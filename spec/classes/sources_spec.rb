# frozen_string_literal: true

require 'spec_helper'

describe 'ms_defender_atp_agent::sources' do
  context 'should fail on Arch' do
    let(:facts) do
      {
        'operatingsystem' => 'ArchLinux'
      }
    end

    it { is_expected.not_to compile } # this is how to test for the 'fail' built-in function because 'fail' results in a compilation error
  end # end of the unsupported OS context

  context 'Ubuntu tests' do
    ubuntu = {
      supported_os: [
        {
          'operatingsystem'        => 'Ubuntu',
          'operatingsystemrelease' => ['18.04', '20.04'],
        },
      ],
    }

    on_supported_os(ubuntu).each do |_os, os_facts|
      let(:facts) { os_facts }

      it { is_expected.to contain_apt__source('microsoftpackages').with('location' => %r{ubuntu}) }
    end
  end

  context 'Debian tests' do
    debian = {
      supported_os: [
        {
          'operatingsystem'        => 'Debian',
          'operatingsystemrelease' => ['9', '10'],
        },
      ],
    }

    on_supported_os(debian).each do |_os, os_facts|
      let(:facts) { os_facts }

      it { is_expected.to contain_apt__source('microsoftpackages').with('location' => %r{debian}) }
    end
  end

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
    end
  end

  context 'RHEL tests' do
    rhel = {
      supported_os: [
        {
          'operatingsystem'        => 'RedHat',
          'operatingsystemrelease' => ['7', '8'],
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
    end
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
