

module flat_head_screw(d, h) {   
    d = d/2;
    //Hole
    translate([0, 0, -(h+d+0.1)])
    cylinder(h+0.2, d, d); 
    //head
    translate([0, 0, -d])
    cylinder(d+0.1, d, 2*(d+0.2));
}

module mounting_plate(hole_pos, thikness, hole_diam, offset)
{
    difference()
    {
        hull()
        {
            for(p=hole_pos)
            {
                translate(p)
                cylinder(h=thikness, r=offset);
            }
        }
        for(p=hole_pos)
        {
            translate(concat(p, thikness))
                flat_head_screw(hole_diam, thikness);
        }
    }
}

mounting_plate([[50,10], [20,60], [5,10]], 5, 4, 8);