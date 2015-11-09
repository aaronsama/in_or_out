In Or Out?
======

This is a very simple Ruby script to label a set of points according to their location inside given areas. I developed it to solve a very specific problem that might or might not be useful to you: I had a table containing people names and their address (already geocoded using [this script](https://github.com/veltman/csvgeocode)) and I wanted to automatically find who was in which area on a map I made with Google My Maps.

It takes in input:

* A CSV file containing whatever data you want with latitude and longitude columns
* A KML file containing your labeled polygons

And it outputs a CSV file with a new column containing the label of the polygon each point belongs to.

Requirements
----

Just `rake install`. If you use `rbenv` don't forget to `rbenv rehash`.

Usage
----

Type `in_or_out help` for the full help.

```bash
Commands:
  in_or_out group CSV_FILE KML_FILE OUTPUT_FILE
  # Assigns a group to each point in a CSV_FILE based on the area...
  in_or_out help [COMMAND]
  # Describe available commands or one specific command
```

Acknowledgements
----

* Finding out if a point is inside a polygon: http://jakescruggs.blogspot.com/2009/07/point-inside-polygon-in-ruby.html
* [BorderPatrol](https://github.com/square/border_patrol) by Square Inc.

Upcoming features
----

* Batch geocoding of addresses (porting part of [this script](https://github.com/veltman/csvgeocode) to Ruby)
