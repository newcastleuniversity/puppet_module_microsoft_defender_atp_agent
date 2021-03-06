# frozen_string_literal: true

require 'spec_helper'

describe 'microsoft_defender_atp_agent::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # it { pp catalogue.resources }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('mdatp').with('ensure' => 'latest') }
      it { is_expected.to contain_service('mdatp').with('ensure' => 'running', 'enable' => 'true') }
    end
  end
end
