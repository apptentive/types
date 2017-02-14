require "spec_helper"
require "types/version"

RSpec.describe Apptentive::Version do
  describe "new version" do
    describe "validation" do
      context "when the version is a decimal-separated list of integers or a fixnum" do
        {
          "1.2.3" => [1, 2, 3],
          "60000" => [60000],
          1 => [1]
        }.each do |ver, code|
          it "successfully sets up the object" do
            version = Apptentive::Version.new(ver)
            expect(version.code).to eq code
          end
        end
      end

      context "when the version is invalid" do
        [
          "my_version",
          "1.2.",
          "1.2-test",
          ".0",
          "1.2.3\nhello"
        ].each do |ver, code|
          it "(#{ver}) raises and exception" do
            expect { Apptentive::Version.new(ver) }.to raise_error(ArgumentError, "Invalid Version: '#{ver}'")
          end
        end
      end
    end
  end

  describe "#valid?" do
    it "returns true for valid strings" do
      property_of {
        len = integer(1..9)
        deflating = Deflating.new(array(len) { integer(0..300) })
        deflating.array.join(".")
      }.check do |version|
        expect(Apptentive::Version.valid?(version)).to be true
      end
    end

    it "returns false for trailing/leading dot" do
      property_of {
        len = integer(1..9)
        deflating = Deflating.new(array(len) { integer(0..300) })
        leading = boolean
        leading ? "." + deflating.array.join(".") : deflating.array.join(".") + "."
      }.check(50) do |version|
        expect(Apptentive::Version.valid?(version)).to be false
      end
    end

    it "returns false when string contains alphabet" do
      property_of {
        len = integer(3..9)
        deflating = Deflating.new (array(len) {
          version = string(:alnum)
          guard version.match(/[[:alpha:]]/)
        })
        deflating.array.join(".")
      }.check(20) do |version|
        expect(Apptentive::Version.valid?(version)).to be false
      end
    end

    it "returns false on nil" do
      expect(Apptentive::Version.valid?(nil)).to be false
    end
    it "returns false on empty string" do
      expect(Apptentive::Version.valid?("")).to be false
    end
  end

  describe "#as_ejson" do
    let(:version) { Apptentive::Version.new("1.2.3") }

    it "outputs version JSON" do
      expect(version.as_ejson).to eq({ _type: "version", version: "1.2.3" }.as_json)
    end
  end

  describe "supports equality checks" do
    it "recognizes equal values" do
      v1 = Apptentive::Version.new("1.2.3")
      v2 = Apptentive::Version.new("1.2.3")
      expect(v1 == v2).to eq(true)
      expect(v1.eq?(v2)).to eq(true)

      # Test equality using only an input String
      expect(v1 == "1.2.3").to eq(false)
      expect(v1 == [1,2,3]).to eq(true)
    end

    it "recognizes unequal values" do
      v1 = Apptentive::Version.new("1.2.3")
      v2 = Apptentive::Version.new("1.2.4")
      expect(v1 == v2).to eq(false)
      expect(v1 != v2).to eq(true)
      expect(v1.eq?(v2)).to eq(false)
    end
  end

  describe "supports hash" do
    it "instances can be used as keys for Hashes" do
      v1 = Apptentive::Version.new("1.2.3")
      v2 = Apptentive::Version.new("1.2.1")
      hash = { v1 => "bar", v2 => "foo" }

      expect(hash[v1]).to eq("bar")
      expect(hash.sort).to eq([[v2, "foo"], [v1, "bar"]])
    end

    it "generates duplicate hash values for instance with the same contents" do
      v1 = Apptentive::Version.new("1.2.3")
      v2 = Apptentive::Version.new("1.2.3")
      expect(v1.hash).to eq(v2.hash)
    end
  end
end
