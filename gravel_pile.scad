include<constants.scad>
// use <scad-utils/lists.scad>

function flatten(l) = [ for (a = l) for (b = a) b ] ;
/**

Plan: in python (or other) generate heightmap based on random cones
then with a function to getHeight(x,y), add random gravel chunks

*/

//convert two uniform distrubtion(0,1) (u1,u2) to aproximation of normal distribution [z1, z2]
//
function box_muller(u1,u2) = [sqrt(-2*ln(u1)) * cos(2*180*u2),  sqrt(-2*ln(u1)) * sin(2*180*u2)]; 


/**
width, length and height of the container
*/
module gravel_pile(width,length,height,avg_diameter = m2mm(0.2),seed = 1){
    tip_height = height*0.7;
    side_height = tip_height*0.8;

    tip_length = length*0.7;

    widths = ceil(width/(avg_diameter*0.3));
    lengths = ceil(length/(avg_diameter*0.3));

    random = rands(0.00001,0.99999,widths*lengths*2,seed);

    slope = tip_height - side_height;
    //idea inspired by CoalGen: https://github.com/StephanRichter/CoalGen/blob/master/src/coalgen.cpp
    function getHeight(x,y) = side_height + slope*sin((x/width)*180+90) + slope*sin((y/length)*180+90);

    echo(sin(180))

    intersection(){
        union(){
            // //min 5 gravel cone, max 10
            // for(i=[0:floor(random[0]*5+5)]){
            //     echo(i)
            //     translate([width*0.5*(random[(i*2)+1]-0.5), length*(random[i*2+2]-0.5),0 ])single_gravel_pile(tip_height);
            // }
            for(xi = [0:widths-1]){
                // echo("x",xi, (x/widths)*width)
                for(yi = [0:lengths-1]){
                    randoms = [random[xi + yi*widths], random[(xi + yi*widths + widths*lengths)]];

                    normal_rands = box_muller(randoms[0],randoms[1]);
                    // echo("box mullers: ", normal_rands);
                    //hard cut off on smallest size
                    r = normal_rands[0] < -0.75 ? (avg_diameter/2 - avg_diameter*0.5*0.75) : (avg_diameter/2 + avg_diameter*0.1*normal_rands[0]);
                    // r=avg_diameter/2;
                    x=(xi/widths)*width -width/2;
                    y=(yi/lengths)*length - length/2;
                    h = getHeight(x,y);// + normal_rands[1]*avg_diameter*0.2;
                    translate([x, y, h])rotate([randoms[0]*180,randoms[1]*180,(randoms[0]+randoms[1])*180])sphere(r=r,$fn=4);
                }
            }

            // centred_cube(width,length,side_height);
            // translate([0,0,side_height])scale([width,length,slope])sphere(r=0.5);
            gravel_pile_smooth(width,length,height);
        }

        centred_cube(width,length,height*1.5);
    }
    
}


module gravel_pile_smooth(width,length,height,seed = 1,avg_diameter = m2mm(0.4)){
    tip_height = height*0.7;
    side_height = tip_height*0.8;

    tip_length = length*0.7;
    slope = tip_height - side_height;
    echo("side_height",side_height);
    size = floor(width/2);
    step = 2;
    function f(x,y) = side_height + slope*sin((x/(size))*180+90) + slope*sin((y/size)*180+90);

    function p(x, y) = [ x, y, f(x, y) ];
    function p0(x, y) = [ x, y, 0 ];
    function rev(b, v) = b ? v : [ v[3], v[2], v[1], v[0] ];
    function face(x, y) = [ p(x, y + step), p(x + step, y + step), p(x + step, y), p(x + step, y), p(x, y), p(x, y + step) ];
    function fan(a, i) = 
        a == 0 ? [ [ 0, 0, 0 ], [ i, -size, 0 ], [ i + step, -size, 0 ] ]
        : a == 1 ? [ [ 0, 0, 0 ], [ i + step,  size, 0 ], [ i,  size, 0 ] ]
        : a == 2 ? [ [ 0, 0, 0 ], [ -size, i + step, 0 ], [ -size, i, 0 ] ]
        :          [ [ 0, 0, 0 ], [  size, i, 0 ], [  size, i + step, 0 ] ];
    function sidex(x, y) = [ p0(x, y), p(x, y), p(x + step, y), p0(x + step, y) ];
    function sidey(x, y) = [ p0(x, y), p(x, y), p(x, y + step), p0(x, y + step) ];

    points = flatten(concat(
        // top surface
        [ for (x = [ -size : step : size - step ], y = [ -size : step : size - step ]) face(x, y) ],
        // bottom surface as triangle fan
        [ for (a = [ 0 : 3 ], i = [ -size : step : size - step ]) fan(a, i) ],
        // sides
        [ for (x = [ -size : step : size - step ], y = [ -size, size ]) rev(y < 0, sidex(x, y)) ],
        [ for (y = [ -size : step : size - step ], x = [ -size, size ]) rev(x > 0, sidey(x, y)) ]
    ));

    tcount = 2 * pow(2 * size / step, 2) + 8 * size / step;
    scount = 8 * size / step;

    tfaces = [ for (a = [ 0 : 3 : 3 * (tcount - 1) ] ) [ a, a + 1, a + 2 ] ];
    sfaces = [ for (a = [ 3 * tcount : 4 : 3 * tcount + 4 * scount ] ) [ a, a + 1, a + 2, a + 3 ] ];
    faces = concat(tfaces, sfaces);

    scale([width/size,length/size,1])polyhedron(points, faces, convexity = 8);

    // Written in 2015 by Torsten Paul <Torsten.Paul@gmx.de>
    //
    // To the extent possible under law, the author(s) have dedicated all
    // copyright and related and neighboring rights to this software to the
    // public domain worldwide. This software is distributed without any
    // warranty.
    //
    // For details of the CC0 Public Domain Dedication see
    // <http://creativecommons.org/publicdomain/zero/1.0/>.

}

module single_gravel_pile(height,avg_diameter = m2mm(0.1), repose_angle=30, seed =1){
    //radius of pile
    r = height / tan(repose_angle);

    r2 = r*0.1;
    //cylinder(r1=r,r2=0,h=height);
    hull(){
        translate([0,0,height-r2])sphere(r=r2, $fn=10);
        cylinder(r1=r,r2=0,h=height, $fn=20);
    }
}


// gravel_pile_smooth(28,150,20);
// gravel_pile(28,150,20);


// single_gravel_pile(20);