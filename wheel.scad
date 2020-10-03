//diameters = [15,15, 12.7, 12.6];//not much gradient on the wheel part with this
diameters = [16.5,16.5, 14.45, 14.0];
depths = [0.4, 0.3, 2.7];//total 3.4
//might need to make first dpeth longer to reduce wobble?
$fn=1000;

//intended for a 2mm brass rod of length 21.2mm (better slightly shorter, so it doesn't stick out the ends and therefore is easy to use in a clamp)


module wheel_segment(i){
    cylinder(r1=diameters[i]/2, r2=diameters[i+1]/2, h=depths[i], $fn=2000);
    if(i< len(depths)-1){
        translate([0,0, depths[i]]){
            wheel_segment(i+1);
        }
    }
}

//2mm rod
axle_r=1;

difference(){
    wheel_segment(0);
    //2.1 radius was perfect for m4
    //2.1 diameter was too tight for m2 (try 2.2?)
    //2.2 still a bit tight
    //2.3 still too tight?!
	
	union(){
		//2mm rod
		cylinder(h=10, r=axle_r, center=true);
		
		difference(){
			translate([0,0,2.9])cylinder(h=10, r=diameters[len(diameters)-1]/2-1.5);
			cylinder(h=10, r=5.8/2, center=true);
		}
	}
}