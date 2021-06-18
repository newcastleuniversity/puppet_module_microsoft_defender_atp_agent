require 'spec_helper'

describe 'ms_defender_atp_agent' do
  context 'should fail on Pis by default' do
    let(:facts) do
      {
        'os' => {
          'architecture' => 'armv7l',
        }
      }
    end

    it { is_expected.not_to compile } # this is how to test for the 'fail' built-in function because 'fail' results in a compilation error
  end # end of the Pi context
  on_supported_os.each do |os, os_facts|
    context "uninstallation on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          'ensure' => false, # true/false needs to be a bare keyword in Rspec
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('ms_defender_atp_agent::install').with('ensure' => false) }
    end # end of uninstallation test
    context "default parameters on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.not_to compile } #  missing $onboarding_json_file should fail
    end # end of the default parameters test
  end # end of the FacterDB loop
end
