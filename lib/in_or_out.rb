require 'thor'
require 'border_patrol'
require 'csv'

require 'in_or_out/placemark_name'
require 'in_or_out/group'
require 'in_or_out/geocode'

# require 'in_or_out/placemark_name'
# require 'pry'

module InOrOut
  class Main < Thor
    desc "group CSV_FILE KML_FILE OUTPUT_FILE", "Assigns a group to each point in a CSV_FILE based on the areas defined as polygons in a KML_FILE"
    long_desc <<-LONGDESC
      Reads an input CSV_FILE of geocoded points (i.e. records that have a latitude and longitude columns) and a KML_FILE containing polygons.
      The group command labels each point according to its belonging to one of the polygons in the KML_FILE. If a point does not belong to any polygon it is labeled as "NO GROUP".
      The csv OUTPUT_FILE will have the same content of the input CSV with a new column at the end indicating the label.
    LONGDESC
    method_option :latitude_column, desc: "The name of the column containing the latitude", default: "latitude"
    method_option :longitude_column, desc: "The name of the column containing the longitude", default: "longitude"
    # method_option :csv_file, :desc => "Path to a CSV file with latitude and longitude columns"
    # method_option :kml_file, :desc => "Path to a KML file containing the polygons to use for checking where the points belong"
    def group(csv_file, kml_file, output_file)
      in_data = CSV.read(csv_file, headers: true)

      if (in_data.headers & [options[:latitude_column],options[:longitude_column]]).any?
        polygons = BorderPatrol.parse_kml File.read(kml_file)

        CSV.open(output_file, "wb", write_headers: true, headers: (in_data.headers + ["GROUP"])) do |output_csv|
          grouped_data = InOrOut::Group.label_records in_data, polygons, options[:latitude_column], options[:longitude_column]

          grouped_data.each do |line|
            output_csv << line
          end
        end
      else
        puts "ERROR: The columns '#{options[:latitude_column]}' and '#{options[:longitude_column]}' could not be found in the headers of #{csv_file}"
      end
    end

    desc "geocode CSV_FILE OUTPUT_FILE", "gecode all the entries in the input CSV_FILE"
    method_option :address, desc: "The format of the address using the format %{...} to wrap column names. Example %{street} %{city}", required: true
    def geocode(csv_file, output_file)
      in_data = CSV.read(csv_file, headers: true)

      puts "Geocoding #{in_data.size} entries. Please wait..."

      begin
        out_data = Geocode.geocode(in_data)

        CSV.open(output_file, "wb", write_headers: true, headers: (in_data.headers + ["latitude","longitude"])) do |output_csv|
          out_data.each do |line|
            output_csv << line
          end
        end
      rescue AddressTemplateError => error
        puts error
      end

    end
  end
end

# InOrOut::Main.start
