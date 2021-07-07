# frozen_string_literal: true

require 'spec_helper'

describe 'microsoft_defender_atp_agent::uninstall' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('mdatp').with('ensure' => 'purged') }
      it { is_expected.to contain_file('/etc/opt/microsoft/mdatp/mdatp_onboard.json').with('ensure' => 'absent') }
    end
  end
end
