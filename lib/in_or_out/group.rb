require 'border_patrol'

module InOrOut
  class Group

    def self.label_records records, polygons, latitude_column, longitude_column
      output = []

      records.each do |record|
        group_found = false
        point = BorderPatrol::Point.new(record[longitude_column].to_f, record[latitude_column].to_f)
        polygons.each_with_index do |p, idx|
          if p.contains_point? point
            group_found = true
            if p.placemark_name
              output << (record << p.placemark_name)
            else
              output << (record << "AREA #{(idx + 1)}")
            end
            break
          end
        end

        unless group_found
          output << (record << "NO GROUP")
        end
      end

      output
    end

  end
end
