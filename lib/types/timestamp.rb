class Apptentive::Timestamp
  EJSON::TYPES << self

  attr_accessor :time, :local

  def initialize(time, local = false)
    if time.respond_to?(:to_time)
      @time = time.to_time
    elsif time.is_a?(Numeric)
      @time = Time.at(time)
    else
      raise ArgumentError, "Invalid Timestamp time: #{time.inspect}"
    end

    @local = !!local
  end

  # serialization
  def as_json(*)
    { _type: "timestamp", sec: @time.to_f, local: (@local || false) }
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
end