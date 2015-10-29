module Apptentive
  class Version
    include Comparable
    EJSON::TYPES << self

    attr_accessor :code

    def initialize(code)
      if /(?<ver>\d+(\.\d+)*)/ =~ code
        @code = ver.split(".").map(&:to_i)
      else
        raise ArgumentError, "Invalid Version: #{code.inspect}"
      end
    end

    def <=>(that)
      code <=> (that.respond_to?(:code) ? that.code : that)
    end

    # (E)JSON serialization
    def as_json(*)
      { _type: "version", version: @code.join(".") }.as_json
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
