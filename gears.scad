use <MCAD/involute_gears.scad>

//attempt at a gear to match that of the one on the wheel of the x6239 wheels
$fn=100;
outside_r = 9/2;
teeth = 17;
circular_pitch = 360*outside_r/(teeth+2);

gear_height = 2;

bore_d = 2;
hub_d = 3.9;
hub_height = 5.6;

tooth_angle = 9.11;
//twist = gear_height*tan(tooth_angle);
//echo(twist);

//fuck knows what the difference is between rim, hub and gear for thickness
//can't tell if I don't understand or there's a bug.
//so, just make a flat gear and do it myself.
gear(number_of_teeth=teeth, circular_pitch=circular_pitch, twist=tooth_angle, hub_diameter=3.9, bore_diameter=2, rim_thickness = 2,hub_thickness=0);


difference(){
	cylinder(r=hub_d/2,h=hub_height);
	cylinder(r=bore_d/2,h=hub_height*3,center=true);
}

translate([0,0,-hub_height+gear_height])difference(){
	cylinder(r=hub_d/2,h=hub_height);
	cylinder(r=bore_d/2,h=hub_height*3,center=true);
}