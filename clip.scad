

module clip(
	width, length, tickness, 
	teeth_height, teeth_length, 
	backlash=0.1, vbacklash=0.2
) 
{
	bl = backlash / 2;
	w = width - 2 * bl;
	l = length - bl ;
	th =teeth_height -bl;
	tl = teeth_length -2*bl;

	assert( w > teeth_height*2, "Clip tooth too high");
	assert(l > teeth_length, "Clip tooth too long");

	translate([0, bl, vbacklash])
	linear_extrude(tickness - 2*vbacklash)
	polygon([
		[0, 0],
		[0, w],
		[l - tl, w],
		[l - tl, w + th],
		[l - tl/2, w + th],
		[l, w - th/2],
		[l, 1.5* th],
		[l - tl, 1.5*th],
		[l - 3*tl, 0]
	]);

}


module clip_pocket(
	width, length, tickness, 
	teeth_height, teeth_length,
	backlash=0.1, vbacklash=0.2
)  {

	bl = backlash / 2;
	w = width + 2 * bl;
	l = length + bl ;
	th =teeth_height +bl;
	tl = teeth_length +2*bl;

	translate([0, -bl, -vbacklash])
	linear_extrude(tickness+ 2*vbacklash)
	polygon([
		[0, 0],
		[0, w],
		[l - tl, w],
		[l - tl, w + th],
		[l, w + th],
		[l , 0]
	]);

	
}

difference(){
	translate([0, -1, -1])
	cube([20, 8, 2.9]);

	clip_pocket(5, 15, 3, 1, 3);

}

color("red")
clip(5, 15, 3, 1, 3);

