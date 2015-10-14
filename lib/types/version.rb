class Apptentive::Version
  EJSON::TYPES << self

  attr_accessor :code, :name

  def initialize(code, name = nil)
    @name = name
    if /(?<ver>\d+(\.\d+)*)/ =~ code
      @code = ver.split(".").map(&:to_i)
    else
      raise ArgumentError, "Invalid Version: #{code.inspect}"
    end
  end

  def <=>(that)
    code <=> (that.respond_to?(:code) ? that.code : that)
  end

  # (in)equality operators
  %i(< <= > >= == !=).each do |op|
    define_method(op) { |that| (self <=> that).send(op, 0) }
  end

  # serialization
  def as_json(*)
    ejson = { _type: "version", code: @code.join(".") }
    ejson["name"] = @name  if @name
    ejson
  end

  def self.is_ejson?(json)
    json["_type"] == "version"
  end

  def self.from_ejson(ejson)
    unless (ejson.keys - ["name"]).sort == %w(_type code)
      raise ArgumentError, "Invalid Version json: #{ejson.inspect}"
    end
    new( ejson["code"], ejson["name"] )
  end

end
