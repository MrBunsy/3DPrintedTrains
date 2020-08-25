width=35;
length=75;

wall_thick=2;
base_thick=2;

height=31;
//aiming for side height of 26;
roof_radius=35;

//similar but trying not the same as truck_base
module centredCube(width,length, height){
    translate([-width/2, -length/2,0]){
        cube([width,length, height]);
    }
    
}

intersection(){
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

translate([0,0,height-roof_radius]){
    rotate([90,0,0]){
        cylinder(r=roof_radius,h=length*2,center=true,$fn=200);
    }
}
}

