
$fn=50;

use <mounting_plate.scad>;
use <dovetail.scad>;
use <clip.scad>;



// Depth to the ski slot
ski_slot_depth = 130;


// Finger width
finger_width = 15;

tickness = 8;


holder_width =  2 * finger_width;
holder_depth = ski_slot_depth + tickness;


// Mounting holde diameter
mh_d = 4.2;

// Mounting hole offset
mh_offset = 15;

// Corner radius
r=5; // [1:10]

// Ski-pole diameter
pole_diam=18;
// Ski-pole holder diameter
pole_holder_tickness=4;

chamf_diam=6;



module base_plate()
{
    translate([-0,- tickness, 0])
        rotate([-90,0,0])
            mounting_plate(
                [
                    [finger_width/2, -mh_offset-tickness],
                    [finger_width/2, holder_depth/2+mh_offset],
                    // Side hole
                    [-mh_offset, -tickness/2]
                ],
                tickness,
                mh_d,
                finger_width/2
            );
}

module chanfin(r, l, angle)
{
    s= r/sin(angle);
    y = r*cos(angle/2);
    x= y /tan(angle/2);
    linear_extrude(l)
    rotate([0, 0, angle/2])
    difference()
    {
        
        polygon([
            [0, 0],
            [x, y],
            [x, -y],
        ]);
        translate([r/sin(angle/2), 0, 0])
            circle(r=r);
    }
}

module tooth(w, h, d, offset) {
    hull() 
    {
        cube([w, h, 0.1]);
        translate([offset/2, offset/2, 0])
            cube([w-offset, h-offset, d]);
    }   
}

teeth_depth = tickness/2;
teeth_width = 2;

// 1 Finger
module finger()
{
    difference() {
        union()
        {
    
            // Finger
            cube([finger_width, holder_depth, tickness]);
    
            // base chanfins
            rotate([0, 90, 0])
                chanfin(chamf_diam, finger_width, 90);
            translate([0, 0, tickness])
                rotate([0, 90, 0])rotate([0, 0, 90])
                    chanfin(chamf_diam, finger_width, 90);
        }
    
        // Two Clip slots
        translate([4, holder_depth, 3*tickness/4])
            rotate([180, 0,-90])
                clip_pocket(3, 15, tickness/2, 1, 5);

        translate([finger_width-tickness/4-teeth_width, holder_depth, tickness/4])
            rotate([0, 0,-90])
                clip_pocket(3, 15, tickness/2, 1, 5);
    }       
}

// Ski pole holder
module pole_holder()
{

    difference() 
    {
        hull()
        {
            cube([finger_width, 1, tickness]);
                translate([0, (pole_diam+2*pole_holder_tickness)/2, 0])
            cylinder(tickness, d=pole_diam+2*pole_holder_tickness);
        }
        
        // Slot for the pole
        translate([0, (pole_diam+2*pole_holder_tickness)/2, -1])
            cylinder(tickness+2, d=pole_diam);
        
        // Front opening
        translate([-(pole_diam+2*pole_holder_tickness)/2, (pole_diam+2*pole_holder_tickness)/2+5,-1])
            cube([pole_diam+2*pole_holder_tickness, pole_diam+2*pole_holder_tickness, tickness+2]);

 
        
    }

    translate([4, 0, 3/4*tickness])
        rotate([180, 0,-90])
            clip(3, 15, tickness/2, 1, 5);
    translate([finger_width-tickness/4- teeth_width, 0, tickness/4])
        rotate([0, 0,-90])
            clip(3, 15, tickness/2, 1, 5);
 
}


// Under support base
module support()
{
    union()
    {
        hull()
        {
            translate([0, holder_depth/2-tickness, 0])
                cube([finger_width, sqrt(2)*tickness,0.1]);

            translate([0, 0, -holder_depth/2+tickness, ])
                rotate([-90, 0, 0])
                    cube([finger_width, sqrt(2)*tickness, 0.1]);
        }
        translate([0, holder_depth/2-tickness, 0])
            rotate([0, 90, 0]) rotate([0, 0, -90])
                chanfin(chamf_diam, finger_width, 45);

        translate([0, 0, -holder_depth/2+tickness])
            rotate([0, 90, 0]) rotate([0, 0, 180-45])
                chanfin(chamf_diam, finger_width, 45);

        translate([0, holder_depth/2-tickness+sqrt(2)*tickness, 0])
            rotate([0, 90, 0]) rotate([0, 0, -45])
                chanfin(chamf_diam, finger_width, 135);


        translate([0, 0, -holder_depth/2+tickness-sqrt(2)*tickness ])
            rotate([0, 90, 0]) rotate([0, 0, 0])
                chanfin(chamf_diam, finger_width, 135);
    }
}

// Right half of ski-holder
module half_holder()
{
    union()
    {          
        support();
        
        finger();
  
        *translate([0, holder_depth,  0])
        {
            pole_holder();
        }
        base_plate();
    }
}


plater = flase;

if(plater) {

    translate([0, 0, finger_width])
    rotate([0, 90, 0])
    half_holder();

    translate([-60, 60,  0])
        pole_holder();


    // Left ski-holder
    translate([-100, 150, finger_width])
    rotate([0, -90, -90])
        mirror([1, 0, 0])
        {
            half_holder();

        }

    translate([-30, 100,  0])
    mirror([1, 0, 0])
    {
            pole_holder();
    }

}
else {
    // Right ski-holder
    half_holder();
    translate([0, holder_depth+20,  0])
        pole_holder();


    // Left ski-holder
    translate([60,0,0])
        mirror([1, 0, 0])
        {
            half_holder();
            translate([0, holder_depth,  0])
                pole_holder();
        }
}







