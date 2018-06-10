MOBO_X = 171;
MOBO_Y = 171;
MOBO_Z = 45; // approx mobo clearance, 45mm
MOBO_UNDERCLEARANCE = 5; // I SWEAR IT CAN'T BE MORE THAN 5mm.
THICCNESS = 2;
// Modify this shit when you figure out where the CPU sits on the motherboard
FAN_X = 71; // 71 from closest side
FAN_Y = 91; // 91 mm from back
FAN_Z = MOBO_Z + 50;
FAN_RADIUS = 104.5/2;
SHROUD_NOTCH_RADIUS = FAN_RADIUS+6; // that dang AMD braded protrusion
SHROUD_NOTCH_ARC_LENGTH = 29;

POWER_BUTTON_DIAMETER = 6;

module motherboard (show_vents=1) {
  color([0.75,0.2,0.2]) cube([MOBO_X, MOBO_Y, MOBO_Z]);
  cpu_fan();
  component_panel();
  power_panel();
  if (show_vents) {
    difference() {
      union () {
        top_vents(12,12);
        side_vents(2,12);
      }
      union () {
        cpu_fan_reinforcement();
        case_reinforcement();
      }
    }
  };
}
translate ([-1.5*MOBO_X,0,0]) motherboard(show_vents=0); 

module component_panel() {
  translate([2,-5,2]) cube([159,10,40]);
}

module power_panel() {
  translate([THICCNESS*2,MOBO_Y - 2*THICCNESS,THICCNESS]) cube([MOBO_X - 4*THICCNESS,10,40]);
}


module cpu_fan() {
  translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=FAN_RADIUS); // cooler
  intersection () {
    translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=SHROUD_NOTCH_RADIUS); // cooler shroud thing
    translate([FAN_X - SHROUD_NOTCH_ARC_LENGTH/2,10,0]) cube([SHROUD_NOTCH_ARC_LENGTH,40,100]);
  }
}
module cpu_fan_reinforcement() {
  translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=FAN_RADIUS + 1.5*THICCNESS); // cooler
  intersection () {
    translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=SHROUD_NOTCH_RADIUS + 1.5*THICCNESS); // cooler shroud thing
    translate([FAN_X - SHROUD_NOTCH_ARC_LENGTH/2,10,0]) cube([SHROUD_NOTCH_ARC_LENGTH + 1.5*THICCNESS ,40,100]);
  }
}


VENT_SIZE = 12;
VENT_WIDTH = 12;
VENT_SPACING = 1/2;
VENT_OFFSET = (VENT_WIDTH + VENT_SPACING)/2;
module top_vents(rows, columns) {
  translate([-38,-35,0]) {
    vxc = VENT_SIZE+VENT_SPACING; // vx constant
    vyc = VENT_WIDTH+VENT_SPACING;
    for (vx = [0:vxc:vxc*rows]) {
      for (vy = [0:vyc:vyc*columns]) {
        offset = VENT_OFFSET * ((vx/vxc) % 2);
        translate ([vx, vy - offset, 0]) top_vent();
      }
    }
  }
}
module top_vent(height = 2.5*MOBO_Z) {
  $fn = 6;
   scale ([1,VENT_WIDTH/VENT_SIZE,1]) color ([0.7, 0.2, 0.5]) translate ([50,50,-50]) cylinder(h=height, r=VENT_SIZE/2);
}

module side_vents(rows, columns) {
  translate([0, -35, 85]) {
    rotate ([0,90,0]) {
      vxc = VENT_SIZE+VENT_SPACING; // vx constant
      vyc = VENT_WIDTH+VENT_SPACING;
      for (vx = [0:vxc:rows*vxc]) {
        for (vy = [0:vyc:columns*vyc]) {
          offset = VENT_OFFSET * ((vx/vxc) % 2);
          translate ([vx, vy - offset, 0]) top_vent(1.5*MOBO_X);
        }
      }
    }
  }
}

module case_reinforcement() {
  translate ([-THICCNESS,-1*THICCNESS + FAN_Y,-THICCNESS]) cube([MOBO_X + 2*THICCNESS, 2*THICCNESS, MOBO_Z + 2*THICCNESS]);
}

module case_front() { // this has the front panel
  case_length = (FAN_Y ) + THICCNESS;
  color([1,0.80,0])  difference () {
    translate ([-THICCNESS,-THICCNESS,-THICCNESS]) cube([MOBO_X + 2*THICCNESS, case_length, MOBO_Z + 2*THICCNESS]);
    motherboard();
  }
  translate ([-THICCNESS,-THICCNESS,-THICCNESS])  mobo_rail(case_length);
  translate ([-3*THICCNESS + MOBO_X,-THICCNESS,-THICCNESS])  mobo_rail(case_length);
};
translate ([0,-50,0]) case_front();

module case_back() {
  // translate ([-MOBO_X ,-MOBO_Y,0]) case_front();
  case_length = (MOBO_Y - FAN_Y) + 2*THICCNESS;
  color([1,0.80,0])  difference () {
    translate ([-THICCNESS,FAN_Y,-THICCNESS])
      cube([MOBO_X + 2*THICCNESS, case_length, MOBO_Z + 2*THICCNESS]);
    motherboard();
  }
  translate ([-THICCNESS,FAN_Y,-THICCNESS]) mobo_rail(case_length);
  translate ([-3*THICCNESS + MOBO_X,FAN_Y,-THICCNESS]) mobo_rail(case_length);
}

module mobo_rail(length) {
  color([1,0.7,0]) translate ([THICCNESS,0,THICCNESS]) cube([4,length, MOBO_UNDERCLEARANCE]);
}
case_back();