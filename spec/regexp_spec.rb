require "spec_helper"
require "types/regexp"

describe Regexp do
  subject { /foo/i }

  it "#as_ejson" do
    expect(subject.as_ejson).to eq('$regex' => 'foo', '$options' => 'i')
  end

  it ".is_ejson?" do
    expect(described_class.is_ejson?(subject.as_ejson)).to eq true
    expect(described_class.is_ejson?(foo: 42)).to eq false
  end

  it ".from_ejson" do
    expect(described_class.from_ejson(subject.as_ejson)).to eq subject
  end
end
