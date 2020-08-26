

length=75;

wall_thick=1.5;
base_thick=2;

width=35;
//height of the apex of the ends
height=31;
//aiming for side height of 26;
roof_radius=31.4;
side_height= roof_radius*cos(asin((width/2)/roof_radius));
echo(side_height);

hole_for_battery_cables = true;
cable_d=5.5;

plank_height= side_height/12;//2.25;
plank_indent=0.25;
support_width = 1.5;
mid_support_width = 1.1;

vent_height = plank_height*4.5;//height*0.35;
vent_angle = 8;

door_width=0.5;
door_adornments_width=1;

door_length=length/3;

//from truck base
//wall thickness + screw head size + wiggle room
top_screw_holders_from_edge = 5;
//turns out my screws weren't m2. 2.2 works for the screws provided with couplings
//trying actually 2.0 for m2
m2_thread_size=2.0;
edge=5;
truck_width=30;

//similar but trying not the same as truck_base
module centredCube(width,length, height){
    translate([-width/2, -length/2,0]){
        cube([width,length, height]);
    }
    
}

//facing +ve x
module door(){
    translate([width/2,0,0]){
        hinges_height = side_height*0.15;
        difference(){
            centredCube(door_width,door_length,height);
            union(){
                //plank effects
                for(i=[-5:5]){
                    translate([sqrt(2)*plank_height/2+door_width/2-plank_indent,i*plank_height,0]){
                        rotate([0,0,45]){
                            cube([plank_height,plank_height,height*3],center = true);
                        }
                    }
                }
            }
        }
        //centreline
        centredCube(door_adornments_width,door_adornments_width,height);
        
        handle_length = door_adornments_width*1.5;
        
        translate([0,-handle_length/2,side_height/2-door_adornments_width/2]){
            //handle/lock in the centre
            centredCube(door_adornments_width,handle_length,door_adornments_width);
        }
        
        translate([0,0,0]){
            //handle/lock at the bottom
            centredCube(door_adornments_width,door_adornments_width*2,door_adornments_width);
        }
        
        
        //either side
        translate([0,door_length/2,0]){
            centredCube(door_adornments_width,door_adornments_width,height);
        }
        translate([0,-door_length/2,0]){
            centredCube(door_adornments_width,door_adornments_width,height);
        }
        hinge_length = door_length*0.4;
        //hinges
        translate([0,-door_length/2+hinge_length/2,hinges_height-door_adornments_width/2]){
            centredCube(door_adornments_width,hinge_length,door_adornments_width);
        }
        translate([0,-(-door_length/2+hinge_length/2),hinges_height-door_adornments_width/2]){
            centredCube(door_adornments_width,hinge_length,door_adornments_width);
        }
        translate([0,-door_length/2+hinge_length/2,side_height-hinges_height-door_adornments_width/2]){
            centredCube(door_adornments_width,hinge_length,door_adornments_width);
        }
        translate([0,-(-door_length/2+hinge_length/2),side_height-hinges_height-door_adornments_width/2]){
            centredCube(door_adornments_width,hinge_length,door_adornments_width);
        }
    }
    
}

//facing +ve y
module vent(width, height,angle){
    thick = height*sin(angle);
    difference(){
        translate([0,thick,0]){
            rotate([90+angle,0, 0]){
                cube([width, height,thick]);
            }
        }
        translate([0,-50,0]){
            cube([width*2,100,100],center=true);
        }
    }
}

difference(){
//intersect with horizontal cylinder for roof shape
intersection(){
        
    union(){
        difference(){
            union(){
            centredCube(width,length,base_thick);

            translate([width/2-wall_thick/2,0]){
                centredCube(wall_thick,length,height);
            }

            translate([-(width/2-wall_thick/2),0]){
                centredCube(wall_thick,length,height);
            }

            translate([0,length/2-wall_thick/2,0]){
                centredCube(width,wall_thick,height);
            }

            translate([0,-(length/2-wall_thick/2),0]){
                centredCube(width,wall_thick,height);
            }
        }
        
        //subtract notches to make things look like planks
        union(){
            for(i=[1:20]){
                //subtract all the bits to make it look like planks
                translate([width/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            rotate([0,0,90]){
                  for(i=[1:20]){
                //subtract all the bits to make it look like planks
                translate([length/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            }
            
            rotate([0,0,180]){
                  for(i=[1:20]){
                //subtract all the bits to make it look like planks
                translate([width/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            }
            rotate([0,0,-90]){
                  for(i=[1:20]){
                //subtract all the bits to make it look like planks
                translate([length/2+sqrt(2)*wall_thick/2-plank_indent,0,i*plank_height]){
                    rotate([0,45,0]){
                        cube([wall_thick,length*2,wall_thick],center=true);
                    }
                }
            
            }
            }
            
            //subtract screw holes as well
            
        translate([-(truck_width/2-top_screw_holders_from_edge),0,0]){
            cylinder(r=m2_thread_size/2,h=height*2,$fn=200,center=true);
        }
        translate([(truck_width/2-top_screw_holders_from_edge),0,0]){
            cylinder(r=m2_thread_size/2,h=height*2,$fn=200,center=true);
        }
        
        translate([0,length/2-edge/2,0]){
            cylinder(h=base_thick*5,r=m2_thread_size/2, $fn=200,center=true);
        }
        translate([0,-(length/2-edge/2),0]){
            cylinder(h=base_thick*5,r=m2_thread_size/2, $fn=200,center=true);
        }
        
        }
    }
        
        //posts in corners
        translate([width/2,length/2,0]){
            centredCube(support_width,support_width,height);
        }
        //posts in corners
        translate([-width/2,length/2,0]){
            centredCube(support_width,support_width,height);
        }
        //posts in corners
        translate([-width/2,-length/2,0]){
            centredCube(support_width,support_width,height);
        }
        //posts in corners
        translate([width/2,-length/2,0]){
            centredCube(support_width,support_width,height);
        }
        
        //mid supports
        translate([width/2,(length-door_length)/2,0]){
            centredCube(mid_support_width,mid_support_width,height);
        }
        //mid supports
        translate([width/2,-(length-door_length)/2,0]){
            centredCube(mid_support_width,mid_support_width,height);
        }
        //mid supports
        translate([-width/2,(length-door_length)/2,0]){
            centredCube(mid_support_width,mid_support_width,height);
        }
        //mid supports
        translate([-width/2,-(length-door_length)/2,0]){
            centredCube(mid_support_width,mid_support_width,height);
        }
        section_width=(length-door_length)/2-mid_support_width;
        cross_support_angle = atan(side_height/section_width);
        echo(cross_support_angle);
        //cross mid support
        translate([width/2, door_length/2 + section_width/2 + mid_support_width,side_height/2]){
            rotate([cross_support_angle-90,0,0]){
                cube([mid_support_width,mid_support_width,height*2], center=true);
            }
        }
        mirror([1,0,0]){
            translate([width/2, door_length/2 + section_width/2 + mid_support_width,side_height/2]){
                rotate([cross_support_angle-90,0,0]){
                    cube([mid_support_width,mid_support_width,height*2], center=true);
                }
            }
        }
        rotate([0,0,180]){
            translate([width/2, door_length/2 + section_width/2 + mid_support_width,side_height/2]){
                rotate([cross_support_angle-90,0,0]){
                    cube([mid_support_width,mid_support_width,height*2], center=true);
                }
            }
            mirror([1,0,0]){
            translate([width/2, door_length/2 + section_width/2 + mid_support_width,side_height/2]){
                rotate([cross_support_angle-90,0,0]){
                    cube([mid_support_width,mid_support_width,height*2], center=true);
                }
            }
        }
        }
        
        
        //mid supports on the ends
        translate([(width/3)/2,-length/2,0]){
            centredCube(mid_support_width,mid_support_width,height);
        }
        translate([(-width/3)/2,-length/2,0]){
            centredCube(mid_support_width,mid_support_width,height);
        }
        translate([(width/3)/2, length/2,0]){
            centredCube(mid_support_width,mid_support_width,height);
        }
        translate([(-width/3)/2, length/2,0]){
            centredCube(mid_support_width,mid_support_width,height);
        }
        cross_support_angle_end = atan((height-vent_height)/(width/3));
        cross_support_length_end = sqrt((height-vent_height)*(height-vent_height) + (width/3)*(width/3));
        //vents on the ends
        translate([width/6+mid_support_width/2,length/2, height-vent_height]){
            vent(width/3-mid_support_width, vent_height, vent_angle);
        }
        
        translate([-width/2,length/2,0]){
            rotate([0,90-cross_support_angle_end,0]){
                centredCube(mid_support_width,mid_support_width,cross_support_length_end);
            }
        }
        
        
        mirror([0,1,0]){
            translate([width/6+mid_support_width/2,length/2,height-vent_height]){
                vent(width/3-mid_support_width, vent_height, vent_angle);
            }
            translate([-width/2,length/2,0]){
            rotate([0,90-cross_support_angle_end,0]){
                centredCube(mid_support_width,mid_support_width,cross_support_length_end);
            }
        }
        }
        mirror([1,0,0]){
            translate([width/6+mid_support_width/2,length/2,height-vent_height]){
                vent(width/3-mid_support_width, vent_height, vent_angle);
            }
            translate([-width/2,length/2,0]){
            rotate([0,90-cross_support_angle_end,0]){
                centredCube(mid_support_width,mid_support_width,cross_support_length_end);
            }
        }
            mirror([0,1,0]){
                translate([width/6+mid_support_width/2,length/2,height-vent_height]){
                    vent(width/3-mid_support_width, vent_height, vent_angle);
                }
                translate([-width/2,length/2,0]){
            rotate([0,90-cross_support_angle_end,0]){
                centredCube(mid_support_width,mid_support_width,cross_support_length_end);
            }
        }
            }
        }
        rotate([0,0,180]){
            door();
        }
        
        door();
    }

    //only include bits that wouldn't stick outside the roof
    translate([0,0,height-roof_radius]){
        rotate([90,0,0]){
            cylinder(r=roof_radius,h=length*2,center=true,$fn=200);
        }
    }
}//end intersection with roof cylinder

    translate([0,0,-50]){
        cube([100,100,100], center=true);
    }
    if(hole_for_battery_cables){
        translate([0,length/2,cable_d/2+base_thick]){
            rotate([90,0,0]){
                cylinder(h=wall_thick*10,r=cable_d/2,center=true,$fn=200);
            }
        }
    }

}//end difference with chopping off floor
    


