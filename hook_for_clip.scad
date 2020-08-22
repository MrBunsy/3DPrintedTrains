//z
thickness = 1;

midbar_width = 3.2;
midbar_height = 9.5;

topbar_width = 15.2;
topbar_height = 1.9;

//from coupling
main_arm_width = 6;

hinge_base_diameter=4.2;
hinge_diameter = 2.3;
hinge_gap = 1.5;
hinge_bar_height = 2.6;
hinge_bar_width=8+1;
hinge_bar_y = 2.6;
hinge_x = 9;
hinge_y = 4.7;
hinge_depth = main_arm_width + 4;

flange_extra = 0.5;
flange_depth = 3;
flange_slit = 0.5;
flange_slit_depth_multiplier = 0.7;

hook_total_height = 4.8;
hook_inner_height = 1.55;
hook_overhang = 1.3;
hook_inner_x = 9.6 + midbar_width;
hook_d = hook_total_height - topbar_height - topbar_height;

anti_wobble_height = 3;

//mid bar
cube([midbar_width, midbar_height, thickness]);

difference(){
    union(){

    //top bar
    translate([0,midbar_height-topbar_height,0]){
        cube([topbar_width, topbar_height, thickness]);
    }

//hook
        translate([hook_inner_x,midbar_height - hook_total_height, 0]){
            cube([topbar_width - hook_inner_x, hook_total_height,thickness]);
        }
        
        translate([hook_inner_x - hook_d,midbar_height - hook_total_height, 0]){
            cube([hook_d, hook_d, thickness]);
        }
        translate([hook_inner_x - hook_d,midbar_height - hook_total_height+hook_d/2, 0]){
            cylinder(h=thickness, r=hook_d/2, $fn=200);
        }
        
    }
    //lop off an angle
    translate([hook_inner_x+hook_d*0.2 ,midbar_height - hook_total_height,-thickness/2]){
rotate([0,0,-30]){
    cube([5,10,thickness*2]);
}
}
}





difference(){
    union(){
        //hinge bar
        translate([-hinge_bar_width,hinge_bar_y,0]){
            cube([hinge_bar_width, hinge_bar_height, thickness]);
        }
        translate([-hinge_x, hinge_y,0]){
            cylinder(h=thickness,r=hinge_base_diameter/2, $fn=200);
        }
        

    }
    union(){
    //hole in the middle        
    translate([-hinge_x, hinge_y,-0.5]){
       cylinder(h=thickness*100,r=hinge_diameter/2, $fn=200);
    }
    //cut out slot at the top
    translate([-hinge_x, hinge_y+hinge_base_diameter/2,-0.5]){
        cube([hinge_gap,hinge_base_diameter,thickness*10],center = true);
    }
}

}

