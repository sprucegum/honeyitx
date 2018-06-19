
// Module names are of the form poly_<inkscape-path-id>().  As a result,
// you can associate a polygon in this OpenSCAD program with the corresponding
// SVG element in the Inkscape document by looking for the XML element with
// the attribute id="inkscape-path-id".

// fudge value is used to ensure that subtracted solids are a tad taller
// in the z dimension than the polygon being subtracted from.  This helps
// keep the resulting .stl file manifold.
fudge = 0.1;

module poly_rect4573(h)
{
  union()
  {
    linear_extrude(height=h)
      polygon([[-28.965108,11.444307],[-13.727834,11.444307],[-13.727834,17.264553],[-28.965108,17.264553]]);
  }
}

module poly_rect4571(h)
{
  union()
  {
    linear_extrude(height=h)
      polygon([[-49.826440,11.444307],[-34.589166,11.444307],[-34.589166,17.264553],[-49.826440,17.264553]]);
  }
}

module poly_rect4581(h)
{
  union()
  {
    linear_extrude(height=h)
      polygon([[-6.861256,2.473834],[6.447796,2.473834],[6.447796,17.264556],[-6.861256,17.264556]]);
  }
}

module poly_rect4585(h)
{
  union()
  {
    linear_extrude(height=h)
      polygon([[33.296551,-16.479788],[57.357642,-16.479788],[57.357642,17.264560],[33.296551,17.264560]]);
  }
}

module poly_rect4587(h)
{
  union()
  {
    linear_extrude(height=h)
      polygon([[59.416649,-17.264560],[69.674534,-17.264560],[69.674534,17.264548],[59.416649,17.264548]]);
  }
}

module poly_rect4583(h)
{
  union()
  {
    linear_extrude(height=h)
      polygon([[11.693431,-12.032869],[30.245387,-12.032869],[30.245387,17.264552],[11.693431,17.264552]]);
  }
}

module poly_rect4567(h)
{
  union()
  {
    linear_extrude(height=h)
      polygon([[-69.674534,-11.499546],[-54.687470,-11.499546],[-54.687470,17.264558],[-69.674534,17.264558]]);
  }
}
module panel(){
  translate([69.674534,0,17.264558]) rotate([-90,0,0]) {
    poly_rect4573(10);
    poly_rect4571(10);
    poly_rect4581(10);
    poly_rect4585(10);
    poly_rect4587(10);
    poly_rect4583(10);
    poly_rect4567(10);
  }
}
panel();
