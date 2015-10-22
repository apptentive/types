require "spec_helper"
require "types/duration"

describe Apptentive::Duration do
  subject { described_class.new(60*60) }

  it "#as_ejson" do
    expect(subject.as_ejson).to eq("_type" => "duration", "sec" => subject.to_f)
  end

  it ".is_ejson?" do
    expect(described_class.is_ejson?(subject.as_ejson)).to eq true
    expect(described_class.is_ejson?(foo: 42)).to eq false
  end

  it ".from_ejson" do
    expect(described_class.from_ejson(subject.as_ejson).to_f).to eq subject.to_f
  end
end
