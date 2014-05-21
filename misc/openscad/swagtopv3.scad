// Bed Variables
BedWidth = 156.7;
FooterHeight = 30;
BedBoardThickness = 5;
ThickerBedBoard = BedBoardThickness + 0.2;
InnerSideBeamHeight = 12.5;
InnerSideBeamThickness = 4.5;
UpperSideBeamWidth = 7.5;
SideBeamLength = 201.2;
HeadBoardHeight = 78;
// Shelf Variables
CabinetDepth = 35;
ThinBoard = 3;
ThickBoard = 5;

dt_w=42;
dt_h=0.5;
dt_d=24;

sh_w=42;
sh_h=0.5;
sh_d=10;

oak_width=0.75;
oak_height=8;

side_w=oak_width;
side_h=oak_height;
side_d=24+oak_width;

back_w=42+oak_width*2;
back_h=oak_height;
back_d=oak_width;

ins_w=oak_width;
ins_h=5;
ins_d=sh_d-0.5;

ov_w=oak_width;
ov_h=oak_height-2;
ov_d=dt_d-sh_d-2;

module cutout() {
	difference() {	
		translate([0,2,0]) {
			color("Brown", 0.6) cube([1, 2, 2]);
		}	
		translate([-.5, 2, 0]) {
			color("Brown", 0.6) rotate(a=[0,90,0]) scale([1, 2, 2]) cylinder(h=1, r4, center=false, $fn=100);	
		}	
	}
}

module desk() {


	difference() { 

	difference() {

	union() {
		translate([0,0,0]) {
			color ("Black", .93) cube([dt_w, dt_d/2, dt_h]);
		}
		translate([0,12,0]) {
			color ("Black", 1) cube([dt_w, dt_d/2, dt_h]);
		}
		translate([0,dt_d-sh_d, 5.5]) {
			color ("Black", .55) cube([sh_w, sh_d, sh_h]);
		}
		translate([-side_w, 0, -1]) {
			color("Brown", 1) cube([side_w, side_d-oak_width, side_h]);
		}
		translate([dt_w, 0, -1]) {
			color("Brown", 1) cube([side_w, side_d-oak_width, side_h]);
		}	
		translate([-oak_width, dt_d, -1]) {
			color("Brown", 1) cube([back_w, back_d, back_h]);
		}	
		translate([6, dt_d-ins_d, 0.5]) {
			color("Orange", 1) cube([ins_w, ins_d, ins_h]);
		}			
		translate([24, dt_d-ins_d, 0.5]) {
			color("Yellow", 1) cube([ins_w, ins_d, ins_h]);
		}			
		translate([30, dt_d-ins_d, 0.5]) {
			color("Blue", 1) cube([ins_w, ins_d, ins_h]);
		}			
		translate([36, dt_d-ins_d, 0.5]) {
			color("Orange", 1) cube([ins_w, ins_d, ins_h]);
		}		
	}
	union() {

			translate([-1,0,oak_height-1.5]) {
			color("Brown", 0.6) rotate(a=[0,90,0]) scale([1, 2.2, 1]) cylinder(h=2, r=ov_d/2, center=false, $fn=100);
			}	
			translate([dt_w-1,0,oak_height-1.5]) {
			color("Brown", 0.6) rotate(a=[0,90,0]) scale([1, 2.2, 1]) cylinder(h=2, r=ov_d/2, center=false, $fn=100);
			}
		}
	}
	union() {
		translate([.1,17.141,oak_height-2]) rotate(a=[180,180,0]) cutout();
		translate([.1+dt_w+oak_width,17.141,oak_height-2]) rotate(a=[180,180,0]) cutout();
	}
}

}

 
module bed_frame() {
        union() {
                translate([0,0,0]) {
                        cube([BedWidth,ThickerBedBoard,FooterHeight]);
                }
                translate([BedWidth-UpperSideBeamWidth,ThickerBedBoard,FooterHeight-BedBoardThickness]) {
                        cube([UpperSideBeamWidth,SideBeamLength,BedBoardThickness]);
                }
                translate([0,ThickerBedBoard,FooterHeight-BedBoardThickness]) {
                        cube([UpperSideBeamWidth,SideBeamLength,BedBoardThickness]);
                }
                translate([UpperSideBeamWidth-InnerSideBeamThickness,ThickerBedBoard,(FooterHeight-BedBoardThickness)/2]) {
                        cube([InnerSideBeamThickness,SideBeamLength,InnerSideBeamHeight]);
                }
                translate([BedWidth-UpperSideBeamWidth,ThickerBedBoard,(FooterHeight-BedBoardThickness)/2]) {
                        cube([InnerSideBeamThickness,SideBeamLength,InnerSideBeamHeight]);
                }
                translate([0,SideBeamLength+BedBoardThickness,0]) {
                        cube([BedWidth,BedBoardThickness,HeadBoardHeight]);
                }
        }
}
 
 
 

desk();
