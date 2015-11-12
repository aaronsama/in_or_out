require 'pry'
require 'geocoder'
require 'in_or_out/template'

module InOrOut

  class Geocode
    def self.geocode records, address_template
      template = InOrOut::Template.new(address_template, records.headers)

      records.map do |r|
        r["latitude"], r["longitude"] = Geocoder.coordinates(template.build_address_string_for r)
        r
      end
    end
  end

end
