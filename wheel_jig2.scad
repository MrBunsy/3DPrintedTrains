
axle_and_wheel_length = 3.4*2+14.3;
//block exactly the right height to stop the clamp making the wheels too close together
translate([0,5,5])cube([10,axle_and_wheel_length,10]);
cube([10,axle_and_wheel_length+10,5]);