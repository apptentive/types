require "spec_helper"
require "types/version"

RSpec.describe Apptentive::Version do
  describe "new version" do
    describe "validation" do
      context "when the version is a decimal-separated list of integers" do
        {
          "1.2.3" => [1, 2, 3],
          "60000" => [60000]
        }.each do |ver, code|
          it "successfully sets up the object" do
            version = Apptentive::Version.new(ver)
            expect(version.code).to eq code
          end
        end
      end
    end
  end

  describe "#as_ejson" do
    let(:version) { Apptentive::Version.new("1.2.3") }

    it "outputs version JSON" do
      expect(version.as_ejson).to eq({ _type: "version", version: "1.2.3" }.as_json)
    end
  end
end
