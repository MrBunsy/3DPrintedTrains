/*gen_pi_cam_wagon = true;
gen_battery_wagon = false;


width=gen_pi_cam_wagon ? 35+1 : gen_battery_wagon ? 29+wall_thick*2 :30+1;
length=gen_pi_cam_wagon ? 85 : 75;
height=gen_pi_cam_wagon ? 31+8 : 31;
*/
module fruit_van_roof(width,length,height){
//from fruit van:
wall_thick=1.5;
//+1 for the girder thickness


base_thick=2;
roof_radius=31.4;
door_length=length/3;

roof_overhang=1;
roof_thick=2;

wiggle_room=0.5;


rain_guard_r = length*1.5;
rain_guard_from_edge = width*0.05;

pi_cam_space = gen_pi_cam_wagon;
pi_space_length =4;
pi_space_width = 9;

end_ridges_thick=0.5;
end_ridges_wide=1;
rain_guard_thick=0.6;

side_height= roof_radius*cos(asin((roof_overhang+width/2)/roof_radius));
side_height2 = sqrt(roof_radius*roof_radius - (width/2)*(width/2));
//echo(side_height);
//echo(side_height2);

difference(){
    //extra 0.2 to try and ensure sides of roof start on the plate, not floating in mid-air...
translate([0,0,-side_height-0.3]){//get everything in line with the xy plane
    
    //inner section which will slot into the van
    intersection(){
        difference(){
            translate([0,0,height/2]){
                cube([width-wall_thick*2-wiggle_room,length-wiggle_room-wall_thick*2,height*2], center=true);
                }
            
    }
        rotate([90,0,0]){
                cylinder(r=roof_radius,h=length+roof_overhang*4,center=true,$fn=200);
            }
    }
    difference(){
        
        
        
        intersection(){//basic outline shape of fruit van + overhang:
            translate([0,0,50]){
                cube([width+roof_overhang*2,length+roof_overhang*2,100], center=true);
            }
        
            rotate([90,0,0]){
                cylinder(r=roof_radius+roof_thick,h=length+roof_overhang*2,center=true,$fn=200);
            }
            
        }
        
        rotate([90,0,0]){
                cylinder(r=roof_radius,h=length+roof_overhang*4,center=true,$fn=200);
            }
        
    }
    
    //extra stuff on roof
    difference(){
        union(){
            //ridge along ends1
            intersection(){
                translate([0,0,50]){
                    cube([width+roof_overhang*2,length+roof_overhang*2,100], center=true);
                }
            
                translate([0,length/2+end_ridges_wide,0]){
                rotate([90,0,0]){
                    cylinder(r=roof_radius+roof_thick+end_ridges_thick,h=end_ridges_wide,center=true,$fn=200);
                }
            }
                
            }
            //ridge along ends2
            mirror([0,1,0]){
                intersection(){
                translate([0,0,50]){
                    cube([width+roof_overhang*2,length+roof_overhang*2,100], center=true);
                }
            
                translate([0,length/2+end_ridges_wide,0]){
                rotate([90,0,0]){
                    cylinder(r=roof_radius+roof_thick+end_ridges_thick,h=end_ridges_wide,center=true,$fn=200);
                    }
                }
            
            }
        }
        //rain guard
        intersection(){
        intersection(){
            union(){
                translate([rain_guard_r+width/2+roof_overhang-rain_guard_from_edge,0,0]){
                    difference(){
                        cylinder(r=rain_guard_r+rain_guard_thick, h=70,$fn=200);
                        cylinder(r=rain_guard_r, h=100,$fn=200);
                    }
                }
                mirror([1,0,0]){
                    translate([rain_guard_r+width/2+roof_overhang-rain_guard_from_edge,0,0]){
                    difference(){
                        cylinder(r=rain_guard_r+rain_guard_thick, h=70,$fn=200);
                        cylinder(r=rain_guard_r, h=100,$fn=200);
                    }
                }
            }
            }
            
            rotate([90,0,0]){
                    cylinder(r=roof_radius+roof_thick+rain_guard_thick,h=length,center=true,$fn=200);
                    }
        }
        //don't allow overhang beyond the roof (or too far from edges of door)
        cube([width+roof_overhang*2,door_length*1.2,100], center=true);
    }
        
    }
    //remove anythign below the roof
        rotate([90,0,0]){
                cylinder(r=roof_radius,h=length+roof_overhang*4,center=true,$fn=200);
            }
    }

    
    
    //bits to get rain to avoid the door
    
    

}
union(){
    //lop off below the xy plane
    translate([0,0,-50]){
        cube([100,100,100], center=true);
    }
   if(pi_cam_space){

            
                translate([0,length/2-wall_thick-wiggle_room/2,0]){
                    cube([pi_space_width,pi_space_length*2,100], center=true);
                }

            
        }
    
}

}



}