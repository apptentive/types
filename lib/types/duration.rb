require 'types/ejson'

module Apptentive
  class Duration
    include Comparable
    EJSON::TYPES << self

    def initialize(secs)
      @secs = secs
    end

    def to_f
      @secs
    end

    def <=>(that)
      @secs <=> that.to_f
    end

    # (E)JSON serialization
    def as_json(*)
      { _type: "duration", sec: to_f }.as_json
    end

    def self.is_ejson?(json)
      json["_type"] == "duration"
    end

    def self.from_ejson(ejson)
      new(ejson["sec"])
    end

    # MongoDB serialization
    def __bson_dump__(*args)
      as_json.__bson_dump__(*args)
    end
  end
end