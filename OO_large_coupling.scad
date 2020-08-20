//20.7cm wide

module frontarc(height, radius, width, thickness){
    //arcsegment
    intersection(){

        difference(){
            cylinder(h=height, r=radius, center=false, $fn=200);

            cylinder(h=height*3, r=radius-thickness, center=true, $fn=200);
        }
        
        translate([0,50,0]){
            cube([width,radius*4,height*3], true);
        }
        
    }
}


//the arc with arms and a base. No mechanism to hold hook or connect to train
module coupling_base(arm_thickness, arm_length, coupling_height, coupling_width, arc_radius, min_thickness, base_width, flange_max, flange_min){



    arc_offset = sqrt(arc_radius*arc_radius- (coupling_width/2)*(coupling_width/2));

    echo(arc_offset);

    translate([0,arm_length-arc_offset,0]){
        //front arc with notch taken out
        difference(){
            frontarc(height=coupling_height, radius=arc_radius, width=coupling_width, thickness=flange_max);
            translate([0,0,min_thickness]){
                frontarc(height=2.5, radius=arc_radius-flange_min, width=20.7-arm_thickness*2, thickness=flange_max);
            }
        }
    }

    //arms

    translate([-coupling_width/2,0,0]){
        cube([arm_thickness,arm_length,coupling_height] );
    }

    translate([coupling_width/2-arm_thickness,0,0]){
        cube([arm_thickness,arm_length,coupling_height] );
    }

    //base
    translate([-coupling_width/2,0,0]){
        cube([coupling_width, base_width, min_thickness]);
    }

}




