require 'active_support/json'

module EJSON
  TYPES = []

  def self.parse(ejson)
    ejson = JSON.parse(ejson)  if ejson.is_a?(String)
    ejson.class.from_ejson(ejson)
  end
end

class Object
  def as_ejson
    as_json
  end

  def to_ejson
    as_ejson.to_json
  end

  def from_ejson!
    self
  end

  def self.is_ejson?(json)
    false
  end

  def self.from_ejson(json)
    json
  end
end

class Array
  def as_ejson
    map(&:as_ejson)
  end

  def from_ejson!
    each.with_index do |val, idx|
      if val.is_a?(Hash) && (type = Hash.is_ejson?(val))
        self[idx] = type.from_ejson(val)
      else
        val.from_ejson!
      end
    end
    self
  end

  def self.is_ejson?(json)
    json.any? { |el| el.class.is_ejson?(el) }
  end

  def self.from_ejson(ejson)
    ejson.map { |el| el.class.from_ejson(el) }
  end
end

class Hash
  def as_ejson
    map { |key, val| [ key, val.as_ejson ] }.to_h
  end

  def from_ejson!
    keys.each do |key|
      val = self[key]
      if val.is_a?(Hash) && (type = Hash.is_ejson?(val))
        self[key] = type.from_ejson(val)
      else
        val.from_ejson!
      end
    end
    self
  end

  def self.is_ejson?(json)
    json.is_a?(Hash) && EJSON::TYPES.detect { |type| type.is_ejson?(json) }
  end

  def self.from_ejson(ejson)
    if (type = is_ejson?(ejson))
      type.from_ejson(ejson)
    else
      ejson.map { |key, val| [ key, val.class.from_ejson(val) ] }.to_h
    end
  end
end
