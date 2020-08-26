//from fruit van:

width=35;
length=75;
wall_thick=1.5;
base_thick=2;
height=31;
roof_radius=31.4;

roof_overhang=3;
roof_thick=2;

wiggle_room=1.5;

end_ridges_thick=0.5;
end_ridges_wide=1;
rain_guard_thick=0.3;

side_height= roof_radius*cos(asin((roof_overhang+width/2)/roof_radius));
side_height2 = sqrt(roof_radius*roof_radius - (width/2)*(width/2));
echo(side_height);
echo(side_height2);

difference(){
translate([0,0,-side_height]){//get everything in line with the xy plane
    
    //inner section which will slot into the van
    intersection(){
        translate([0,0,height/2]){
            cube([width-wiggle_room,length-wiggle_room,height*2], center=true);
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
            
                translate([0,length/2+roof_overhang/2+end_ridges_wide,0]){
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
            
                translate([0,length/2+roof_overhang/2+end_ridges_wide,0]){
                rotate([90,0,0]){
                    cylinder(r=roof_radius+roof_thick+end_ridges_thick,h=end_ridges_wide,center=true,$fn=200);
                    }
                }
            
            }
        }
        
        
    }
    //remove anythign below the roof
        rotate([90,0,0]){
                cylinder(r=roof_radius,h=length+roof_overhang*4,center=true,$fn=200);
            }
    }

    
    
    //bits to get rain to avoid the door
    
    

}

//lop off below the xy plane
translate([0,0,-50]){
    cube([100,100,100], center=true);
}

}