include <truck_bits.scad>
include <constants.scad>


//wiki says 21.4metre long, but oes this include buffers?
//n-gauge model with buffers => 21.2m
//n-gauge model without buffers -> 20.3m, so assuming without buffers
length = m2mm(21.4-1);
width = m2mm(2.65);
//
height = m2mm(3.9);

//centre of the base of the bit the sticks out between the bogies
centre_length = m2mm(5.9);

echo("length, width,height", length, width,height);


difference(){
	centred_cube(width,length,height);
	centred_cube(width-2,length-2,height-2);
}