MOBO_X = 170;
MOBO_Y = 170;
MOBO_Z = 45; // approx mobo clearance, 45mm
THICCNESS = 2;
// Modify this shit when you figure out where the CPU sits on the motherboard
FAN_X = 84; // 71 from closest side
FAN_Y = 71; // 84mm from back
FAN_Z = MOBO_Z + 50;
FAN_RADIUS = 104.5/2;

module motherboard (show_vents=1) {
  color([0.75,0.2,0.2]) cube([MOBO_X, MOBO_Y, MOBO_Z]);
  cpu_fan();
  if (show_vents) {
    difference() {
      union () {
        top_vents(); 
        side_vents();
      }
      cpu_fan_reinforcement();
    }
  };
}
translate ([-1.5*MOBO_X,0,0]) motherboard(show_vents=0); 

module cpu_fan() {
  translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=FAN_RADIUS); // cooler
}
module cpu_fan_reinforcement() {
  translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=FAN_RADIUS + 4); // cooler
}


VENT_SIZE = 12;
VENT_WIDTH = 12;
VENT_SPACING = 1/2;
VENT_OFFSET = (VENT_WIDTH + VENT_SPACING)/2;
module top_vents() {
  vxc = VENT_SIZE+VENT_SPACING; // vx constant
  vyc = VENT_WIDTH+VENT_SPACING;
  for (vx = [-30:vxc:110]) {
    for (vy = [-25:vyc:110]) {
      offset = VENT_OFFSET * ((vx/vxc) % 2);
      translate ([vx, vy - offset, 0]) top_vent();
    }
  }
}
module top_vent(height = 2.5*MOBO_Z) {
  $fn = 6;
   scale ([1,VENT_WIDTH/VENT_SIZE,1]) color ([0.7, 0.2, 0.5]) translate ([50,50,-50]) cylinder(h=height, r=VENT_SIZE/2);
}

module side_vents() {
  rotate ([0,90,0]) {
    vxc = VENT_SIZE+VENT_SPACING; // vx constant
    vyc = VENT_WIDTH+VENT_SPACING;
    for (vx = [-85:vxc:-50]) {
      for (vy = [-35:vyc:110]) {
        offset = VENT_OFFSET * ((vx/vxc) % 2);
        translate ([vx, vy - offset, 0]) top_vent(1.5*MOBO_X);
      }
    }
  }
}

module case_front() {
  color([1,0.80,0])  difference () {
    translate ([-THICCNESS,-THICCNESS,-THICCNESS]) cube([MOBO_X + 2*THICCNESS, MOBO_Y/2 + THICCNESS, MOBO_Z + 2*THICCNESS]);
    motherboard();
  }
};
translate ([0,-50,0]) case_front();

module case_back() {
  // translate ([-MOBO_X ,-MOBO_Y,0]) case_front();
  color([1,0.80,0])  difference () {
    translate ([-THICCNESS,-THICCNESS+MOBO_Y/2,-THICCNESS]) cube([MOBO_X + 2*THICCNESS, MOBO_Y/2 + 2*THICCNESS, MOBO_Z + 2*THICCNESS]);
    motherboard();
  }
}
translate ([0,50,0]) case_back();