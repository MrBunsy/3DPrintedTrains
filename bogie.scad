include <truck_bits.scad>

dapol_wheels = true;
//cartsprings, girder at top. looks like a minitruck. Mk1 carriage or old bogie wagon style
girder_style = true;

//misc useful bits copypated from truck_base TODO consider how to abstract out

top_of_coupling_from_top_of_rail = 7.9;
thick = 2;
//pointy bit to pointy bit of spare hornby axles (also works for dapol axles)
axle_width = 25.65;
//distance between the two axle holders (along the axle)
axle_space = 23.0;
m2_thread_size = 2;
m3_thread_loose_size = 3.2;

//diameter around which there can be no obstructions for the wheels
wheel_max_d = dapol_wheels ? 14+2 : 17+2;

//max_d doesn't apply within this space in the centre of the axle
wheel_centre_space = 8;
wheel_diameter = dapol_wheels ? 12.8 : 14.0;

//height above thick for the coupling mount
coupling_height = 0;

//how high for axle to be from the underside of the truck
//bachman seem to be lower than the rest at 5, hornby + lima about 6
//this should probably be adjusted for wheel size as it affects buffer height
axle_height = top_of_coupling_from_top_of_rail + coupling_height - wheel_diameter/2;

axle_distance = wheel_max_d*1.5;

coupling_from_edge=2;
coupling_end_from_axle = wheel_max_d/2 + 3;
non_coupling_end_from_axle = girder_style ? wheel_max_d/2 + thick/2 : 0;


width=axle_space+5;
length=axle_distance + coupling_end_from_axle + non_coupling_end_from_axle;

echo("width",width,"length",length, "axle_height",axle_height, "thick",thick);

difference(){
    translate([-width/2,-axle_distance/2- non_coupling_end_from_axle,0]){
        cube([width,length,thick]);
    }
    
    union(){
        //space for wheels
        translate([0,-axle_distance/2,axle_height+thick]){
            axle_hole(wheel_max_d,axle_space,wheel_centre_space);
        }
        translate([0,axle_distance/2,axle_height+thick]){           
            axle_hole(wheel_max_d,axle_space,wheel_centre_space);
        }
        //extra deep hole for couplings
        translate([0,axle_distance/2 + coupling_end_from_axle -coupling_from_edge,-thick]){
            cylinder(h=thick*4,r=m2_thread_size/2, $fn=200);
        }
        //m3 hole to connect to main chassis
        cylinder(h=thick*3,r=m3_thread_loose_size/2, $fn=200, center=true);
    }
}

axle_holder(axle_space, 20, axle_height);
//axle_holder_decoration(axle_space, 20, axle_height);
translate([0,axle_distance/2 + coupling_end_from_axle -coupling_from_edge,thick]){
    coupling_mount(coupling_height);
}