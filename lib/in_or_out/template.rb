module InOrOut
  class AddressTemplateError < StandardError
  end

  class Template

    def initialize(template_string, headers)
      @headers = headers
      @template_string = template_string

      unless parse_column_names
        raise AddressTemplateError.new, "Some keys in the address template do not match any column"
      end
    end

    def build_address_string_for record
      column_values = {}

      @columns.each do |col_name|
        column_values[col_name.to_sym] = record[col_name]
      end

      @template_string % column_values
    end

    private

    def parse_column_names
      @columns = @template_string.scan(/\%\{([^\}]+)\}/).flatten
      (@columns & @headers) == @columns
    end

  end
end
