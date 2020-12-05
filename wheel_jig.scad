/*
Copyright Luke Wallin 2020

This file is part of Luke Wallin's 3DPrintedTrains project.

The 3DPrintedTrains project is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The 3DPrintedTrains project is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with The 3DPrintedTrains project.  If not, see <https:www.gnu.org/licenses/>.
*/

/*
Shape intended to hold the wheels in exactly the right place in a clamp, while slotting them onto their axles
*/

wheel_max_d = 16.5+0.2;

lip = 5;
size = wheel_max_d + 2.5 + lip;
thick = 10;

//place it flat...
translate([0,0,thick])rotate([0,90,0])
difference(){
	cube([thick,size,size]);
	union(){
		cube([thick-lip,size-lip,size-lip]);
		translate([0,size-lip-wheel_max_d/2,size-lip-wheel_max_d/2])rotate([0,90,0])cylinder(r=wheel_max_d/2,h=thick*2.5,center=true,$fn=500);
	}
}