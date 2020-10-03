/*
Shape intended to hold the wheels in exactly the right place in a clamp, while slotting them onto their axles
*/

wheel_max_d = 16.5+0.2;

lip = 5;
size = wheel_max_d + 10 + lip;
thick = 10;

//place it flat...
translate([0,0,thick])rotate([0,90,0])
difference(){
	cube([thick,size,size]);
	union(){
		cube([thick-lip,size-lip,size-lip]);
		translate([0,(size-lip)/2,(size-lip)/2])rotate([0,90,0])cylinder(r=wheel_max_d/2,h=thick*2.5,center=true,$fn=500);
	}
}