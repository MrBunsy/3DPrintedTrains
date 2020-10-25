/*

Aim is a fully configurable generator of different styles of old two-axle freight.

I've already created a fruit-van, which I will attempt to wrap up in this new configuration

*/

include <constants.scad>
include <fruit_van.scad>
include <truck_base.scad>

//bit that holds the wheels
GEN_BASE = true;
//the "truck" or "fruit van" bit
GEN_TOP = true;
//optional roof for fruit van
GEN_ROOF = true;

//generate all the parts in there final (not printable) positions, for pretty models and inspection
GEN_IN_SITU = true;

/*
 - van : fruit van, with variants for holding pi&camera or battery
 TODO varying heights (planks) of truck
*/
TYPE="van";

/*
 - normal : nothing special, a to-scale model of the TYPE
 - pi : potentially oversized variant of TYPE that can house a pi and camera
 - batter: potentially slightly oversized variant of TYPE that can house a battery
*/

VARIANT="normal";

//for reasons entirely unknown, the following doesn't work, hence this workaroudn:
//length=VARIANT == "pi" ? 85 : 75;
gen_pi_cam_wagon = VARIANT == "pi";
gen_battery_wagon = VARIANT == "battery";

length=gen_pi_cam_wagon ? 85 : 75;
//height of the apex of the ends
van_height=gen_pi_cam_wagon ? 31+8 : 31;
//+1 for the girder thickness
width=gen_pi_cam_wagon ? 35+1 : gen_battery_wagon ? 29+wall_thick*2 :30+1;


if(GEN_TOP){
	if(TYPE=="van"){
		fruit_van(width,length,van_height, gen_pi_cam_wagon, gen_battery_wagon);
	}
}

if(GEN_BASE){
	optional_rotate([0,180,0],GEN_IN_SITU){
		if(TYPE=="van"){
			truck_base(width,length);
		}
	}
}