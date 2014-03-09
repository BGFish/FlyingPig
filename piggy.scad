//Hexagonal holes for electronic bolts
//Higher feet
//Add more space for ESC cables

$fn=40;

inch=25.4;

bolts_radius=3/2;//M3
propeller_radius=9*inch/2;

thick=2;
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

body_front_l=electronic_space/2; //front arms fix positioning
body_back_l=electronic_space/2; //back arms fix positioning
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
arm_fix_entraxe=40;
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
escspace_d_from_motor=60; //distance between motor axis and motor-side of ESC
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

// Generate STLs
//body
//body();

//Back feet
//rotate([0, 90, 0]) back_feet();

//Back arms
//arm_rotated(backarm_length,back_arm_fix_width,nw_back,false);

//Front arms
//arm_rotated(frontarm_length,front_arm_fix_width,nw_front,true);

//Front feet
//rotate([0, 90, 0]) foot_front();

// Generate GIF of assembled drone.
//rotate([0, 0, $t*360]) translate([0, body_length*0.33, 0]) assembly();


//##############
//##### Assembly,
assembly();
//sub-parts: 4*arm_rotated,body_back,body_front
// body:preassembly of body_back and body_front
module assembly(){
	//Front arms
	translate([0,body_front_l,0]){
	front_armAndFoot_positioned(isRight=1);// front-right arm
    front_armAndFoot_positioned(isRight=-1);	//front-left arm
    }
	//Back arms
	back_arm_positioned(isRight=1);
	back_arm_positioned(isRight=-1);

	translate([0,0,body_height/2])body();
	translate([0,body_back_l/4,-body_height/2])battery_big();

}

module front_armAndFoot_positioned(isRight){
	translate([isRight*(body_width/2-front_arm_fix_width*sin(angle_front)/2),front_arm_fix_width*cos(angle_front)/2,0])
	rotate([0,0,(1-isRight)*90+isRight*angle_front]){
		arm_rotated(frontarm_length,front_arm_fix_width,nw_front,true);
		translate([frontarm_length*0.5,0,0])foot_front();
		//%translate([1.15*frontarm_length/nw_front,0,0])ESC();
	}
}

module back_arm_positioned(isRight){
    translate([0,-body_back_l+thick-body_2_backarm_l/2,0]){
    translate([isRight*body_width/2,0,0])
	rotate([0,-angle_tail,90*(isRight-1)]){
		arm_rotated(backarm_length,back_arm_fix_width,nw_back,false);
		//%translate([1.0*backarm_length/nw_back,0,0])ESC();
	}
	translate([0,-back_arm_fix_width/4,0])rotate([0,0,90])back_feet();
	}
}

//##############
//#### Part: body
//body();

module body(){  //electronics
difference(){
union(){
	difference(){
			union(){
				translate([0,body_front_l/2,0])cube([body_width,body_front_l,body_height],center=true);
				translate([0,-body_back_l/2,0])cube([body_width,body_back_l,body_height],center=true);
				cylinder(h=body_height,r=electronic_space/2+body_thick
					,center=true);
				}
			translate([0,0,body_bottom_thick]){
				cylinder(h=body_height,r=electronic_space/2,center=true);
				cube([body_width-2*body_thick,2*body_tot_l,body_height],center=true);
			}
			for (i=[-1,1]) for(j=[-1,1]){
				translate([i*electronic_entraxe/2,j*electronic_entraxe/2,-body_height/2])cylinder(h=3*body_bottom_thick,r=bolts_radius,center=true);
			}
			for(i=[-1,1]){for(j=[-1,1]){// pour des serre-cables
			translate([i*(body_width/2-body_thick-serre_hole1/2),j*(electronic_space/2-3*thick),-body_height/2])cube([serre_hole1,serre_hole2,4*body_bottom_thick],center=true);

		    }}
			for (i=[-1,1]) for(j=[-1,1]) for (k=[-1,1]){// pour des vis
				translate([i*body_width/2,j*(electronic_space/2-3*thick),k*body_height/4])
				    rotate([0,90,0])cylinder(h=3*body_thick,r=bolts_radius,center=true);
			}
			// for usb cable
			translate([-body_width/2,usb_offset,elec_h])cube([body_width,usb_w,usb_h],center=true);	
	}
			%DroFly();

// back arms fix
	translate([0,-body_back_l+body_thick-body_2_backarm_l/2,body_back_arm_fix_height/2-body_height/2])
					body_2_backarms(body_back_arm_fix_height);
					
	translate([0,body_front_l+front_arm_fix_width*cos(angle_front)/2,-body_height/2])body_2_frontarms();
	
}// end of union
    //hole for battery cable (optional?)
    translate([0,body_front_l,0])
    for(i=[0,1]){
        mirror([0,i,0])mirror([0,0,1])
        translate([0,front_arm_fix_width/8,0])trapeze              (body_width/2,body_width/4,front_arm_fix_width/4,body_height);
    }
}// end of difference
}// end of body() module 

module body_2_frontarms(){// body to front_arms junction
	difference(){
		trapeze(body_width,body_width-front_arm_fix_width*sin(angle_front)*2,front_arm_fix_width*cos(angle_front),body_height);

		translate([0,-thick,body_bottom_thick])trapeze(body_width-thick*2,body_width-front_arm_fix_width*sin(angle_front)*2-thick*2,front_arm_fix_width*cos(angle_front),body_height
);
		for(side=[-1,1]){
		translate([side*(body_width/2-front_arm_fix_width*sin(angle_front)/2-thick*0.8+0/2/cos(angle_front)),0,body_height/2])
		rotate([0,90,side*angle_front]){
			for(i=[-1,1]){
				translate([0,i*front_entraxe/2,0])
					cylinder(h=2*thick,r=bolts_radius,center=true);
			}
			cylinder(h=2*thick,r=motor_3wires_diam/2,center=true);
		}
		}
	}
}
//body_2_frontarms();

module body_2_backarms_fix(body_height){
translate([-body_height*tan(angle_tail)/2,0,0]){
rotate([0,-angle_tail,0])
	difference(){
		cube([thick,body_2_backarm_l,body_height/cos(angle_tail)],center=true);
		for(i=[-1,1]){
			translate([0,i*back_entraxe/2,0])
			rotate([0,90,0])
				cylinder(h=2*thick,r=bolts_radius,center=true);
		}
		rotate([0,90,0])
			cylinder(h=2*thick,r=motor_3wires_diam/2,center=true);
		}
}
}

module body_2_backarms(body_height){
difference(){
	union(){
	translate([body_width/2,0,0])
	body_2_backarms_fix(body_height);
	translate([-body_width/2,0,0])rotate([0,0,180])body_2_backarms_fix(body_height);

	//This is the bottom plate
	translate([0,0,-body_height/2+body_bottom_thick/2])cube([body_width,body_2_backarm_l,body_bottom_thick],center=true);

	//This is the front rectangles
	translate([0,body_2_backarm_l/2-body_thick/2,0])
	difference(){
			cube([body_width,body_thick,body_height],center=true);
		translate([0,0,-body_bottom_thick/2])
			cube([body_width-body_height*tan(angle_tail)*2,body_thick*2,body_height+body_bottom_thick*2],center=true);
	}

	//This is the back trapezuuus
		translate([0,-body_2_backarm_l/2+body_thick])rotate([90,0,0])trapeze(body_width,body_width-body_height*tan(angle_tail)*2,body_height,body_thick);     

	// This is the reinforcements
	difference(){
		translate([0,back_entraxe*1/4+body_thick])rotate([90,0,0])trapeze(body_width,body_width-body_height*tan(angle_tail)*2,body_height,body_thick);
		translate([0,back_entraxe*1/4+body_thick/2,-body_bottom_thick/2])cube([body_width-body_height*tan(angle_tail)*2,body_thick*2,body_height+body_bottom_thick*2],center=true);
	}
	}//End of union

	//Cleaning small edges
	translate([0,0,-body_height/2-body_bottom_thick/2])cube([body_width*1.1,body_2_backarm_l*1.1,body_bottom_thick],center=true);

	translate([0,0,body_height/2+thick/2])cube([body_width*1.1,body_2_backarm_l*1.1,thick],center=true);
	
    for (i=[-1,1]){
        translate([i*back_foot_support_width/2,-back_entraxe/4,-body_height/2])
        cylinder(h=3*body_bottom_thick,r=bolts_radius,center=true);
    }
    }// End of cleaning difference
}

//##############
//#### Part: arm (arm_rotated better positioned)
//#Sub modules: motor_mount, arm_wally, arm_fix
module motor_mount(){
	%translate([0,0,motor_mount_height*2])cylinder(h=thick,r=propeller_radius);
	difference(){
		cylinder(h=motor_mount_height,r=motor_mount_outradius);
		translate([0,0,-thick])
			cylinder(h=motor_mount_height+2*thick,r=motor_mount_radius);
		translate([motor_radius,-motor_3wires_diam/2,thick])
			cube([motor_radius,motor_3wires_diam,motor_mount_height]);
	}
	difference() {
		union() {
		translate([0, 0, thick/2]) {
			rotate([0,0,45]) cube([motor_radius*2+thick*2,motor_hold_width,thick],center = true);
			rotate([0,0,-45]) cube([motor_radius*2+thick*2,motor_hold_width,thick],center = true);
		}
		
		}
		

		for (i=[-1,1]){
			translate([i*motor_screw_separation_small/2*cos(45),-i*motor_screw_separation_small/2*sin(45) , -motor_mount_height/2 ])
				cylinder(h=motor_mount_height, r=motor_screw_radius);
		}


		for (i=[-1,1]){
			translate([i*motor_screw_separation_large/2*cos(45),i*motor_screw_separation_large/2*sin(45) , -motor_mount_height/2 ])
				cylinder(h=motor_mount_height, r=motor_screw_radius);
		}

		translate([0,0, - motor_mount_height/2])
			cylinder(h=motor_mount_height, r=3.5+0.25);
	}
}

//motor_mount();

module arm_wally(height,width,thickness){
	translate([0,0,height/2])
	difference(){
		cube([thickness,width,height],center=true);
		rotate([0,90,0])
			cylinder(h=3*thickness,r=motor_3wires_diam/2,center=true);
	}
}

module arm_fix(height,width,thickness){
	difference(){
		arm_wally(height,width,thickness);
		translate([0,0,height/2])rotate([0,90,0])
		union(){
			translate([0,-arm_fix_entraxe/2,0])
				cylinder(h=3*thickness,r=bolts_radius,center=true);
			translate([0,arm_fix_entraxe/2,0])
				cylinder(h=3*thickness,r=bolts_radius,center=true);
		}
	}
}

//arm(arm_length,60,3);

module arm(arm_length,arm_fix_width,n_wallies,isFootfixed){
arm_angle_h=atan((arm_fix_width-2*motor_mount_outradius)/(2*arm_length));
arm_angle_v=atan((arm_fix_height-motor_mount_height)/arm_length);
	//motor mount
	motor_mount();

	//side walls
	for (i=[-1,1]){
	translate([0,i*motor_mount_radius+(i-1)/2*thick,0]) 
	rotate([0,0,i*arm_angle_h]) 
	rotate([0,-90,-90])
	demitrapeze(motor_mount_height,arm_fix_height,arm_length,thick);
    }
    
	//wallies
	incr=arm_length/(n_wallies+1);
	for ( i=[1:1:n_wallies] ){
		translate([i*incr,0,0])
			arm_wally(motor_mount_height+i*incr*sin(arm_angle_v),2*(motor_mount_outradius+i*incr*sin(arm_angle_h)),thick);
	}

	//floor
	translate([arm_length/2+motor_mount_radius/2,0,0])
	rotate([0,0,-90])
	trapeze(0.5*motor_mount_outradius,0.3*arm_fix_width,arm_length-motor_mount_radius,thick);

	//fixation vers body
	translate([arm_length,0,0])
	arm_fix(arm_fix_height,arm_fix_width,2*thick);
	
	//fixation vers foot
    if(isFootfixed){
	translate([(arm_length)*(1-1/n_wallies)/2,0,0])rotate([0,0,90])
	difference(){
	    trapeze(1.25*(arm_fix_width+motor_radius)/2,1.15*(arm_fix_width+motor_radius)/2,arm_length/2/n_wallies,thick);
        for (i=[-1,1]){
            translate([i*front_foot_support_width/4,0,0])
            cylinder(h=3*thick,r=bolts_radius,center=true);
        }	    
    }
    }
}



module arm_rotated(arm_length,arm_fix_width,n_wallies,isFootfixed){
    rotate([0,0,180])translate([-arm_length-thick,0,0])
    difference(){
        arm(arm_length,arm_fix_width,n_wallies,isFootfixed);
        translate([escspace_d_from_motor+escspace_l/2,0,arm_fix_height/2.3]){
            cube([escspace_l,escspace_w,escspace_h],center=true);
            %ESC();
            //space needed: 75x28x9 (9+2, assuming that bridging may induce 2mm error), the capacitor has a 12.5 diameter
            }
            
    }    
}
//assembly();
//arm_rotated(200,front_arm_fix_width,3);


//##############
//#### Part: feet
//#Sub modules: foot_support

module foot_support(height,width,distance)
{
	dummyAlpha=atan((pow(height,2)-pow(thick,2))/(height*distance - sqrt(pow(distance,2)+pow(height,2)-pow(thick,2))));

	dummyLength = height/sin(dummyAlpha) + thick/tan(dummyAlpha);
	dummyDelta = thick*cos(dummyAlpha);
	translate([0,0,-dummyDelta])rotate([dummyAlpha,0,0])cube([width,dummyLength,thick]);
}

module foot_front()
{
	dummyDiskDistance = front_foot_width - front_foot_thickness;
	dummyLegDistance = (front_foot_support_width - front_foot_D+1.5)/2;
	difference(){
		union(){
		   translate([0,0,-foot_support_height-foot_height-thick])
			{
				// Junction
				translate([-front_foot_thickness/2,-front_foot_support_width/2,foot_height + foot_support_height])cube([front_foot_thickness,front_foot_support_width,thick]);

				// Legs
			
				translate([-front_foot_thickness/2,front_foot_D/2,foot_height])foot_support(foot_support_height,front_foot_thickness,dummyLegDistance);
				rotate([0,0,180])translate([-front_foot_thickness/2,front_foot_D/2,foot_height])foot_support(foot_support_height,front_foot_thickness,dummyLegDistance);
				
				// Foot
				hull()
				{
					translate([0,dummyDiskDistance/2,0])cylinder(h=foot_height,r=front_foot_thickness/2);
					translate([0,-dummyDiskDistance/2,0])cylinder(h=foot_height,r=front_foot_thickness/2);
				}
			}
		}
		union(){
			translate([0,-front_foot_support_width/4,0])cylinder(h=3*thick,r=bolts_radius,center=true);
			translate([0,front_foot_support_width/4,0])cylinder(h=3*thick,r=bolts_radius,center=true);
		}
	}
}

module foot_back()
{
	dummyDiskDistance = back_foot_width - back_foot_thickness;
	difference(){
		union(){
		      translate([0,0,-foot_support_height-foot_height-thick])
			{
				// Junction
				translate([-back_foot_thickness/2,-back_foot_support_width/2,foot_height + foot_support_height])cube([back_foot_thickness,back_foot_support_width,thick]);
				
				// Legs
				translate([-back_foot_thickness/2,back_foot_pos_1,foot_height])foot_support(foot_support_height,back_foot_thickness,back_foot_D_1);
				translate([-back_foot_thickness/2,-back_foot_pos_2,foot_height])foot_support(foot_support_height,back_foot_thickness,back_foot_D_2);
				
				// Foot
				hull()
				{
					translate([0,dummyDiskDistance/2+back_foot_dx,0])cylinder(h=foot_height,r=back_foot_thickness/2);
					translate([0,-dummyDiskDistance/2+back_foot_dx,0])cylinder(h=foot_height,r=back_foot_thickness/2);
				}
			}
		}
		union(){
			cylinder(h=3*thick,r=bolts_radius,center=true);
		}
	}
}

module back_feet(){
	rotate([0,0,180])
	    translate([0,-back_foot_support_width/2,0])foot_back();
	translate([0,-back_foot_support_width/2,0])foot_back();
}


//foot_front();
//back_feet();

//#################
//#### Additional parts
module ESC(){
color("red"){
translate([0,0,0*7/2])cube([59,26,7],center=true);//measured on 17-02-2014
translate([22,0,0*7/2])rotate([90,0,0])cylinder(h=22,r=12.5/2,center=true);
//space needed: 75x28x9 (9+2, assuming that bridging may induce 2mm error), the capacitor has a 12.5 diameter
}
}
//ESC();
module battery_big(){
color("lightblue")
cube([49,150,26],center=true);
}

module battery_small(){
color("grey")
cube([44,134,17],center=true);
}
//battery_small();

module DroFly(){
color("yellow")
cube([50,50,25],center=true);
}
//DroFly();

//#################
//#### Handy tools

module demitrapeze(base,top,height,thick){
	linear_extrude(height=thick)
		polygon(points=[[0,0],[base,0],[top,height],[0,height]],paths=[ [0,1,2,3] ]);
}

module trapeze(base,top,height,thick){
     linear_extrude(height=thick)
     polygon(points=[[base/2,-height/2],[-base/2,-height/2],[-top/2,height/2],[top/2,height/2]],paths=[ [0,1,2,3] ]);
}
