MOBO_X = 171;
MOBO_Y = 174;
MOBO_Z = 45; // approx mobo clearance, 45mm
MOBO_UNDERCLEARANCE = 5; // I SWEAR IT CAN'T BE MORE THAN 5mm.
THICCNESS = 2;
// Modify this shit when you figure out where the CPU sits on the motherboard
FAN_X = 71; // 71 from closest side
FAN_Y = 81.5; // 81.5 mm from back
FAN_Z = MOBO_Z + 17.5;
echo(FAN_Y);
FAN_RADIUS = 104.5/2;
SHROUD_NOTCH_RADIUS = FAN_RADIUS+6; // that dang AMD braded protrusion
SHROUD_NOTCH_ARC_LENGTH = 29;

VENT_SIZE = 12;
VENT_WIDTH = 12;
VENT_SPACING = 1/2;
VENT_OFFSET = (VENT_WIDTH + VENT_SPACING)/2;
VENT_SHAPE = 6; // 6 = hexagon sides

POWER_BUTTON_DIAMETER = 7;

use <panel.scad>;
use <panel_components.scad>;
/* Assembly */
//translate ([-1.5*MOBO_X,0,0]) motherboard( show_vents=0);
translate ([0,-50,0]) case_front();
//case_back();
//translate ([185,0,50]) rotate([0,180,0])  power_button();
//translate([-250, -200, 0]) cpu_fan_grill();
//translate([0,-200,0]) component_test_panel();

/* Definitions */
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

module power_button() {
    color([0.8,0.2,0]) difference() {
    scale([0.95,1,1]) union () {
      vent(2*THICCNESS);
      translate([0,0,THICCNESS]) vent(THICCNESS, THICCNESS);
    }
    cylinder(h=2*THICCNESS, r=POWER_BUTTON_DIAMETER/2);
  }
}

CUTOUT_ADJUST_X = 15;
COMPONENT_SCALE = 1.035;
cs = [COMPONENT_SCALE, COMPONENT_SCALE, COMPONENT_SCALE];
module component_panel() {
  scale(cs)  translate ([-11,3,-2]) {
    translate([CUTOUT_ADJUST_X, -4,9]) panel();
    translate([CUTOUT_ADJUST_X, -9.5,9]) panel_components();
  }
}

module component_test_panel() {
  difference () {
    translate([2,-2,2]) cube([159,2,40]);
   component_panel();
  }
}


module power_panel() {
  translate([THICCNESS*2,MOBO_Y - 2*THICCNESS,THICCNESS]) cube([MOBO_X - 4*THICCNESS,10,40]);
}

FAN_CLIP_INNER_DISTANCE = 40;
FAN_CLIP_OUTER_DISTANCE = 70;
module cpu_fan() {
  difference () {
    union () {
      translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=FAN_RADIUS); // cooler
      intersection () {
        translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=SHROUD_NOTCH_RADIUS); // cooler shroud thing
        translate([FAN_X - SHROUD_NOTCH_ARC_LENGTH/2,10,0]) cube([SHROUD_NOTCH_ARC_LENGTH,40,100]);
      }
    }
    difference() { // The clip/grill mounting holes
      union () {
        translate([0,(FAN_Y-FAN_CLIP_INNER_DISTANCE/2) - 8,MOBO_Z + 5]) cube([FAN_RADIUS*2 + 50,10,3]);
        translate([0,(FAN_Y+FAN_CLIP_INNER_DISTANCE/2) - 2,MOBO_Z + 5]) cube([FAN_RADIUS*2 + 50,10,3]);
      }
      translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=FAN_RADIUS - 1.2);
    }
  }

}

GRILL_HEIGHT = 15;
module cpu_fan_grill() {
  $fa = 1;
  GRILL_THICCNESS = THICCNESS/2;
  color([1,0.80,0])
  difference () {
    translate ([0,0,FAN_Z - GRILL_HEIGHT]) union () {
      difference() {
        translate([FAN_X, FAN_Y,0]) cylinder(h=GRILL_HEIGHT + GRILL_THICCNESS, r=FAN_RADIUS + GRILL_THICCNESS); // cooler
        difference () {
          difference() {
            translate ([5,15,60]) top_vents(10, 9, -0.4);
          }
          difference () {
            translate([FAN_X, FAN_Y,0]) cylinder(h=GRILL_HEIGHT + GRILL_THICCNESS, r=FAN_RADIUS + GRILL_THICCNESS); // cooler
            translate([FAN_X, FAN_Y,0]) cylinder(h=GRILL_HEIGHT + GRILL_THICCNESS, r=FAN_RADIUS); // cooler
          }
        }
      }
      intersection () {
        translate([FAN_X, FAN_Y,0]) cylinder(h=GRILL_HEIGHT, r=SHROUD_NOTCH_RADIUS+GRILL_THICCNESS); // cooler shroud thing
        translate([FAN_X - SHROUD_NOTCH_ARC_LENGTH/2 - GRILL_THICCNESS,10,0]) cube([SHROUD_NOTCH_ARC_LENGTH+GRILL_THICCNESS*2,40,100]);
      }
    }
    cpu_fan();
  }

}


module cpu_fan_reinforcement() {
  translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=FAN_RADIUS + 1.5*THICCNESS); // cooler
  intersection () {
    translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=SHROUD_NOTCH_RADIUS + 1.5*THICCNESS); // cooler shroud thing
    translate([FAN_X - SHROUD_NOTCH_ARC_LENGTH/2,10,0]) cube([SHROUD_NOTCH_ARC_LENGTH + 1.5*THICCNESS ,40,100]);
  }
}

module top_vents(rows, columns, spacing = VENT_SPACING) {
  translate([-38,-35,0]) {
    vxc = VENT_SIZE+spacing; // vx constant
    vyc = VENT_WIDTH+spacing;
    for (vx = [0:vxc:vxc*rows]) {
      for (vy = [0:vyc:vyc*columns]) {
        offset = VENT_OFFSET * ((vx/vxc) % 2);
        translate ([vx, vy - offset, 0]) top_vent();
      }
    }
  }
}
module top_vent(height = 2.5*MOBO_Z) {
   color ([0.7, 0.2, 0.5]) translate ([50,50,-50]) vent(height);
}
module vent(height, radius_offset = 0) {
  $fn = VENT_SHAPE;
  cylinder(h=height, r=VENT_SIZE/2 + radius_offset);
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

module case_front() { // this is where all the plugs are
  case_length = (FAN_Y ) + THICCNESS;
  color([1,0.80,0])  difference () {
    translate ([-THICCNESS,-THICCNESS,-THICCNESS]) cube([MOBO_X + 2*THICCNESS, case_length, MOBO_Z + 2*THICCNESS]);
    motherboard();
  }
  translate ([-THICCNESS,-THICCNESS,-THICCNESS])  mobo_rail(case_length);
  translate ([-3*THICCNESS + MOBO_X,-THICCNESS,-THICCNESS])  mobo_rail(case_length);
};


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
