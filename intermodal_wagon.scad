include <truck_bits.scad>
$fn=200;
/*

Aiming for something halfway between an FTA and an FSA intermodal flat.

FSA have raised buffers one one end and connect via a bar in pairs.
FTA have buffers on both ends, but I they're lower and only intended to be used with other FTAs or an FSA

Since I can't reduce the height of the bogies much, the lowest I can have buffers will be at "proper" height, but also inline with the bed, so it'll look like a FTA with buffers inline with the bed, but they'll be at the "proper" height like an end of a FSA.
I think this is good enough for my purposes.

*/
dapol_wheels = true;


wheel_diameter = dapol_wheels ? 12.8 : 14.0;
buffer_mount_length=5;

top_of_buffer_from_top_of_rail = 16.0;

width=32;
thick=4;
//length=240 + buffer_mount_length*2;
//60ft
length=60*4;
m3_thread_d = 3.0;


bogie_from_end = 48/2;
//axle_height+thick from bogie
axle_to_top_of_bogie = 4.5;

bogie_mount_height = top_of_buffer_from_top_of_rail - wheel_diameter/2 - axle_to_top_of_bogie - thick;

bogie_length_max=46;//bogie_from_end*2-thick;
bogie_width_max = 30;

middle_length = length - bogie_length_max-bogie_from_end*2;
underframe_height = axle_to_top_of_bogie + bogie_mount_height +thick;
underframe_middle_length = middle_length*0.75;
a_frames = 4;
a_frame_spacings = underframe_middle_length/4;

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
            }
        }
        translate([0,length/2-bogie_from_end,0])
            cylinder(h=bogie_mount_height+thick,r=m3_thread_d);
        
         translate([0,-(length/2-bogie_from_end),0])
            cylinder(h=bogie_mount_height+thick,r=m3_thread_d);
        
        //a-frame like underside lengthways
        hull(){
            centredCube(0,0,10,underframe_middle_length,underframe_height);
            centredCube(0,0,10,middle_length,thick);
        }
        for(i=[0:a_frames]){
            
        }
        
    }
    
    union(){
        //holes for bogies to screw in
        translate([0,length/2-bogie_from_end,0]){
            cylinder(h=100,r=m3_thread_d/2, center=true);
        }
        translate([0,-(length/2-bogie_from_end),0]){
            cylinder(h=100,r=m3_thread_d/2, center=true);
        }
        
    }
}