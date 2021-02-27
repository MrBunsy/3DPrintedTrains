include<constants.scad>
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
module gravel_pile(width,length,height,avg_diameter = m2mm(0.4),seed = 1){
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
                    r = normal_rands[0] < -0.75 ? (avg_diameter/2 - avg_diameter*0.5*0.75) : (avg_diameter/2 + avg_diameter*0.5*normal_rands[0]);
                    x=(xi/widths)*width -width/2;
                    y=(yi/lengths)*length - length/2;
                    h = getHeight(x,y);// + normal_rands[1]*avg_diameter*0.2;
                    translate([x, y, h])rotate([randoms[0]*180,randoms[1]*180,(randoms[0]+randoms[1])*180])sphere(r=avg_diameter/2,$fn=4);
                }
            }

            centred_cube(width,length,side_height);
            // translate([0,0,side_height])scale([width,length,slope])sphere(r=0.5);

        }

        centred_cube(width,length,height*1.5);
    }
    
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


gravel_pile(28,150,20);

// single_gravel_pile(20);