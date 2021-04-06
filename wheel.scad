/*
Copyright Luke Wallin 2020

This file is part of Luke Wallin's 3DPrintedTrains project.

The 3DPrintedTrains project is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The 3DPrintedTrains project is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with The 3DPrintedTrains project.  If not, see <https:www.gnu.org/licenses/>.
*/

/*

spike bearings without pointed wheels require a 25.65 (point to point) long 2mm diameter axle which ends in two points. I'm using reclaimed dapol axles, but can also use a dremel to add points to a 2mm brass rod

spike bearings with pointed wheels require a < 19.65mm (echoed when generating spike wheel) long 2mm brass rod 

*/

// include <constants.scad>

//spacers to hold said wheels square
GEN_WHEELSET_SPACER = false;
//generate the actual wheel
GEN_WHEEL = true;


//"spike" uses pointed ends of the axle for bearings. "axle" uses the centre of the axle slotting into a holder as a bearing. Wheels are longer for axle bearings and spike bearings require spacers to keep the shorter wheels at right angles
BEARING_TYPE = "spike";

//no flange - only used for centre wheel on class66 currently
DUMMY = false;

//12.5 or 14 for my rolling stock, but this can take any value
DIAMETER = 14;//12.5;

//if false axle is axle_width (25.65mm) long ended in points, if true axle is flat ended and the points are part of the wheels. if BEARING_TYPE is "axle" this is largely irrelevant
WHEEL_POINTED = false;

//TODO
STYLE = "modern";

//NRMA standard S-4.2  https://www.nmra.org/sites/default/files/standards/sandrp/pdf/s-4.2_2019.01.04.pdf
FLANGE_MAX_WIDTH = 0.76;
//NRMA says "17.09" but that's clearly bollocks, using HO
//14.55 still seems large compared to measuring various real wheelsets
//my previous reverse engineered result came out at 14.65, which would be within NRMA tolerance, but struggled on a bit of dodgy track
BACK_TO_BACK = 14.4;// tolerance: +0.05 -0.18, so 14.5 to 14.73
WHEEL_WIDTH = 2.79;
TREAD_WIDTH = WHEEL_WIDTH - FLANGE_MAX_WIDTH;
//might take this one with a pinch of salt. NMRA says OO is 0.71. HO Deep flange is up to 1.19
FLANGE_DEPTH = 2;

//3deg slope - note, this just doesn't print well, so exaggerating
TREAD_SLOPE_HEIGHT = 0.4;//tan(3) * TREAD_WIDTH;
echo(TREAD_SLOPE_HEIGHT);

corner_break = 0.2;

// diameters_12_5mm = [14.6,14.6, 12.5+TREAD_SLOPE_HEIGHT, 12.5, 12.5-corner_break];//not much gradient on the wheel part with this. TODO NMRA recomends 3deg slope
// diameters_14mm = [16.5,16.5, 14.0+TREAD_SLOPE_HEIGHT, 14.0];
//trying making these smaller than the real wheels (powered loco seems fine, but the dummies derail quite easily, even weighted), maybe I should have raised them up on teh class66 after all!
// diameters_14mm_dummy_smaller = [14.2,14.2, 13.75+TREAD_SLOPE_HEIGHT, 13.75];
diameters_14mm_dummy = [14.2,14.2, 13.75+TREAD_SLOPE_HEIGHT, 13.75];
//for the axle-bearing version
depths_thicker = [0.4, FLANGE_MAX_WIDTH-0.4, 2.7];//total 3.4
depths_thinner = [0.4, FLANGE_MAX_WIDTH-0.4, TREAD_WIDTH];

function diameters(nominal_d=12.5) = [nominal_d + FLANGE_DEPTH, nominal_d + FLANGE_DEPTH, nominal_d + TREAD_SLOPE_HEIGHT/2, nominal_d - TREAD_SLOPE_HEIGHT/2];

//sum depths provided
function total_depth(depths, i=0) = depths[i] + (i < len(depths)-1 ? total_depth(depths, i+1) : 0);

//sum depths up to the index provided
function depth_up_to(depths, upto = 1) = total_depth(depths) - (upto < len(depths)-1 ?  total_depth(depths,upto+1) : 0);

//given diameters and depths of a normal wheel, add an extra bit and return [diameters, depths]
function extra_height(diameters, depths, height = 2.5, r = 2.9) = [concat(diameters, [r,r]), concat(depths, [0,height])];

//echo(total_depth(depths));
//might need to make first dpeth longer to reduce wobble?
$fn=1000;

flange_to_point = 5.1;
//intended for a 2mm brass rod of length 21.2mm (better slightly shorter, so it doesn't stick out the ends and therefore is easy to use in a clamp)

//recurive module used by wheel() to generate each segment just from an array of depths and diameters
module wheel_segment(diameters, depths, fn=2000, i=0){
	if(depths[i] > 0){
		cylinder(r1=diameters[i]/2, r2=diameters[i+1]/2, h=depths[i], $fn=fn);
	}
    if(i< len(depths)-1){
        translate([0,0, depths[i]]){
            wheel_segment(diameters, depths, fn, i+1);
        }
    }
}
module wheel(diameters=diameters(14), depths=depths, fn=2000){
	//2mm rod
	//1mm radius works well for the 2mm rod with a clamp, but very hard to get wheel perfectly straight. trying slightly more loose but with more length
	//1.1 works very well indeed for wheels that slide onto the axle, but they are a tiny bit too loose for ones that I don't want to be able to move along the axle.
	//works well for PLA:
	//axle_r=1.075;
	//trying for PETG:
	//1.2 is about as loose in PETG as 1.1 was in PLA
	//1.175 works in PETG, but still a bit too loose to worth without glue - current best option for the class 66 axle-mounted wheels
	//1.15 seems to be working for the pointed axleset and just about (almost loose) for the class 66 wheels
	//note, 1.15 PETG does not produce as good wheels for the class66 (axle bearing) as 1.1 in PLA did.
	//for pointed axles: 1.15 works well in the dark grey PETG for the spacer, the wheels not so well - they tend to fall off.
	//latest design of wheels and 1.125 is way too loose in PETG
	axle_r=GEN_WHEELSET_SPACER ? 1.15 : 1.1;
	//extra_height = extra_axle_length;
	fancy_internal_r=5.8/2;
	fancy_edge_thick = 1.5;
	//assuming diameters[flange outer, flange inner, mainwheel outer, mainwheel inner]
	fancy_height = depth_up_to(depths,2)-0.5;
	
	difference(){
		union(){
			wheel_segment(diameters, depths, fn);
			//cylinder(h=total_depth(depths) + extra_height, r=fancy_internal_r, $fn=fn);
		}
		
		//fancy styling
		union(){
			//2mm rod
			cylinder(h=total_depth(depths)*2+1, r=axle_r, center=true);
			echo ("depth up to 2", depth_up_to(depths,2));
			difference(){
				
				translate([0,0,fancy_height])cylinder(h=50, r=diameters[3]/2-fancy_edge_thick, $fn=fn);
				cylinder(h=150, r=fancy_internal_r, center=true, $fn=fn);
			}
		}
		
	}
	difference(){
	
	}
}

module wheelset_model(diameter=12.5){
	
	diameters = diameter == 14 ? diameters_14mm : diameters_12_5mm;
	
	mirror_y()translate([16.5/2-(depths[0] + depths[1]),0,0])rotate([0,90,0])wheel(diameters, depths, 50);
	
	scale([axle_width/axle_holder_width,1,1])axle_punch(25);
}

//axle_length reduction reduces length of axle - will introduce a bit more wobble (potentially) but increase strength of the point
module wheel_with_point(diameters=diameters_14mm, depths=depths, axle_length_reduction = 0.1, fn=2000){
	
	point_height = flange_to_point - (total_depth(depths)-depths[0]);
	
	wheel(diameters, depths, fn);
	translate([0,0,total_depth(depths)])cylinder(r1=1.5,r2=0,$fn=fn, h = point_height);
	translate([0,0,total_depth(depths)-axle_length_reduction])cylinder(r=1.5,h=axle_length_reduction);
	echo("point height", point_height);
	
	
	
	echo("required axle length",axle_width-(axle_length_reduction + point_height)*2);
	
}

// diameters = DIAMETER == 12.5 ? diameters_12_5mm : 
// 				DIAMETER == 14 && DUMMY == false ? diameters_14mm : diameters_14mm_dummy;
				//DIAMETER == 14 && DUMMY == true ? 

depths = BEARING_TYPE == "axle" ? depths_thicker : depths_thinner;

extra_height = BEARING_TYPE == "axle" ? 2.5 : 3-total_depth(depths);

diameters_with_extra = extra_height(diameters(DIAMETER), depths, extra_height, DIAMETER/2);


if(GEN_WHEEL){
	if(WHEEL_POINTED && BEARING_TYPE=="spike"){
		wheel_with_point(diameters_with_extra[0], diameters_with_extra[1]);
	}else{
		wheel(diameters(DIAMETER), depths_thinner);
	}
}

if(GEN_WHEELSET_SPACER){
	//bits to slot along the axle to keep the wheels square and at the right distance
	//make these slightly shorter to account for not being able to get the wheels perfectly against the spacer
	fudge_factor = 0;
	// between_wheels = axle_width - 2*(flange_to_point + depths[0]);
	between_wheels = BACK_TO_BACK;
	echo("between wheels", between_wheels);
	mini_wheel_h = 2;
	wheel([DIAMETER-2.5,DIAMETER-2.5,3.75,3.75], [mini_wheel_h,0,between_wheels/2-mini_wheel_h - fudge_factor]);
}

