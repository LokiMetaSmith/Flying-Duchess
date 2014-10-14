/*
 * 6DOF Scaffolding
 *
 * Copyright (C) 2014 Will Hodgson.
 * Author: Will Hodgson <will.hodgson@gmail.com>
 *          
 * This file is licensed under GPLv3.
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 * 
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>
*/
module extrusion_1010(ext_lenght){
	//parameters
	unit_lenght=25.4;
	slot_width=6.5;
	iner_slot_width=14;
	slot_depth=7.5;
	slot_depth_partial=2.2;
	center_circle_d=5;

	color("LightGrey")
	
	linear_extrude(height = ext_lenght, center = true, convexity = 10)
	
	difference(){
		square (unit_lenght,center = true);
		circle(r = center_circle_d/2);
		for(a=[0:3])
		rotate([0,0,a*90])
		polygon( 
		points=[
		[unit_lenght/2,slot_width/2],
		[unit_lenght/2-slot_depth_partial,slot_width/2],
		[unit_lenght/2-slot_depth_partial,7],
		[unit_lenght/2-slot_depth,slot_width/2],
		[unit_lenght/2-slot_depth,-slot_width/2],
		[unit_lenght/2-slot_depth_partial,-7],
		[unit_lenght/2-slot_depth_partial,-slot_width/2],
		[unit_lenght/2,-slot_width/2]] );
	}
}




/////////////////////////// design the motor bracket ////////////////
module motor_bracket(){
	union(){
		difference(){
			translate([0,0,0])rotate([0, 0, 45])cube([70,70,40], center=true);

			union(){
				translate([0,0,30])
				for(i=[0:3]){
					rotate([0, 0, 90*i])
					rotate([45, 0, 0])
					union(){
						cylinder(h=50,d=15 ,center=true);
						cylinder(h=100,d=5 ,center=true);
					}
					translate([0,0,15])
					cylinder(h=32,d1=10,d2=45 ,center=true);
					translate([0,0,-15])
					cylinder(h=32,d1=45,d2=10 ,center=true);
					translate([0,0,-35])
					for(i=[0:3]){
						rotate([0, 0, 90*i])
						rotate([45, 0, 0])
						union(){
							cylinder(h=50,d=15 ,center=true);
							cylinder(h=100,d=5 ,center=true);
						}
					}
				}	
				for(i=[0:3]){
			rotate([0, 0, 90*i])
			translate([0,sqrt(25.4)*8,-sqrt(25.4)*2])
			rotate([45, 0, 0])
			union(){
				extrusion_1010(2*25.4);
				cube([22,22,(2*25.6)],center=true);
				translate([0,10,0])
				cube([22,36,(25.4*2)],center=true);
			}
		}
	}
		}
	}

	translate([25,-15,25])
	rotate([0, 45, 45])
	union(){
		difference(){
			cube([22,7,40],center=true);
			translate([0,0,20])
			rotate([90, 0, 0])
			cylinder(h=8,d=22 ,center=true);
		}
		translate([0,-6,20])
		rotate([90, 45, 0])
		difference(){
			cube([43,43,10],center=true);
			translate([0,0,4])
			union(){
				cube([42,42,5],center=true);
				cylinder(h=25,d=22 ,center=true);
				for(i=[0:2]){
					rotate([0, 0, 90*i])
					translate([15.5,15.5,0])
					cylinder(h=25,d=4 ,center=true);
				}
			}
		}
	}
	translate([-15,25,25])
	rotate([0, 45, 45])
	difference(){
		cube([22,7,40],center=true);
		translate([0,0,20])
		rotate([90, 0, 0])
		cylinder(h=8,d=22 ,center=true);
	}
    cable_spool();
}

//////////////////// design the cable spool ///////////////
module cable_spool(){

	translate([15,15,40])
	rotate([90, 0, 45])
	difference(){
		union(){
			cylinder(h=50,d=22 ,center=true);
			cylinder(h=75,d=8 ,center=true);
			}
		cylinder(h=76,d=5 ,center=true);
	}

}

/////////////////print bed //////////
module print_bed(){

	translate([0,0,100])color( "Aqua", a=0.2 ){cylinder(h=5,d=beam_lenght ,center=true);}
}

/////////////// render 8020 extrusions ///////////////

beam_lenght=1000;
beam = (beam_lenght)-60;

translate([0,0,sqrt((pow(beam_lenght,2))*2)/3])
rotate([90, 55, 0])
union(){
	translate([0,sqrt((pow(beam_lenght,2))*2)/2,0])
	for( i=[0:3]){
		rotate([45, 45+90*i, 0])
		translate([0,0,beam_lenght/2])
		extrusion_1010(beam);
	}
	translate([0,-sqrt((pow(beam_lenght,2))*2)/2,0])
	for( i=[0:3]){
		rotate([-45, 45+90*i, 0])
		translate([0,0,beam_lenght/2])
		extrusion_1010(beam);
	}
	for( i=[0:3]){
		rotate([0, 90*i, 0])
		translate([beam_lenght/2,0,0])
		extrusion_1010(beam);
	}
}


rotate([30, 0, 0])
for(i=[0:5]){
	rotate([60*i, 0, 120*i])
	translate([0,0,beam_lenght/2])
	union(){    /* this is for moving the bracket and spool together */
		motor_bracket();
	}
}
