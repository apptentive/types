module Apptentive
  class Version
    include Comparable
    EJSON::TYPES << self

    attr_accessor :code

    def initialize(code)
      if /\A(?<ver>\d+(\.\d+)*)\z/ =~ code.to_s
        @code = ver.split(".").map(&:to_i)
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

    # MongoDB serialization
    def __bson_dump__(*args)
      as_json.__bson_dump__(*args)
    end
  end
end
