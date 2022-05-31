# Geospatial Data Terms

.. glossary::

    Geospatial data
        Geospatial data is data with geographic location associated with it, i.e. map
        data.  There are two kinds of spatial data, :term:`Raster Data` and
        :term:`Vector Data`.  Each
        has properties that make it better for representing different information.

    Line
        Lines are made up of multiple points, ordered.  Roads and rivers are
        usually represented as lines.

    Point
        Points represent a single location on a 2 dimensional surface.
        Depending on the scale, different types of data are appropriate to be
        represented as points. At a very small :term:`Scale` (from a very great
        distance), a city might be represented as a single point.  Species occurrences
        are usually represented as points.

    Polygon
        Polygons are made up of multiple points or lines, joined to define
        a discrete area.  At a larger scale (zoomed in), a city, river, or street might
        be represented as a polygon. Administrative boundaries, like country, state, or
        other geo-political units are examples of polygon data.

    Scale
        Large scale maps refer to maps of a small area with a large amount of detail.
        The ratio between distance on the map to distance on the ground is very large.
        For example a detailed map of a city might be at 1:5000, meaning that 1 unit on
        the map (i.e. centimeter) equals 5000 units on the ground (5000 centimeters).
        A smaller scale map, for example a regional map used for land-management, might
        be at a scale of 1:100,000 (1 centimeter = 1 kilometer).

        Small scale maps are generally used for mapping large areas.  The ratio of the
        distance on the map to the distance on the ground is much smaller.  For example,
        a map of the country of Indonesia might be at the ratio of 1:2,000,000.

    Raster Data
        Geospatial data best represented in raster format generally has one value at
        every point.  The area to be represented is split up into a grid, with each
        grid cell containing a value. Elevation, temperature, precipitation are
        examples of data generally represented as raster.

    Vector Data
        Geospatial data best represented in vector format can be represented as
        :term:`Point`s, :term:`Line`s, or :term:`Polygon`s.




## Sample Geospatial Data resources

* [World borders]  (http://thematicmapping.org/downloads/world_borders.php)

* [Global administrative boundaries]  http://www.gadm.org/country)

* [Natural earth data] (http://www.naturalearthdata.com/)
