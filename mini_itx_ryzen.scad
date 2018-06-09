MOBO_X = 170;
MOBO_Y = 170;
MOBO_Z = 45; // approx mobo clearance, 45mm
THICCNESS = 2;
// Modify this shit when you figure out where the CPU sits on the motherboard
FAN_X = MOBO_X/2 + 20;
FAN_Y = MOBO_Y/2 + 10;
FAN_Z = MOBO_Z + 10;
FAN_RADIUS = 45;

module motherboard (show_vents=1) {
  color([0.75,0.2,0.2]) cube([MOBO_X, MOBO_Y, MOBO_Z]);
  cpu_fan();
  if (show_vents) vents();
}
translate ([-1.5*MOBO_X,0,0]) motherboard(show_vents=0); 

module cpu_fan() {
  translate([FAN_X, FAN_Y,0]) cylinder(h=FAN_Z, r=FAN_RADIUS); // cooler
}


VENT_SIZE = 30;
VENT_WIDTH = 3;
module vents() {
  for (vx = [-30:VENT_SIZE+2:110]) {
    for (vy = [-2:VENT_WIDTH+2.5:165]) {
      translate ([vx, vy, 0]) vent();
    }
  }
}
module vent() {
   scale ([1,VENT_WIDTH/VENT_SIZE,1]) color ([0.7, 0.2, 0.5]) translate ([50,50,-50]) cylinder(h=2.5*MOBO_Z, r=VENT_SIZE/2);
}

module case_front() {
  color([0.2,0.75,0.2])  difference () {
    translate ([-THICCNESS,-THICCNESS,-THICCNESS]) cube([MOBO_X + 2*THICCNESS, MOBO_Y/2 + THICCNESS, MOBO_Z + 2*THICCNESS]);
    motherboard();
  }
};
translate ([0,-50,0]) case_front();

module case_back() {
  // translate ([-MOBO_X ,-MOBO_Y,0]) case_front();
  color([0.2,0.75,0.2])  difference () {
    translate ([-THICCNESS,-THICCNESS+MOBO_Y/2,-THICCNESS]) cube([MOBO_X + 2*THICCNESS, MOBO_Y/2 + 2*THICCNESS, MOBO_Z + 2*THICCNESS]);
    motherboard();
  }
}
translate ([0,50,0]) case_back();