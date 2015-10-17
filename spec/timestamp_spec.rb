require "spec_helper"
require "types/timestamp"

describe Apptentive::Timestamp do
  subject { described_class.new(Time.at(Time.now.to_f)) }

  it "#as_ejson" do
    expect(subject.as_ejson).to eq("_type" => "timestamp", "sec" => subject.time.to_f, "local" => false)
  end

  it ".is_ejson?" do
    expect(described_class.is_ejson?(subject.as_ejson)).to eq true
    expect(described_class.is_ejson?(foo: 42)).to eq false
  end

  it ".from_ejson" do
    expect(described_class.from_ejson(subject.as_ejson).time.to_f).to eq subject.time.to_f
  end
end
