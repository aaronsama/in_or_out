# This is partially copied from https://github.com/square/border_patrol/blob/master/lib/border_patrol.rb
# because the gem on rubygems is outdated!

module BorderPatrol
  class Polygon
    attr_reader :placemark_name

    def with_placemark_name(placemark)
      @placemark_name ||= placemark
      self
    end
  end

  def self.parse_kml(string)
    doc = Nokogiri::XML(string)

    polygons = doc.search('Polygon').map do |polygon_kml|
      placemark_name = placemark_name_for_polygon(polygon_kml)
      parse_kml_polygon_data(polygon_kml.to_s).with_placemark_name(placemark_name)
    end
    BorderPatrol::Region.new(polygons)
  end

  private

  def self.placemark_name_for_polygon(p)
    # A polygon can be contained by a MultiGeometry or Placemark
    parent = p.parent
    parent = parent.parent if parent.name == 'MultiGeometry'

    return nil unless parent.name == 'Placemark'

    parent.search('name').text
  end
end
