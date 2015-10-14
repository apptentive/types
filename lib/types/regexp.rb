require "types/ejson"

# see http://docs.mongodb.org/manual/reference/mongodb-extended-json/#regular-expression
class Regexp
  EJSON::TYPES << self

  def as_ejson
    opts = ''
    opts << 'i'   if self.options & IGNORECASE != 0
    opts << 'ms'  if self.options & MULTILINE != 0
    opts << 'x'   if self.options & EXTENDED != 0
    { '$regex' => source, '$options' => opts }
  end

  def self.is_ejson?(json)
    json.keys.sort == %w($options $regex)
  end

  def self.from_ejson(ejson)
    opts = 0
    opts |= Regexp::IGNORECASE  if ejson['$options'].include?('i')
    opts |= Regexp::MULTILINE   if ejson['$options'].include?('m')
    Regexp.new(ejson['$regex'], opts)
  end
end
