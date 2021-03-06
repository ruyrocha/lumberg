require "spec_helper"

module Lumberg
  module Whostmgr
    describe Ssl do
      let(:ssl)    {  described_class.new(server: server) }
      let(:domain) { "lumberg-test.com" }

      let(:server) do
        Whm::Server.new(host: @whm_host, hash: @whm_hash, whostmgr: true)
      end

      describe "#remove" do
        use_vcr_cassette "whostmgr/ssl/remove"

        it "removes the cert" do
          ssl.remove(
            domain: domain
          )[:message].should eq "You have successfully deleted the SSL host"
        end
      end
    end
  end
end
