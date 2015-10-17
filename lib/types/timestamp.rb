require 'types/ejson'

module Apptentive
  class Timestamp
    include Comparable
    EJSON::TYPES << self

    attr_accessor :time, :local
    alias_method :to_time, :time

    def initialize(time, local = nil)
      if time.respond_to?(:to_time)
        @time = time.to_time
      elsif time.is_a?(Numeric)
        @time = Time.at(time)
      else
        raise ArgumentError, "Invalid Timestamp time: #{time.inspect}"
      end

      @local = !!local
    end

    def <=>(that)
      time <=> that.to_time
    end

    # (E)JSON serialization
    def as_json(*)
      { _type: "timestamp", sec: @time.to_f, local: @local }.as_json
    end

    def self.is_ejson?(json)
      json["_type"] == "timestamp"
    end

    def self.from_ejson(ejson)
      unless (ejson.keys - ["local"]).sort == %w(_type sec)
        raise ArgumentError, "Invalid Timestamp json: #{ejson.inspect}"
      end
      new( ejson["sec"], ejson["local"] )
    end

    # MongoDB serialization
    def __bson_dump__(*args)
      as_json.__bson_dump__(*args)
    end
  end
end