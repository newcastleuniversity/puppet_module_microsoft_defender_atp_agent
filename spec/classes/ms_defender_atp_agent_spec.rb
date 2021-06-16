require 'spec_helper'

describe 'ms_defender_atp_agent' do
  on_supported_os.each do |os, os_facts|
    context "uninstallation on  #{os}" do
      let(:facts) { os_facts }
      let :params do
        {
          'ensure' => false, # true/false needs to be a bare keyword in Rspec
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('mdatp').with('ensure' => 'purged') }
    end
  end
end
