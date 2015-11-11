require 'pry'
require 'geocoder'

module InOrOut
  class AddressTemplateError < StandardError
  end

  class Geocode

    def self.geocode records, address_template
      if validate_template(address_template, records.headers)
        records.map do |r|
          r["latitude"], r["longitude"] = Geocoder.coordinates(build_address_string_for r, address_template)
          r
        end
      else
        raise AddressTemplateError.new, "Some keys in the address template do not match any column"
      end
    end

    private

    def self.build_address_string_for record, template
      column_values = {}

      template.scan /\%\{([^\}]+)\}/ do |col_name|
        column_values[col_name.first.to_sym] = record[col_name.first]
      end

      template % column_values
    end

    def self.validate_template template, headers
      template_keys = template.scan(/\%\{([^\}]+)\}/).flatten
      (template_keys & headers) == template_keys
    end
  end
end
