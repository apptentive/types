require "types/ejson"
require "bson"

module Apptentive
  class Version
    include Comparable
    EJSON::TYPES << self
    VERSION_REGEX = /\A(\d+(\.\d+)*)\z/.freeze
    # A hash (embedded document) is type 0x03 in the BSON spec.
    BSON_TYPE = 3.chr.force_encoding(BSON::BINARY).freeze

    attr_accessor :code

    def self.valid?(code)
      (VERSION_REGEX =~ code.to_s).present?
    end

    def initialize(code)
      if VERSION_REGEX =~ code.to_s
        @code = code.to_s.split(".").map(&:to_i)
      else
        raise ArgumentError, "Invalid Version: '#{code}'"
      end
    end

    def to_s
      code.join(".")
    end
    alias_method :inspect, :to_s

    def <=>(that)
      code <=> (that.respond_to?(:code) ? that.code : that)
    end

    def ==(that)
      (self <=> that) == 0
    end
    alias eq? ==

    def hash
      code.hash
    end

    # (E)JSON serialization
    def as_json(*)
      { _type: "version", version: to_s }.as_json
    end

    def self.is_ejson?(json)
      json["_type"] == "version"
    end

    def self.from_ejson(ejson)
      unless ejson.keys.sort == %w(_type version)
        raise ArgumentError, "Invalid Version json: #{ejson.inspect}"
      end
      new(ejson["version"])
    end

    def bson_type
      BSON_TYPE
    end

    def to_bson(buffer = BSON::ByteBuffer.new, validating_keys = BSON::Config.validating_keys?)
      buffer.put_hash(as_json, validating_keys)
    end
  end
end
