include <constants.scad>

gen_brake_wheel = false;
gen_brake_cylinder = true;

truck_fixing_d=1.7;

sticks_out = 1;
wheel_thick = 0.5;
wheel_d = 6;
arms=3;

cylinder_d = 6;
cylinder_length = 3*4;
cylinder_hole_spacing = 2*4;

module brake_wheel(height=buffer_holder_length){
	 //stick to slot into wagon
    translate([0,0,wheel_thick+sticks_out])cylinder(h=height+sticks_out,r=truck_fixing_d/2);

    //bit to join wheel and fixing arm
    translate([0,0,0])cylinder(h=wheel_thick+sticks_out,r1=truck_fixing_d*0.5, r2=truck_fixing_d/2);

    //actual wheel
    difference(){
        cylinder(h=wheel_thick,r=wheel_d/2);
        cylinder(h=wheel_thick*3,r=wheel_d/2-wheel_thick, center=true);
    }

    //wheel arms
    intersection(){
        cylinder(h=wheel_thick,r=wheel_d/2);
        
        for(i=[0:arms]){
            rotate(i*360/arms)translate([-wheel_thick/2,0,0])cube([wheel_thick,100,wheel_thick]);
            
        }
    }
}

module brake_cylinder(){
	translate([0,0,cylinder_d/2])rotate([0,90,0])cylinder(r=cylinder_d/2,h=cylinder_length, center=true);
	
	mirror_y()translate([-cylinder_hole_spacing/2,0,0])translate([0,0,cylinder_d/2])cylinder(h=buffer_holder_length+cylinder_d/2,r=truck_fixing_d/2);

	
}

if(gen_brake_wheel){
	brake_wheel(buffer_holder_length);
	translate([10,0,0])brake_wheel(buffer_holder_length/3);
}

if(gen_brake_cylinder){
	brake_cylinder();
}