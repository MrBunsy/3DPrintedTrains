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

//    ||    truck fixing
//    ||
//  -|  |-  truck end
//  -|  |-    
//   | |    holder
//   | |     
//   _||_    pole
//   ____    end

holder_length=4;


//end that would touch another buffer if it were real
end_diameter = 4.5;
pole_diameter = 2;//1;
holder_diameter=2;//1.8;
total_length=5.5;
pole_length = 1;
end_length=0.8;
//1.8 bit too big for the 2.0 diameter holes
//this was 1.7, but since using the buffer fixings with holes behind them, it's a bit loose, going back to 1.8
truck_fixing_d=1.7;//1.7;//1.5;

endplate_d = end_diameter;
endplate_length=0.5;



//height from the point of view on the train, +ve y here
max_height=3.5;

cylinder(r=end_diameter/2, h=end_length, $fn=200);
cylinder(r=pole_diameter/2, h=total_length, $fn=200);
translate([0,0,pole_length+end_length]){
    cylinder(r=holder_diameter/2, h=total_length-(pole_length+end_length), $fn=200);
}
cylinder(r=truck_fixing_d/2,h=total_length+holder_length, $fn=200);

translate([0,0,total_length-endplate_length]){
    intersection(){
        union(){
            cylinder(r=endplate_d/2, h=endplate_length, $fn=200);
            cone_height = 1;
            //add a cone around the truck end, should help it print more cleanly
            translate([0,0,-endplate_length*2]){
                cylinder(r2=endplate_d/2,r1=pole_diameter/2, h=cone_height,$fn=200);
            }
        }
        cube([100,max_height,100], center=true);
    }
}

