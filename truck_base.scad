include <truck_bits.scad>
include <constants.scad>
/*
gen_pi_cam_wagon = false;
gen_battery_wagon = false;

dapol_wheels = true;
//spoked = true;

//for bog standard truck 75 (less than that and this design needs work for a space to contain the metal weight):
length=gen_pi_cam_wagon ? 85 : 75;
wheel_diameter = getWheelDiameter(dapol_wheels, spoked);

small_flanges = dapol_wheels;
//distance between the two axles (perpendicular to each axle)
//I'd like to have the wheels slightly closer to the ends to help with coupling
//but the closer the wheels are together, the better the handling around the corners
//especially with the low-flange dapol wheels
axle_distance = length - (small_flanges ? 35 : 30);
//minimum of body width + girder_width*2 (31 by default)
buffer_end_width=gen_pi_cam_wagon ? 36 : gen_battery_wagon ? 32 : 31;
//diameter around which there can be no obstructions for the wheels
//wheel_max_d =  getWheelMaxDiameter(dapol_wheels, spoked);

//*/

//if axle_distance_input is specified, it will override the default
module truck_base(buffer_end_width = 31, length = 75, wheel_diameter=12.5, axle_distance_input = 0, coupling="dapol"){

axle_distance = axle_distance_input == 0 ? length - 30 : axle_distance_input;


wheel_max_d = wheel_diameter+3.5;
thick = 3.5;





//distance between the two axle holders (along the axle)
//bachman spacing
axle_space = 23.0;
//hornby is 23.0
//bachman 22.2


//max_d doesn't apply within this space in the centre of the axle
wheel_centre_space = 8;




//how high for axle to be from the underside of the truck
//bachman seem to be lower than the rest at 5, hornby + lima about 6
//this should probably be adjusted for wheel size as it affects buffer height
//FOR REASONS(??) this is the height 'above' the thickness of the base
axle_height = top_of_buffer_from_top_of_rail - thick - wheel_diameter/2 ;//5.5;


//2.5 from the height of the coupling, also unhelpfully called coupling_height in the coupling .scad file
//note - now the axle_height is properly adjusted this will never change!
coupling_height = axle_height + wheel_diameter/2 - top_of_coupling_from_top_of_rail;



echo("axle_height", axle_height, "coupling_height", coupling_height);
//min length required to hold the metal weight
//old dapol weights: 62 long. new ones: 63
weight_length=63+2;
//min width required to hold the metal weight
weight_width=9.7+1;
weight_depth=3;
weight_end_ledge_length = 4;
weight_centre_ledge_length = 5;



//width of the bar holding the buffers

buffer_end_height = 3.5;
//length in y axis
buffer_length = 0.5;

girder_thick=0.5;

//aim to keep width same, and increase buffer width for larger payloads
//TODO this is a bit too wide compared to most of my models and photos I can find?
width=30;

//for pi camera truck:
//length=75+10;
//buffer_end_width = 35;




//wall thickness + screw head size + wiggle room
top_screw_holders_from_edge = 5;

//how deep below the "top" surface the head of a scre should sit
screw_depth = 2;





edge=5;
edge_ends=5;



difference(){

//main body of the truck
    union(){
        //base with hole in the middle
        difference(){
            translate([-width/2, -length/2,0]){
                cube([width,length,thick]);
            }
            
               translate([edge-width/2, edge_ends-length/2,-thick]){
                cube([width-edge*2,length-edge_ends*2,thick*3]);
            }
            
        }
        //girder-bits 
        //for the buffers
        centredCube(0,length/2-girder_thick/2-buffer_length,buffer_end_width,girder_thick,girder_thick);
        translate([0,0,thick-girder_thick]){
            centredCube(0,length/2-girder_thick/2-buffer_length,buffer_end_width,girder_thick,girder_thick);
        }
        rotate([0,0,180]){
            centredCube(0,length/2-girder_thick/2-buffer_length,buffer_end_width,girder_thick,girder_thick);
            translate([0,0,thick-girder_thick]){
                centredCube(0,length/2-girder_thick/2-buffer_length,buffer_end_width,girder_thick,girder_thick);
            }
        }
        //for the sides
        centredCube(width/2+girder_thick/2,0,girder_thick, length,girder_thick);
        translate([0,0,thick-girder_thick]){
            centredCube(width/2+girder_thick/2,0,girder_thick, length,girder_thick);
        }
        rotate([0,0,180]){
            centredCube(width/2+girder_thick/2,0,girder_thick, length,girder_thick);
            translate([0,0,thick-girder_thick]){
                centredCube(width/2+girder_thick/2,0,girder_thick, length,girder_thick);
            }
        }
        
        if(length <= 75){
            //little ledges sticking out from behind the coupling moutns
            weightHolderLength=(length - weight_length)/2 -edge_ends + weight_end_ledge_length;
            //extra bit to hold the metal weight
            centredCube(0,length/2-edge_ends - weightHolderLength/2,width-edge*2,weightHolderLength,weight_depth+1.5);
            centredCube(0,-(length/2-edge_ends - weightHolderLength/2),width-edge*2,weightHolderLength,weight_depth+1.5);
        }else{
            //length to have a stop at the end of the weight
            weightHolderLength=(length - weight_length)/2 -edge_ends;
            centredCube(0,length/2-edge_ends - weightHolderLength/2,weight_width,weightHolderLength,thick);
            
            
            //the end ledges would be in the way of the wheels
            //so have two ledges on the inside of the wheels
            //and end stops near the couplings
            //calculate the closest the ledge can be to the wheel without a notch being cut out of it
            arm_height = thick;// weight_depth+1.5;
            axle_height_above_ledge = (axle_height + thick) - arm_height;
            edgeOfWheelsAtThickness = sqrt(wheel_max_d*wheel_max_d/4 - axle_height_above_ledge*axle_height_above_ledge);
            
            centredCube(0,axle_distance/2 - edgeOfWheelsAtThickness-weightHolderLength/2,width-edge*2,weightHolderLength,arm_height);
            
            mirror([0,1,0]){
                centredCube(0,length/2-edge_ends - weightHolderLength/2,weight_width,weightHolderLength,thick);
                 centredCube(0,axle_distance/2 - edgeOfWheelsAtThickness-weightHolderLength/2,width-edge*2,weightHolderLength,arm_height);
            }
            
            
            
        }
         //arm across the middle
        centredCube(0,0,width-edge,weight_centre_ledge_length,thick);
        
        //buffers
        translate([0,length/2-buffer_length/2,0]){
            buffer(buffer_end_width, buffer_end_height, buffer_distance, buffer_length);
        }
        rotate([0,0,180]){
            translate([0,length/2-buffer_length/2,0]){
                buffer(buffer_end_width, buffer_end_height, buffer_distance, buffer_length);
            }
        }   
   
    
        //decorative brake system
        translate([0,0,thick]){
            decorative_brake_mounts(width/2-edge/2, axle_distance-wheel_max_d, axle_height*1.3,axle_distance/2+wheel_max_d*0.25, width/2, thick);
            rotate([0,0,180]){
                decorative_brake_mounts(width/2-edge/2, axle_distance-wheel_max_d,axle_height*1.3, axle_distance/2+wheel_max_d*0.25, width/2, thick);
            }
        }
    }    
    
//union of all the holes to punch out
    union(){
        //space for wheels
        translate([0,-axle_distance/2,axle_height+thick]){
            axle_hole(wheel_max_d,axle_space,wheel_centre_space);
        }
        translate([0,axle_distance/2,axle_height+thick]){           
            axle_hole(wheel_max_d,axle_space,wheel_centre_space);
        }
        if(coupling != "dapol"){
            //extra deep hole for couplings
            mirror_x()translate([0,length/2-edge/2,-thick]){
                cylinder(h=thick*4,r=m2_thread_size_vertical/2, $fn=200);
            }

        }
        //place for weight
        translate([0,0,-1]){
            centredCube(0,0,weight_width,weight_length,weight_depth+1);
        }
        

        //holes for screws to hold the top half on (aligned along the x axis)
        //these two are deliberately large holes so the screw only grips into the top
        mirror_y()translate([width/2-top_screw_holders_from_edge,0,screw_depth]){
            cylinder(r=m2_head_size/2,h=thick*3,$fn=200);
            cylinder(r=m2_thread_size_loose/2,h=thick*3,$fn=200,center=true);
        }
        
        
        //holes for buffers
        mirror_xy()translate([buffer_distance/2,length/2,buffer_end_height/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        //extra space to make broken/stuck buffers easier to remove
        mirror_xy()translate([buffer_distance/2,length/2-buffer_holder_length*0.75/2 - buffer_holder_length/4,1])centred_cube(buffer_holder_length*0.75,buffer_holder_length*0.75,thick);
        
        
    }
}
mirror_x(){
    if(coupling == "dapol"){
        translate([0,length/2,thick])coupling_mount_dapol(thick);
    }else{
        translate([0,length/2-coupling_from_edge,thick]){
            coupling_mount(coupling_height);
        }
    }
}

translate([0,0,thick]){
    difference(){
        axle_holder(axle_space, 20, axle_height, axle_distance);
        axle_holder_decoration(axle_space, 20, axle_height, axle_distance, true);
    }
	
	axle_holder_decoration(axle_space, 20, axle_height, axle_distance, false);
}
}