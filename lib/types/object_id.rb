require "types/ejson"

if Gem::Specification.find_all_by_name('bson').any?
  # BSON (Mongoid v4+)
  require 'bson'
  EJSON::ObjectId = BSON::ObjectId

elsif Gem::Specification.find_all_by_name('moped').any?
  # Moped v1
  require 'moped/bson'
  EJSON::ObjectId = Moped::BSON::ObjectId
end

# see http://docs.mongodb.org/manual/reference/mongodb-extended-json/#oid
if defined?(EJSON::ObjectId)
  EJSON::ObjectId.class_eval do
    EJSON::TYPES << self

    def as_ejson(*args)
      { '$oid' => to_s }
    end

    def self.is_ejson?(json)
      json.keys == %w($oid)
    end

    def self.from_ejson(ejson)
      BSON::ObjectId.from_string(ejson['$oid'])
    end
  end
end
