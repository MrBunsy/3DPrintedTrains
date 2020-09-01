include <truck_bits.scad>
include<constants.scad>
/*

Aiming for something halfway between an FTA and an FSA intermodal flat.

FSA have raised buffers one one end.
FTA have buffers on both ends, but I they're lower and only intended to be used with other FTAs or an FSA

Since I can't reduce the height of the bogies much, the lowest I can have buffers will be at "proper" height, but also inline with the bed, so it'll look like a FTA with buffers inline with the bed, but they'll be at the "proper" height like an end of a FSA.
I think this is good enough for my purposes.

TODO - since I've realised my measurements of coupling and buffer heights were wrong, the above statement might no longer be true and I might be able to do both FTA and FSA properly?


TODO slot to insert wheel (for brakes?) on either side - both wheels are offset from the centre, but in the same place (mirror along Y axis) - so it looks different from each side

TODO insert cylinder underneath (for brakes again?) only one one side, where it is to the right of the wheel

TODO blurb plaques

*/
dapol_wheels = true;
spoked = false;

wheel_diameter = getWheelDiameter(dapol_wheels, spoked);

buffer_mount_length=5;

//axle_space + aprox max wheel diameter + wiggle room
bogie_length_max = 23 + 17 + 3;

width=30;
thick=4;
edge_thick = 2;
//length=240 + buffer_mount_length*2;
//60ft
//real length = 19.57m -> 256.8mm (maybe with buffers?)
//will stick to this for now
length=60*4;

buffer_section_length = 10;

bogie_from_end = bogie_length_max/2 + buffer_section_length;
echo("bogie from end", bogie_from_end);
//axle_height+thick from bogie
axle_to_top_of_bogie = 4.5;

bogie_mount_height = top_of_buffer_from_top_of_rail - wheel_diameter/2 - axle_to_top_of_bogie - thick;
//+ extra for cutting bits out
bogie_width_max = 30+5;

middle_length = length - bogie_length_max-bogie_from_end*2;
underframe_height = axle_to_top_of_bogie + bogie_mount_height +thick;
underframe_middle_length = middle_length*0.8;
underframe_middle_length_for_aframes = middle_length*0.9;
underframe_middle_width = width/3;
underframe_middle_height = underframe_height*0.75;
a_frames = 4;
a_frame_length=2;
a_frame_spacings = underframe_middle_length/4;

mid_slot_width = width*0.1;
//centredCube(0,length/2 -buffer_section_length-5,width/3,10,10);

//i think distance between bogies is 11.93m -> 156.6mm

//translate([width/2+5,length/2 -buffer_section_length+0.5,0])rotate([-45,0,0])centredCube(0,0,width/3,1,10);

module main_edge_slot(edge_slot_width, edge_slot_r){
    //main edge slot
        translate([0,0,-1])centredCube(width/2-edge_thick-edge_slot_width/2,0,edge_slot_width,underframe_middle_length_for_aframes,50);
        //curved shape at end
        hull(){
            translate([width/2-edge_thick-edge_slot_r,underframe_middle_length_for_aframes/2,0])cylinder(h=50,r=edge_slot_r, center=true);
            
            centredCube(width/2-edge_thick-edge_slot_width/2,underframe_middle_length/2,edge_slot_width,1,50);
        }
        //and other end
        mirror([0,1,0])hull(){
            translate([width/2-edge_thick-edge_slot_r,underframe_middle_length_for_aframes/2,0])cylinder(h=50,r=edge_slot_r, center=true);
            
            centredCube(width/2-edge_thick-edge_slot_width/2,underframe_middle_length/2,edge_slot_width,1,50);
        }
}

difference(){
    union(){
        difference(){
        centredCube(0,0,width,length, thick);
            union(){
             //space for bogies
                translate([0,length/2-bogie_from_end,thick/2])
                    centredCube(0,0,bogie_width_max,bogie_length_max,thick);   
                
                translate([0,-(length/2-bogie_from_end),thick/2])
                    centredCube(0,0,bogie_width_max,bogie_length_max,thick);   
                
                //tapered end to space for bogies
                translate([0,length/2-buffer_section_length,thick/2])rotate([45,0,0])translate([-width,0,0])cube([width*2,20,20]);
                mirror([0,1,0])translate([0,length/2-buffer_section_length,thick/2])rotate([45,0,0])translate([-width,0,0])cube([width*2,20,20]);
                
                translate([0,length/2-bogie_from_end-bogie_length_max/2,thick/2])rotate([45,0,0])translate([-width,0,0])cube([width*2,20,20]);
                 mirror([0,1,0])translate([0,length/2-bogie_from_end-bogie_length_max/2,thick/2])rotate([45,0,0])translate([-width,0,0])cube([width*2,20,20]);
            }
        }
        translate([0,length/2-bogie_from_end,0])
            cylinder(h=bogie_mount_height+thick,r=m3_thread_d);
        
         translate([0,-(length/2-bogie_from_end),0])
            cylinder(h=bogie_mount_height+thick,r=m3_thread_d);
        
        //a-frame like underside lengthways
        hull(){
            centredCube(0,0,underframe_middle_width,underframe_middle_length,underframe_height);
            centredCube(0,0,underframe_middle_width,middle_length-thick,thick);
        }
        
        
    }
    
    union(){
        //holes for bogies to screw in
        translate([0,(length/2-bogie_from_end),0]){
            translate([0,0,0.2])cylinder(h=100,r=m3_thread_d/2);
        }
        translate([0,-(length/2-bogie_from_end),0]){
            translate([0,0,0.2])cylinder(h=100,r=m3_thread_d/2);
        }
        
        //holes for buffers
        translate([-buffer_distance/2,length/2,thick/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        translate([buffer_distance/2,length/2,thick/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        translate([-buffer_distance/2,-(length/2),thick/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        translate([buffer_distance/2,-(length/2),thick/2]){
            rotate([90,0,0]){
            //holes to hold buffers
            cylinder(h=buffer_holder_length*2, r=buffer_holder_d/2, $fn=200, center=true);
            }
        }
        
        
        //long slot down the centre
        hull(){
            end_r = width*0.04;
            
            translate([0,underframe_middle_length/2,0])cylinder(h=50,r=end_r, center=true);
            translate([0,0,-1])centredCube(0,0,mid_slot_width,underframe_middle_length-end_r*2,50);
            translate([0,-underframe_middle_length/2,0])cylinder(h=50,r=end_r, center=true);
        }
        //slots either side
        
        edge_slot_width = width*0.2;
        edge_slot_r = width*0.25/2;
        
        main_edge_slot(edge_slot_width, edge_slot_r);
        mirror([1,0,0])main_edge_slot(edge_slot_width, edge_slot_r);
        
        //holes near the buffer end. No idea what these are really for!
        hole_r = edge_slot_width*0.4;
        hole_from_end = buffer_section_length;
        
        translate([(width/2 - hole_r*2),(length/2-hole_from_end),0])cylinder(r=hole_r, h=50, center=true);
        translate([-(width/2 - hole_r*2),(length/2-hole_from_end),0])cylinder(r=hole_r, h=50, center=true);
        translate([(width/2 - hole_r*2),-(length/2-hole_from_end),0])cylinder(r=hole_r, h=50, center=true);
        translate([-(width/2 - hole_r*2),-(length/2-hole_from_end),0])cylinder(r=hole_r, h=50, center=true);
    }
}

//the a-frames don't get holes punched out
difference(){
    union(){
        a_frame_spacing = underframe_middle_length_for_aframes/a_frames;
        for(i=[0:a_frames]){
            translate([0,-underframe_middle_length_for_aframes/2 + i*a_frame_spacing])
            hull(){
                centredCube(0,0,underframe_middle_width,a_frame_length,underframe_middle_height);
                centredCube(0,0,width,a_frame_length,thick);
            }
        }
        //two extra in the centre
        for(i=[0:2]){
            translate([0,-a_frame_spacing/2 + i*a_frame_spacing/2])
            hull(){
                centredCube(0,0,underframe_middle_width,a_frame_length,underframe_middle_height);
                centredCube(0,0,width,a_frame_length,thick);
            }
        }
    }
        
    hull(){
        translate([0,0,-0.01])centredCube(0,0, mid_slot_width,length,thick*0.5);
        translate([0,0,-1])centredCube(0,0, width-edge_thick*2,length,1);
    }
}