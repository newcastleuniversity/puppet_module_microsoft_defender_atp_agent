require 'spec_helper'

describe 'microsoft_defender_atp_agent' do
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
    context "default parameters on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.not_to compile } #  missing $onboarding_json_file should fail
    end # end of the default parameters test

    context "default params plus onboarding JSON file on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          'onboarding_json_file' => 'puppet:///modules/my_defender_agent/mtapd_onboard.json',
        }
      end

      # it { pp catalogue.resources }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('microsoft_defender_atp_agent::sources') }
    end

    context "invalid release on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          'onboarding_json_file' => 'puppet:///modules/my_defender_agent/mtapd_onboard.json',
          'release'              => 'test',
        }
      end

      it { is_expected.not_to compile }
    end
  end # end of the FacterDB loop
end
