require "types/ejson"

# see http://docs.mongodb.org/manual/reference/mongodb-extended-json/#date
class Time
  EJSON::TYPES << self

  def as_ejson
    { '$date' => utc.iso8601 }
  end

  def self.is_ejson?(json)
    json.keys == %w($date)
  end

  def self.from_ejson(ejson)
    Time.parse(ejson['$date'])
  end
end
