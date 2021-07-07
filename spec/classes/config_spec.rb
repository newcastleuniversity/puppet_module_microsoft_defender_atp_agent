# frozen_string_literal: true

require 'spec_helper'

describe 'microsoft_defender_atp_agent::config' do
  let(:pre_condition) { 'class { microsoft_defender_atp_agent: onboarding_json_file => "puppet:///modules/my_defender_agent/mtapd_onboard.json"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # it { pp catalogue.resources }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_file('mtapd_onboard.json').with('source' => 'puppet:///modules/my_defender_agent/mtapd_onboard.json') }
      it { is_expected.to contain_file('/etc/opt').with('ensure' => 'directory') }
      it { is_expected.to contain_file('/etc/opt/microsoft').with('ensure' => 'directory') }
      it { is_expected.to contain_file('/etc/opt/microsoft/mdatp').with('ensure' => 'directory') }
    end
  end
end
