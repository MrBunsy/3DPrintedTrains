include <constants.scad>

brake_wheel = true;

truck_fixing_d=1.7;

sticks_out = 1;
wheel_thick = 0.5;
wheel_d = 6;
arms=3;


if(brake_wheel){
    //stick to slot into wagon
    translate([0,0,wheel_thick+sticks_out])cylinder(h=buffer_holder_length+sticks_out,r=truck_fixing_d/2);

    //bit to join wheel and fixing arm
    translate([0,0,0])cylinder(h=wheel_thick+sticks_out,r1=truck_fixing_d*0.5, r2=truck_fixing_d/2);

    //actual wheel
    difference(){
        cylinder(h=wheel_thick,r=wheel_d/2);
        cylinder(h=wheel_thick*3,r=wheel_d/2-wheel_thick, center=true);
    }

    //wheel arms
    intersection(){
        cylinder(h=wheel_thick,r=wheel_d/2);
        
        for(i=[0:arms]){
            rotate(i*360/arms)translate([-wheel_thick/2,0,0])cube([wheel_thick,100,wheel_thick]);
            
        }
    }
}