//pointy bit to pointy bit of spare hornby axles
axle_width = 25.65;

//bachman spacing
axle_space = 23.0;
//hornby is 23.0
//bachman 22.2

//TODO - instead of making base thicker to hold the weight, put bits on top that are higher

width=28;
length=75;
thick = 2;

//1.7 tiny bit too tight
//1.9 fine for the coarse thread screws, bit tight for fine 
m2_thread_size=2.1;
m2_head_size=5;


//min length required to hold the metal weight
weight_length=60+3;
//min width required to hold the metal weight
weight_width=9.7+3;
weight_depth=3;

axle_distance = 40;

//diameter around which there can be no obstructions for the wheels
wheel_max_space = 17;

//for height of couplings and axle mounts - diameter of the thinner bit of
//the wheel that rests on the rails
//13.5 for the old coach wheels, truck wheels usually smaller (13.15)
wheel_diameter = 14.0;

axle_height = 5;


edge=5;
edge_ends=5;

//centred in xy plane
module centredCube(x,y,width,length, height){
    translate([x-width/2, y-length/2,0]){
        cube([width,length, height]);
    }
    
}

//single axle mount with insertion for axle, insertion facing right (+ve x)
module axle_mount(width,length, axle_height, axle_depth){
    //translate([width*0.5-0.01,0.1,axle_height]){
      //          rotate([0,-90,0]){
        //            cylinder(h=width+0.01,r1=width*0.2, r2=0,$fn=200);
          //      }
            //}
    
    extra_height = axle_height*0.5;
    
    //didn't actually want a centred cube, push it so the inside edge will be at the endge of axle_space
    translate([-width/2,0,0]){
    
    difference(){
        centredCube(0,0,width,length, axle_height+extra_height);
        union(){
            //cone for axle to rest in
             translate([width/2+0.01,0,axle_height]){
                rotate([0,-90,0]){
                    cylinder(h=axle_depth,r1=axle_depth/2, r2=0,$fn=200);
                }
            }
            //groove to help slot axle in
            translate([width/2,0,axle_height]){
                rotate([0,0,45]){
                    centredCube(0,0,axle_depth*0.2,axle_depth*0.2,extra_height+0.01);
                }
            }
            
        }
    }
}
}


module axle_holder(axle_space, x, axle_height){
    
    width = 2.5;
    length = 5;
    axle_depth = 1+(axle_width-axle_space)/2;
    
    translate([-axle_space/2,-axle_distance/2,0]){
        axle_mount(width,length, axle_height+thick, axle_depth);
    }
    
    translate([-axle_space/2,axle_distance/2,0]){
        axle_mount(width,length, axle_height+thick, axle_depth);
    }
    
    rotate([0,0,180]){
        translate([-axle_space/2,-axle_distance/2,0]){
            axle_mount(width,length, axle_height+thick, axle_depth);
        }
        
        translate([-axle_space/2,axle_distance/2,0]){
            axle_mount(width,length, axle_height+thick, axle_depth);
        }
    }
}

module coupling_mount(height){
   
    side_holders_top_r = 0.85;
    top_r_distance=14+side_holders_top_r;
    
    difference(){
        cylinder(h=height,r=4.8/2, $fn=200);
       
        cylinder(h=height+0.1,r=m2_thread_size/2, $fn=200);
    }
    
    translate([top_r_distance/2,0]){
        cylinder(h=height+1.2,r=side_holders_top_r,$fn=200);
        cylinder(h=height,r=2.5/2,$fn=200);
        translate([-side_holders_top_r/2,0,0]){
            cube([side_holders_top_r,side_holders_top_r*3,height]);
        }
    }
    translate([-top_r_distance/2,0]){
        cylinder(h=height+1.2,r=side_holders_top_r,$fn=200);
        cylinder(h=height,r=2.5/2,$fn=200);
        translate([-side_holders_top_r/2,0,0]){
            cube([side_holders_top_r,side_holders_top_r*3,height]);
        }
    }
    
}




difference(){

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
        weightHolderLength=3;
        //extra bit to hold the metal weight
        centredCube(0,length/2-edge_ends - weightHolderLength/2,width-edge*2,weightHolderLength,thick*2);
        centredCube(0,-(length/2-edge_ends - weightHolderLength/2),width-edge*2,weightHolderLength,thick*2);
    }    
    
    union(){
        //space for wheels
        translate([0,-axle_distance/2,0]){
            cube([axle_space,wheel_max_space,thick*3], center=true);
        }
        translate([0,axle_distance/2,0]){
            cube([axle_space,wheel_max_space,thick*3], center=true);
        }
        //extra deep hole for couplings
        translate([0,length/2-edge/2,-thick]){
            cylinder(h=thick*3,r=m2_thread_size/2, $fn=200);
        }
        translate([0,-(length/2-edge/2),-thick]){
            cylinder(h=thick*3,r=m2_thread_size/2, $fn=200);
        }
        //place for weight
        centredCube(0,0,weight_width,weight_length,weight_depth);
        
        screw_depth=2;
        
        //holes for screws in sides
        translate([edge/2-width/2,0,(thick-screw_depth)/2 + thick-screw_depth]){
            cylinder(r=m2_head_size/2,h=thick-screw_depth,$fn=200,center=true);
            cylinder(r=m2_thread_size/2,h=thick*3,$fn=200,center=true);
        }
        
        
         //holes for screws in sides
        translate([-(edge/2-width/2),0,(thick-screw_depth)/2 + thick-screw_depth]){
            cylinder(r=m2_head_size/2,h=thick-screw_depth,$fn=200,center=true);
            cylinder(r=m2_thread_size/2,h=thick*3,$fn=200,center=true);
        }

    }
}

//2.5 from the height of the coupling, also unhelpfully called coupling_height in the coupling .scad file
coupling_height = axle_height + wheel_diameter/2 - 2.5 - 5;
//want to try and get bottom of coupling 5mm from top of the rails

translate([0,length/2-edge/2,thick]){
    coupling_mount(coupling_height);
}

translate([0,-(length/2-edge/2),thick]){
    rotate([0,0,180]){
        coupling_mount(coupling_height);
    }
}

axle_holder(axle_space, 20, axle_height);