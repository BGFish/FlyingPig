//draft of new arm+feet modules for piggy
$fn=40;

inch=25.4;

bolts_radius=3/2;//M3
propeller_radius=9*inch/2;

thick=3;
body_thick=4;
body_bottom_thick=5;
body_width=60;
body_height=33;

angle_front=30;//angle between front arm and Left-Right axis
angle_tail=30;//angle between back arm and horizontal

//// Motor mounts
motor_radius=28/2;
jeu=2;
motor_mount_radius=motor_radius+jeu/2;
motor_mount_height=16; // dimension D
motor_3wires_diam=12;
motor_screw_radius=3/2; // M3 From http://www.hobbyking.com/hobbyking/store/__36408__Turnigy_Aerodrive_SK3_2830_1020kv_Brushless_Outrunner_Motor_EU_warehouse_.html
motor_screw_separation_small = 16; // Much more complicated than expected
motor_screw_separation_large = 19; // Much more complicated than expected
motor_hold_width=10;
motor_mount_outradius=motor_mount_radius+thick;

//// Electronics fixing
electronic_size=50;//DroFly: 50mmx50mm
electronic_entraxe=45;
electronic_space=1.4*electronic_size; //space for electronics

body_front_l=1.1*electronic_space/2; //front arms fix positioning
body_back_l=1.1*electronic_space/2; //back arms fix positioning
body_tot_l=body_front_l+body_back_l;

//// Arms and arms fixing.
frontarm_length=propeller_radius*1.6;
backarm_length=propeller_radius*1.3;
nw_front=3;// number of wallies for front arm
nw_back=2;

front_arm_fix_width=52;// width used to fix the front arms
back_arm_fix_width=front_arm_fix_width;

body_back_arm_fix_height=body_height*cos(angle_tail);

arm_fix_height=body_height;
arm_fix_entraxe=30;
back_entraxe=arm_fix_entraxe;
front_entraxe=arm_fix_entraxe;
body_2_backarm_l=back_entraxe*3/2;

// Front foot variables
foot_support_height = 30;
foot_height = 5;

front_foot_thickness = 15;
front_foot_support_width = 2*(motor_mount_radius + thick);
front_foot_width = 0.75*front_foot_support_width;
front_foot_D = 10;	// Distance between the supports

// Back foot variables
back_foot_thickness = 15;
back_foot_support_width = body_width/2;
back_foot_width = 1.2*back_foot_support_width;
back_foot_D_1 = 16;	// Distance between the supports
back_foot_D_2 = 7.1;	// Distance between the supports
back_foot_pos_1 = -2;	// Distance between the supports
back_foot_pos_2 = 18;	// Distance between the supports
back_foot_dx = -11;

// Leave space for ESCs in different arms
escspace_l=75;  //length
escspace_w=28;  //width
escspace_h=11;  //height
escspace_d_from_motor=40;//60; //distance between motor axis and motor-side of ESC
escspace_d_from_motor2=92; //one ESC has a different layout, with 3 wires on motor-side
//TODO: ESC space z-position is obtained experimentally here, arm_fix_height/2.3

//hole for usb cable
usb_h=12;
usb_w=12;
usb_offset=-11.3;
elec_h=-5;

//// Misc

serre_hole1=3;// serre-cable holes dimensions
serre_hole2=6;


motor_mount_height=15;
motor_hole_diam=2*3.75;

//#### Part: arm
//#Sub modules: motor_mount, sidewall,renfort




arm_length=150;
arm_fix_width=50;
arm_angle=atan((arm_fix_width-2*motor_mount_outradius)/(2*arm_length));
renfort_width=5;
n_renforts=2;



module motor_mount(){
/*	%translate([0,0,45+0*motor_mount_height*2])cylinder(h=10,r=propeller_radius);*/

	difference(){
		rotate_extrude(convexity=10)
		translate([motor_mount_outradius,0,0])
		projection()
		rotate([0,90,90])
			softangle(1,thick,2*thick,thick,motor_mount_height,thick);
		translate([motor_radius/2,-motor_3wires_diam/2,thick])
			cube([motor_radius,motor_3wires_diam,motor_mount_height]);
	}

	translate([0,0,thick/2])
		3holeplank(2*motor_mount_radius,motor_3wires_diam,thick,motor_hole_diam,2*motor_screw_radius,motor_screw_separation_large);

	rotate([0,0,90])translate([0,0,thick/2])
		3holeplank(2*motor_mount_radius,motor_3wires_diam,thick,motor_hole_diam,2*motor_screw_radius,motor_screw_separation_small);

}


module sidewall(){
	softangle(arm_length,thick,2*thick,thick,motor_mount_height,2*thick);
	translate([arm_length,0,0])
	rotate([0,0,90])
		softangle(thick,motor_mount_height,arm_length,motor_mount_height,arm_fix_height,arm_fix_height-motor_mount_height);
}


module renfort(side1,side2){
	rotate([0,0,90])
	difference(){
			trapeze(side2,side1,renfort_width,motor_mount_height);
		translate([0,0,motor_mount_height+2*thick])
		rotate([90,0,0])
			cylinder(r=motor_mount_height,h=1.2*renfort_width,center=true);
	}
}


module arm(){

	difference(){
		union(){
			//side walls
			translate([0,-motor_mount_outradius,0])
			rotate([0,0,-arm_angle]) 
				sidewall();
			mirror([0,1,0])
			translate([0,-motor_mount_outradius,0])
			rotate([0,0,-arm_angle])
				sidewall();
			//floor
			translate([arm_length/2,0,0])
			rotate([0,0,-90])
				trapeze(2*motor_mount_outradius,arm_fix_width,arm_length,thick);
		}
		cylinder(h=2*motor_mount_height,r=motor_mount_outradius,center=true);
	}


	//motor mount
	motor_mount();


	//renforts
	incr=arm_length/(n_renforts+1);
	for ( i=[1:n_renforts] ){
		assign(
					side1=2*motor_mount_outradius+2*(i*incr-renfort_width/2)*sin(arm_angle),
					side2=2*motor_mount_outradius+2*(i*incr+renfort_width/2)*sin(arm_angle)
				)
		translate([i*incr,0,0])
			renfort(side1,side2);
	}


	//fixation vers body
	translate([arm_length,0,arm_fix_height/2])
	rotate([90,0,90])
	3holeplank(arm_fix_width,arm_fix_height,2*thick, 1.5*motor_3wires_diam,2*bolts_radius,arm_fix_entraxe );


}




leg_fix_entraxe=motor_mount_outradius;


/*incr=arm_length/(n_renforts+1);*/
/*difference(){*/
/*	arm();*/
/*	for ( i=[1:n_renforts] ){*/
/*		translate([(i+0.25)*incr,0,0])*/
/*		rotate([0,0,90])*/
/*			union(){*/
/*				2holes(2*bolts_radius,leg_fix_entraxe);*/
/*				translate([0,-leg_fix_entraxe,0])*/
/*				2holes(2*bolts_radius,leg_fix_entraxe);*/
/*			}*/
/*		}*/

/*}*/





//##############
//#### Part: legs
//#Sub modules: 

leg_height=50;
leg_fix_width=35;
ankle_width=15;
foot_width=30;
foot_height=5;


height_above_ground=foot_height/2+thick/2+leg_height;

module xleg(){
	//body fix
	difference(){
		cube([leg_fix_width,leg_fix_width,thick],center=true);
		translate([0,leg_fix_entraxe/2,0])
			2holes(2*bolts_radius,leg_fix_entraxe);
		translate([0,-leg_fix_entraxe/2,0])
			2holes(2*bolts_radius,leg_fix_entraxe);
	}


	module half_leg(){
		translate([0,-leg_fix_width/2+thick,0])
		rotate([leg_angle,0,0])
		translate([0,0,-leg_height/(2*cos(leg_angle))])
		cube([leg_fix_width,thick,leg_height/cos(leg_angle)],center=true);

		translate([0,-leg_fix_width/2+thick,0])
		rotate([3*leg_angle,0,0])
		translate([0,0,-leg_height/(2*cos(3*leg_angle))])
		cube([leg_fix_width,thick,leg_height/cos(3*leg_angle)],center=true);
	}

	//leg
	half_leg();
	mirror([0,1,0])
	half_leg();


	//foot
	translate([0,0,-leg_height])
	minkowski(){
		cylinder(r=3*thick,h=foot_height/2,center=true);
		cube([leg_fix_width-3*thick,foot_width-3*thick,foot_height/2],center=true);
	}

}




module leg(){
	//body fix
	difference(){
		cube([leg_fix_width,leg_fix_width+thick,thick],center=true);
		translate([0,leg_fix_entraxe/2,0])
			2holes(2*bolts_radius,leg_fix_entraxe);
		translate([0,-leg_fix_entraxe/2,0])
			2holes(2*bolts_radius,leg_fix_entraxe);
	}


	module half_leg(){

		alpha=atan((leg_fix_width-ankle_width)/(2*leg_height));
		beta=atan((leg_fix_width+ankle_width)/(2*leg_height));

		translate([0,-leg_fix_width/2,0])
		rotate([alpha,0,0])
		translate([0,0,-leg_height/(2*cos(alpha))])
		cube([leg_fix_width,thick,leg_height/cos(alpha)],center=true);

		translate([0,-leg_fix_width/2,0])
		rotate([beta,0,0])
		translate([0,0,-leg_height/(2*cos(beta))])
		cube([leg_fix_width,thick,leg_height/cos(beta)],center=true);
	}

	//leg
	half_leg();
	mirror([0,1,0])
	half_leg();


	//foot
	translate([0,0,-leg_height])
	minkowski(){
		cylinder(r=3*thick,h=foot_height/2,center=true);
		cube([leg_fix_width-6*thick,foot_width-6*thick,foot_height/2],center=true);
	}

}




module back_leg(){
	//body fix
	difference(){
		cube([leg_fix_width,leg_fix_width+thick,thick],center=true);
		translate([0,leg_fix_entraxe/2,0])
			2holes(2*bolts_radius,leg_fix_entraxe);
		translate([0,-leg_fix_entraxe/2,0])
			2holes(2*bolts_radius,leg_fix_entraxe);
	}


	alpha=atan((leg_fix_width-ankle_width)/(2*leg_height));
	beta=atan((leg_fix_width+ankle_width)/(2*leg_height));

	module half_leg(){
		translate([0,-leg_fix_width/2,0])
		rotate([alpha,0,0])
		translate([0,0,-leg_height/(2*cos(alpha))])
		cube([leg_fix_width,thick,leg_height/cos(alpha)],center=true);

		translate([0,-leg_fix_width/2,0])
		rotate([beta,0,0])
		translate([0,0,-leg_height/(2*cos(beta))])
		cube([leg_fix_width,thick,leg_height/cos(beta)],center=true);
	}

	//leg
	half_leg();
	mirror([0,1,0])
	half_leg();

	translate([0,-leg_fix_width/2,0])
	rotate([alpha,0,0])
	translate([0,0,-leg_height/cos(alpha)])
	cube([leg_fix_width,thick,0.3*leg_height/cos(alpha)],center=true);




	//foot
	translate([0,0,-1.1*leg_height])
	rotate([angle_tail,0,0])
	minkowski(){
		cylinder(r=3*thick,h=foot_height/2,center=true);
		cube([leg_fix_width-6*thick,foot_width-6*thick,foot_height/2],center=true);
	}

}












translate([0,25,(thick-height_above_ground)/2])
cube([1,1,height_above_ground],center=true);

rotate([-angle_tail,0,0])
back_leg();



//#################
//#### Handy tools


module torus(outer_radius,cross_section_radius){
	rotate_extrude(convexity = 10)
	translate([outer_radius-cross_section_radius, 0, 0])
	circle(r = cross_section_radius); 
}



module 1holeplank(length,width,thickness,hole_diam){
	difference(){
		cube([length,width,thickness],center=true);
			cylinder(h=3*thickness,r=hole_diam/2,center=true);
	}
}


module 2holes(diam,sep,h=100){
	translate([-sep/2,0,0])
		cylinder(h=h,r=diam/2,center=true);
	translate([sep/2,0,0])
		cylinder(h=h,r=diam/2,center=true);
}


module 3holeplank(length,width,thickness,center_hole_diam,side_hole_diam,side_hole_sep){
	difference(){
		1holeplank(length,width,thickness,center_hole_diam);
		2holes(side_hole_diam,side_hole_sep);
	}
}



module demitrapeze(base,top,height,thick){
	linear_extrude(height=thick)
		polygon(points=[[0,0],[base,0],[top,height],[0,height]],paths=[ [0,1,2,3] ]);
}


module softangle(length, depth1, depth2, height1, height2,radius){
	cube([length,depth2,height1]);
	cube([length,depth1,height2]);
	difference(){
		cube([length,depth1+radius,height1+radius]);
		translate([-0.05*length,depth1+radius,height1+radius])rotate([0,90,0])
			cylinder(h=1.1*length,r=radius);
	}
}


module trapeze(base,top,height,thick){
     linear_extrude(height=thick)
     polygon(points=[[base/2,-height/2],[-base/2,-height/2],[-top/2,height/2],[top/2,height/2]],paths=[ [0,1,2,3] ]);
}

aaa=3.17;
module m3nut(){
	union(){
		cube([5.5,aaa,body_bottom_thick/2],center=true);
		rotate([0,0,60])cube([5.5,aaa,body_bottom_thick/2],center=true);
		rotate([0,0,-60])cube([5.5,aaa,body_bottom_thick/2],center=true);
    }
}
//scale(100)m3nut();
