
end_diameter = 4.5;
pole_diameter = 2;//1;
holder_diameter=2;//1.8;
total_length=5.5;
pole_length = 1;
end_length=0.8;
buffer_holder_d=1.5;

endplate_d = end_diameter;
endplate_length=0.5;

holder_length=4;

//height from the point of view on the train, +ve y here
max_height=3.5;

cylinder(r=end_diameter/2, h=end_length, $fn=200);
cylinder(r=pole_diameter/2, h=total_length, $fn=200);
translate([0,0,pole_length+end_length]){
    cylinder(r=holder_diameter/2, h=total_length-(pole_length+end_length), $fn=200);
}
cylinder(r=buffer_holder_d/2,h=total_length+holder_length, $fn=200);

translate([0,0,total_length-endplate_length]){
    intersection(){
    cylinder(r=endplate_d/2, h=endplate_length, $fn=200);
        cube([100,max_height,100], center=true);
    }
}