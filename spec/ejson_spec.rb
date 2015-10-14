require "spec_helper"
require "types/ejson"

describe EJSON do
  it "EJSON::TYPES" do
    expect(EJSON::TYPES).to match_array [Time, Regexp, BSON::ObjectId]
  end

  context ".parse" do
    it "with String" do
      id = BSON::ObjectId.new
      expect( EJSON.parse("{\"id\":{\"$oid\":\"#{id.to_s}\"}}") ).to eq('id' => id)
    end

    it "with Hash" do
      id = BSON::ObjectId.new
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

    it ".is_ejson?" do
      expect(described_class.is_ejson?({})).to eq false
    end
  end

  describe Array do
    subject { [ BSON::ObjectId.new, Time.now.round, 42 ] }

    it "#as_ejson" do
      expect(subject.as_ejson).to eq([ subject[0].as_ejson, subject[1].as_ejson, 42 ])
    end

    it "#from_ejson!" do
      expect(subject.as_ejson.from_ejson!).to eq subject
    end

    it ".is_ejson?" do
      expect(described_class.is_ejson?(subject.as_ejson)).to eq true
      expect(described_class.is_ejson?(foo: 42)).to eq false
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

    it ".is_ejson?" do
      expect(described_class.is_ejson?(subject.as_ejson)).to be_falsy
    end

    it ".from_ejson" do
      expect(described_class.from_ejson(subject.as_ejson)).to eq subject
    end
  end
end
