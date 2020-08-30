include <truck_bits.scad>

gen_pi_cam_wagon = true;
gen_battery_wagon = false;

dapol_wheels = false;

//hornby seems to be 7.5
//but this model always comes out a tiny bit low (wheels resting in mounts?)
//so raising a bit
//7.7 seems to come out in like with bachmann and lima, but little lower than hornby
top_of_coupling_from_top_of_rail = 7.9;
top_of_buffer_from_top_of_rail = 16.0;

thick = 3.5;


small_flanges = dapol_wheels;
//for bog standard truck 75 (less than that and this design needs work for a space to contain the metal weight):
length=gen_pi_cam_wagon ? 85 : 75;
//minimum of body width + girder_width*2 (31 by default)
buffer_end_width=gen_pi_cam_wagon ? 36 : gen_battery_wagon ? 32 : 31;




//pointy bit to pointy bit of spare hornby axles (also works for dapol axles)
axle_width = 25.65;

//distance between the two axle holders (along the axle)
//bachman spacing
axle_space = 23.0;
//hornby is 23.0
//bachman 22.2

//diameter around which there can be no obstructions for the wheels
wheel_max_d = dapol_wheels ? 14+2 : 17+2;
//max_d doesn't apply within this space in the centre of the axle
wheel_centre_space = 8;

//for height of couplings and axle mounts - diameter of the thinner bit of
//the wheel that rests on the rails
//13.5 for the old coach wheels, truck wheels usually smaller (13.15)
//14.0 works for the spare hornby Mk1 coach wheels
//wheel_diameter = 14.0;
//12.8 for spoked dapol wheels
wheel_diameter = dapol_wheels ? 12.8 : 14.0;

//how high for axle to be from the underside of the truck
//bachman seem to be lower than the rest at 5, hornby + lima about 6
//this should probably be adjusted for wheel size as it affects buffer height
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

//distance between the two axles (perpendicular to each axle)
//I'd like to have the wheels slightly closer to the ends to help with coupling
//but the closer the wheels are together, the better the handling around the corners
//especially with the low-flange dapol wheels
axle_distance = length - (small_flanges ? 35 : 30);

//width of the bar holding the buffers

buffer_end_height = 3.5;
//length in y axis
buffer_length = 0.5;
//how far apart the centres of the buffers are
buffer_distance = 22.2;
buffer_holder_d = 2;//1.7;
buffer_holder_length = 4.5;
girder_thick=0.5;

//aim to keep width same, and increase buffer width for larger payloads
width=30;

//for pi camera truck:
//length=75+10;
//buffer_end_width = 35;




//wall thickness + screw head size + wiggle room
top_screw_holders_from_edge = 5;

//1.7 tiny bit too tight
//1.9 fine for the coarse thread screws, bit tight for fine 
//2.1 seems to print fine in grey PLA, but not black... trying 2.25
//2.25 thread slipped on one screw
//trying 2.0 for a real m2, not whatever it was I was using before
m2_thread_size=2.0;
m2_thread_size_loose = 2.3;
m2_head_size=4.5;




//how deep below the "top" surface the head of a scre should sit
screw_depth = 2;





edge=5;
edge_ends=5;
coupling_from_edge=2.5;


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
            decorative_brake_mounts(width/2-edge/2, axle_distance-wheel_max_d, axle_height*1.3,axle_distance/2+wheel_max_d*0.25, width/2);
            rotate([0,0,180]){
                decorative_brake_mounts(width/2-edge/2, axle_distance-wheel_max_d,axle_height*1.3, axle_distance/2+wheel_max_d*0.25, width/2);
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
        //extra deep hole for couplings
        translate([0,length/2-edge/2,-thick]){
            cylinder(h=thick*4,r=m2_thread_size/2, $fn=200);
        }
        translate([0,-(length/2-edge/2),-thick]){
            cylinder(h=thick*3,r=m2_thread_size/2, $fn=200);
        }
        //place for weight
        translate([0,0,-1]){
            centredCube(0,0,weight_width,weight_length,weight_depth+1);
        }
        

        //holes for screws to hold the top half on (aligned along the x axis)
        //these two are deliberately large holes so the screw only grips into the top
        translate([width/2-top_screw_holders_from_edge,0,screw_depth]){
            cylinder(r=m2_head_size/2,h=thick*3,$fn=200);
            cylinder(r=m2_thread_size_loose/2,h=thick*3,$fn=200,center=true);
        }
        translate([-(width/2-top_screw_holders_from_edge),0,screw_depth]){
            cylinder(r=m2_head_size/2,h=thick*3,$fn=200);
            cylinder(r=m2_thread_size_loose/2,h=thick*3,$fn=200,center=true);
        }
        
        //holes for buffers
        translate([-buffer_distance/2,length/2,buffer_end_height/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        translate([buffer_distance/2,length/2,buffer_end_height/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        translate([-buffer_distance/2,-(length/2),buffer_end_height/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        translate([buffer_distance/2,-(length/2),buffer_end_height/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        
    }
}


translate([0,length/2-coupling_from_edge,thick]){
    coupling_mount(coupling_height);
}

translate([0,-(length/2-coupling_from_edge),thick]){
    rotate([0,0,180]){
        coupling_mount(coupling_height);
    }
}

axle_holder(axle_space, 20, axle_height);
axle_holder_decoration(axle_space, 20, axle_height);

