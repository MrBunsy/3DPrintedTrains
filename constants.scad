//hornby is a little higher than many of the others, 
//was using 7.9, but then I had trouble with the coupling hook catching on pointwork
top_of_coupling_from_top_of_rail = 8.4;

coupling_from_edge=2.5;

//again hornby seems higher than Lima and friends, but it makes my life easier so I'll take it
//hornby seens to be 17.6, lima about 16.5. i'll go for 17
top_of_buffer_from_top_of_rail = 17;//16.0;

//pointy bit to pointy bit of spare hornby axles (also works for dapol axles)
axle_width = 25.65;

m2_thread_size = 2;
m2_thread_size_loose = 2.3;
m2_head_size=4.5;
m3_thread_loose_size = 3.2;
m3_thread_d = 3.0;
$fn=200;

//how far apart the centres of the buffers are
buffer_distance = 22.2;
buffer_holder_d = 2;
//how deep the buffer holder hole needs to be
buffer_holder_length = 4.5;

//max_d doesn't apply within this space in the centre of the axle
axle_centre_space = 8;

//for height of couplings and axle mounts - diameter of the thinner bit of
//the wheel that rests on the rails
//13.5 for the old coach wheels, truck wheels usually smaller (13.15)
//14.0 works for the spare hornby Mk1 coach wheels
//wheel_diameter = 14.0;
//12.8 for spoked dapol wheels
//12.5 for the 3 holes dapol wheels
function getWheelDiameter(dapol_wheels=true, spoked = true) = dapol_wheels ?  ( spoked ? 12.8 : 12.5) : 14.0;

//diameter around which there can be no obstructions for the wheels
function getWheelMaxDiameter(dapol_wheels=true, spoked = true) = dapol_wheels ? 14+2 : 17+2;
