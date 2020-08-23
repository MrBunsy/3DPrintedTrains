
end_diameter = 4.2;
pole_diameter = 1;
holder_diameter=1.8;
total_length=5.5;
pole_length = 1;
end_length=0.8;
buffer_holder_d=1-0.2;

cylinder(r=end_diameter/2, h=end_length, $fn=200);
cylinder(r=pole_diameter/2, h=total_length, $fn=200);
translate([0,0,pole_length+end_length]){
    cylinder(r=holder_diameter/2, h=total_length-(pole_length+end_length), $fn=200);
}
cylinder(r=buffer_holder_d/2,h=total_length+4, $fn=200);