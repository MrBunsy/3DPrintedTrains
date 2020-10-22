//hornby is a little higher than many of the others, 
//was using 7.9, but then I had trouble with the coupling hook catching on pointwork
top_of_coupling_from_top_of_rail = 8.4;

coupling_from_edge=2.5;
coupling_hook_x = 3.7;

//again hornby seems higher than Lima and friends, but it makes my life easier so I'll take it
//hornby seens to be 17.6, lima about 16.5. i'll go for 17
top_of_buffer_from_top_of_rail = 17;//16.0;
//real standard flat deck is apparently 940mm => 12.34.
//no real way to achieve that with any of the wheels I've seen

//pointy bit to pointy bit of spare hornby axles (also works for dapol axles)
axle_width = 25.65;

m2_thread_size = 2;
m2_thread_size_vertical = 1.95;
m2_thread_size_loose = 2.3;
//actually 3.9, but this allows space
m2_head_size=4.5;
m2_head_length=1.7;
//4.84, but with some extra space
m2_washer_d = 5;
m3_thread_loose_size = 3.2;
m3_thread_d = 3.0;
//thick enough to make a difference...
m3_washer_thick = 0.55;
axle_space=23;

pi_cam_d = 7.3;

//doesn't include tip
aaa_battery_length = 43;
//includes a little bit of space
aaa_battery_d=11;

$fn=200;

//how far apart the centres of the buffers are
buffer_distance = 22.2;
buffer_holder_d = 2;
//how deep the buffer holder hole needs to be
buffer_holder_length = 4.5;

//max_d doesn't apply within this space in the centre of the axle
axle_centre_space = 8;

//four cylinders that will hold a pi
pi_mount_length=58;
pi_mount_width=23;
pi_mount_d=2.25;

//for height of couplings and axle mounts - diameter of the thinner bit of
//the wheel that rests on the rails
//13.5 for the old coach wheels, truck wheels usually smaller (13.15)
//14.0 works for the spare hornby Mk1 coach wheels
//wheel_diameter = 14.0;
//12.8 for spoked dapol wheels
//12.5 for the 3 holes dapol wheels
function getWheelDiameter(dapol_wheels=true, spoked = true) = dapol_wheels ?  ( spoked ? 12.8 : 12.5) : 14.0;
//total size including flange of dapol is 13.8

//diameter around which there can be no obstructions for the wheels
function getWheelMaxDiameter(dapol_wheels=true, spoked = true) = dapol_wheels ? 14+2 : 17+2;


module rounded_cube(width,length,height,r, $fn=50){
    hull(){
        corners = [
            [r-width/2,r-length/2,0],
            [r-width/2,length/2-r,0],
            [width/2-r,r-length/2,0],
            [width/2-r,length/2-r,0],
        
        ];
        for(i=[0:3]){
            translate(corners[i])cylinder(r=r,h=height);
        }
    }
    
}


module mirror_x(doMirror=true){
    children();
	if(doMirror){
		mirror([0,1,0]) children();
	}
}

module mirror_y(doMirror=true){
    children();
	if(doMirror){
		mirror([1,0,0]) children();
	}
}

module mirror_xy(doMirror=true){
    mirror_x(doMirror) mirror_y(doMirror) children();
}

SCALE = 76.2;

//stolen from container
function m2mm(m) = m * 1000 / SCALE;

module centred_cube(width,length,height, centreZ = false){
	translate([-width/2, -length/2, centreZ ? -height/2 : 0])cube([width,length,height]);
}

module optional_translate(position, doTranslate = true){
	if(doTranslate){
		translate(position)children();
	}else{
		children();
	}
}

module optional_rotate(rotation, doRotate = true){
	if(doRotate){
		rotate(rotation)children();
	}else{
		children();
	}
}

//take one object, clone it and translate it, then mirror and combine with the original - so if you had one thing you end up with three
module triplicate_x(trans_position){
	children();
	mirror_x()translate(trans_position)children();
}

rs_switch_body_height = 8.89;
rs_switch_thread_height = 8.89;
rs_switch_height = rs_switch_body_height + rs_switch_thread_height;
rs_switch_nut_height = 1.6;
rs_switch_nut_space_d = 11;
//space model to use to subtract away for a space to hold an RS 734-7097 switch
//switch facing upwards, 0,0 at base of switch ignoring metal solder tags
module rs_switch(scale_switch=1, extra_height=0){
	scale([scale_switch,scale_switch,scale_switch]){
		centred_cube(6.86,12.70,rs_switch_body_height);
		cylinder(r=6.06/2,h=rs_switch_body_height+rs_switch_thread_height);
		translate([0,0,0.001-extra_height])centred_cube(6.86,12.70,extra_height);
	}
}

led_base_extra=0.2;
led_3mm_total_length = 5.08;
led_3mm_base_length = 1;
led_3mm_tip_length = 5.08 - led_3mm_base_length;
led_3mm_d = 3+0.2;
//on its side, facing +ve y, 0,0 being base of LED tip (flange is in -ve y direction) and a box for wires
module led_3mm(extra_base_length = led_base_extra){
	translate([0,-led_3mm_base_length,0]){
		base_d = 4.05+0.1;
		rotate([-90,0,0])cylinder(r=led_3mm_d/2, h=led_3mm_total_length);
		rotate([-90,0,0])translate([0,0,-extra_base_length ])cylinder(r=base_d/2, h=led_3mm_base_length+extra_base_length );
	}
}

led_1_8mm_total_length = 3.1;
led_1_8mm_tip_length = 1.55;
led_1_8mm_base_length = led_1_8mm_total_length - led_1_8mm_tip_length;
led_1_8mm_d = 1.8+0.2;
led_1_8_base_width=3.3+0.2;
//on its side, facing +ve y, 0,0 being base of LED tip (flange is in -ve y direction) and a box for wires
module led_1_8mm(extra_base_length = led_base_extra, extra_front_length = 0){
	
	translate([0,-led_1_8mm_base_length,0]){
		rotate([-90,0,0])cylinder(r=led_1_8mm_d/2, h=led_1_8mm_total_length+extra_front_length);
		
		translate([0,(led_1_8mm_base_length+extra_base_length)/2-extra_base_length,-led_1_8_base_width/2])centred_cube(2.4+0.2,led_1_8mm_base_length+extra_base_length,led_1_8_base_width);
	}
}