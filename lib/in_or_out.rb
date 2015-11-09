require 'thor'
require 'border_patrol'
require 'csv'

class InOrOut < Thor
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
    latitude_column = options[:latitude_column] || "latitude"
    longitude_column = options[:longitude_column] || "longitude"

    in_data = CSV.read(csv_file, headers: true)

    if (in_data.headers & [latitude_column,longitude_column]).any?
      polygons = BorderPatrol.parse_kml File.read(kml_file)

      CSV.open(output_file, "wb", write_headers: true, headers: (in_data.headers + ["GROUP"])) do |output_csv|
        in_data.each do |line|
          group_found = false
          point = BorderPatrol::Point.new(line[longitude_column].to_f, line[latitude_column].to_f)
          polygons.each_with_index do |p, idx|
            if p.contains_point? point
              group_found = true
              if p.placemark_name
                output_csv << (line << p.placemark_name)
              else
                output_csv << (line << "AREA #{(idx + 1)}")
              end
              break
            end
          end

          unless group_found
            output_csv << (line << "NO GROUP")
          end
        end
      end
    else
      puts "ERROR: The columns '#{latitude_column}' and '#{longitude_column}' could not be found in the headers of #{csv_file}"
    end
  end
end

InOrOut.start
