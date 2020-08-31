//diameters = [15,15, 12.7, 12.6];//not much gradient on the wheel part with this
diameters = [15,15, 12.7, 12.4];
depths = [0, 0.2, 2.0];
//might need to make first dpeth longer to reduce wobble?


module wheel_segment(i){
    cylinder(r1=diameters[i]/2, r2=diameters[i+1]/2, h=depths[i], $fn=200);
    if(i< len(depths)-1){
        translate([0,0, depths[i]]){
            wheel_segment(i+1);
        }
    }
}

difference(){
    wheel_segment(0);
    //2.1 radius was perfect for m4
    //2.1 diameter was too tight for m2 (try 2.2?)
    //2.2 still a bit tight
    //2.3 still too tight?!
    cylinder(h=10, r=2.4/2, $fn=200, center=true);
}