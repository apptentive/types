require "spec_helper"
require "types/time"

describe Time do
  subject { Time.now }

  it "#as_ejson" do
    expect(subject.as_ejson).to eq("$date" => subject.iso8601)
  end

  it ".is_ejson?" do
    expect(described_class.is_ejson?(subject.as_ejson)).to eq true
    expect(described_class.is_ejson?(foo: 42)).to eq false
  end

  it ".from_ejson" do
    time = subject.round # we don't serialize fractional seconds
    expect(described_class.from_ejson(time.as_ejson)).to eq time
  end
end
