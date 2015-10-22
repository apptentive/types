require "types/ejson"

class Time
  EJSON::TYPES << self

  def as_json(*)
    { _type: "datetime", sec: to_f }.as_json
  end

  def self.is_ejson?(json)
    json["_type"] == "datetime"
  end

  def self.from_ejson(ejson)
    Time.at(ejson["sec"])
  end
end
