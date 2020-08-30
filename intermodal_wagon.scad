include <truck_bits.scad>
$fn=200;

dapol_wheels = true;


wheel_diameter = dapol_wheels ? 12.8 : 14.0;
buffer_mount_length=5;

top_of_buffer_from_top_of_rail = 16.0;

width=32;
thick=4;
//length=240 + buffer_mount_length*2;
length=110;
m3_thread_d = 3.0;

bogie_from_end = 48/2;
//axle_height+thick from bogie
axle_to_top_of_bogie = 3.5;

bogie_mount_height = top_of_buffer_from_top_of_rail - wheel_diameter/2 - axle_to_top_of_bogie - thick;

bogie_length_max=46;//bogie_from_end*2-thick;
bogie_width_max = 30;

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