require "spec_helper"
require "types/ejson"
require "types/timestamp"
require "types/version"

describe EJSON do
  it "EJSON::TYPES" do
    expect(EJSON::TYPES).to match_array [Apptentive::Timestamp, Apptentive::Version, Time, Regexp, EJSON::ObjectId]
  end

  context ".parse" do
    it "with String" do
      id = EJSON::ObjectId.new
      expect( EJSON.parse("{\"id\":{\"$oid\":\"#{id.to_s}\"}}") ).to eq('id' => id)
    end

    it "with Hash" do
      id = EJSON::ObjectId.new
      expect( EJSON.parse('id' => { '$oid' => id.to_s }) ).to eq('id' => id)
    end
  end

  describe Object do
    subject { Object.new }

    it "#as_ejson" do
      expect(subject.as_ejson).to eq subject.as_json
    end

    it "#to_ejson" do
      expect(subject.to_ejson).to eq subject.to_json
    end

    it "#from_ejson!" do
      expect(subject.from_ejson!).to eq subject
    end

    it ".from_ejson" do
      expect(described_class.from_ejson(42)).to eq 42
    end
  end

  describe Array do
    subject { [ EJSON::ObjectId.new, Time.now.round, 42 ] }

    it "#as_ejson" do
      expect(subject.as_ejson).to eq([ subject[0].as_ejson, subject[1].as_ejson, 42 ])
    end

    it "#from_ejson!" do
      expect(subject.as_ejson.from_ejson!).to eq subject
    end

    it ".from_ejson" do
      expect(described_class.from_ejson(subject.as_ejson)).to eq subject
    end
  end

  describe Hash do
    subject { { foo: { bar: Time.now.round } } }

    it "#as_ejson" do
      expect(subject.as_ejson).to eq( foo: { bar: subject[:foo][:bar].as_ejson } )
    end

    it "#from_ejson!" do
      expect(subject.as_ejson.from_ejson!).to eq subject
    end

    it ".ejson_type" do
      expect(described_class.ejson_type(Time.now.as_ejson)).to be Time
      expect(described_class.ejson_type(EJSON::ObjectId.new.as_ejson)).to be EJSON::ObjectId
    end

    it ".from_ejson" do
      expect(described_class.from_ejson(subject.as_ejson)).to eq subject
    end
  end
end
