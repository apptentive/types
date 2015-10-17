require "spec_helper"
require "types/object_id"

describe EJSON::ObjectId do
  subject { EJSON::ObjectId.new }

  it "#as_ejson" do
    expect(subject.as_ejson).to eq('$oid' => subject.to_s)
  end

  it ".is_ejson?" do
    expect(described_class.is_ejson?(subject.as_ejson)).to eq true
    expect(described_class.is_ejson?(foo: 42)).to eq false
  end

  it ".from_ejson" do
    expect(described_class.from_ejson(subject.as_ejson)).to eq subject
  end
end

