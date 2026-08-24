include <BOSL2/std.scad>

// Chainguard version 1.
// Copyright 2026 Jordan Savoie, no rights reserved.

// Screw type is 6mm M5
// Parameters:
screwDiameter   = 0.2*INCH;
screwPosition   = INCH*(5.761 + 5.431)/4; // Radial position of center of screw hole
plateThickness  = 2; // Thickness of plastic mounting place
plateWidth      = 4.5; // Width of mounting plate
gearThickness   = 0.1*INCH; // Thickness of chainring
washerThickness = 0.039*INCH;
washerDiameter  = 0.3872*INCH;
crankWidth      = 1.5*INCH;
chainBaseGap    = 0.45*INCH; // Distance from innermost part of screw hole to ID of chain
chainExtension  = 0.6*INCH; // Distance from outermost part of screw hole to OD of chain
flare           = 0.25*INCH; // Distance from gear to front derailleur

echo(screwDiameter=screwDiameter);
echo(screwPosition=screwPosition);
echo(str("The screw should be ", washerThickness + gearThickness + plateThickness, " mm long"));

screwBaseDiameter = washerDiameter + 2;
mountOR = screwPosition - screwDiameter/2 + chainBaseGap - 1;
mountIR = mountOR - plateWidth;

flangeBaseOR = mountOR;
flangeBaseIR = flangeBaseOR - plateThickness;
flangeBase = flare + 2 - plateThickness;
flangeBaseFlare = 1;

chainRadius = screwPosition + screwDiameter/2 + chainExtension;
flangeRadius = chainRadius + 2;
echo(flangeRadius=flangeRadius);


$fn=100;


difference(){
union() {
	//Mounting plate
	tube(ir=mountIR, or=mountOR, h=plateThickness,
		  orounding1=plateThickness, irounding=0.5,
		  anchor=BOTTOM);
	// Screw mounting extensions
	intersection(){
		arc_copies(n=4, r=screwPosition){
			right(20)
			cyl(d=screwBaseDiameter + 2*20, h=plateThickness,
				 rounding=0.5,
				 anchor=BOTTOM
			);
			up(plateThickness)
			%circle(d=washerDiameter);
		}
		cylinder(r=flangeBaseIR, h=plateThickness, anchor=BOTTOM);
	}
	// Flange wall
	up(plateThickness)
	tube(or1=flangeBaseOR, or2=flangeBaseOR+flangeBaseFlare,
	     ir1=flangeBaseIR, ir2=flangeBaseIR+flangeBaseFlare, h=flangeBase,
		  orounding2=-1, irounding1=-1,
		  anchor=BOTTOM);
	// Flange
	up(plateThickness + flangeBase)
	tube(or=flangeRadius, ir=flangeBaseIR+flangeBaseFlare, h=plateThickness, 
		  irounding2=plateThickness, orounding=0.5*plateThickness,
		  anchor=BOTTOM);
}

// Screw holes
arc_copies(n=4, r=screwPosition)
cylinder(h=plateThickness, d=screwDiameter+0.5);

// Gap for crank
cube([flangeRadius, crankWidth, 2*plateThickness + flangeBase + 1],
     anchor = BOTTOM + LEFT, spin=45);
}

