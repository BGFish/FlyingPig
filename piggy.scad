$fn=40;

inch=25.4;
thick=2;
bolts_radius=3/2;//M3

propeller_radius=9*inch/2;
body_length=290;
body_width=60;
body_height=33;

angle_front=30;//angle between front arm and Left-Right axis
angle_tail=30;//angle between back arm and horizontal

frontarm_length=propeller_radius*1.6;
backarm_length=propeller_radius*1.3;

motor_radius=28/2;
jeu=2;
motor_mount_radius=motor_radius+jeu/2;
motor_mount_height=16; // dimension D
motor_3wires_diam=12;
motor_screw_radius=3/2; // M3 From http://www.hobbyking.com/hobbyking/store/__36408__Turnigy_Aerodrive_SK3_2830_1020kv_Brushless_Outrunner_Motor_EU_warehouse_.html
motor_screw_separation_small = 16; // Much more complicated than expected
motor_screw_separation_large = 19; // Much more complicated than expected
motor_hold_width=10;

nw_front=3;// number of wallies for front arm
nw_back=2;

electronic_size=50;//DroFly: 50mmx50mm
elec_offset=20;

body_front_length=170;
body_back_length=body_length-body_front_length;

front_arm_fix_width=52;// width used to fix the front arms
back_arm_fix_width=front_arm_fix_width;

body_back_arm_fix_height=body_height*cos(angle_tail);

serre_hole1=3;// serre-cable holes dimensions
serre_hole2=6;

capot_width=40;
cap_tot_width=130;
cap_mid_width=cap_tot_width-2*capot_width;
cap_height=body_height/2;

//for capot2_thicker
capot_top=6;//capot top thickness
capot_inside=3;
capot_outside=3;

//Gab variables
motor_mount_outradius=motor_mount_radius+thick;
arm_fix_height=body_height;
arm_fix_entraxe=40;
back_entraxe=arm_fix_entraxe;
front_entraxe=arm_fix_entraxe;

//Thiago & Jeff variables
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

// Generate STLs

//Back of body
//body_back();

//Front of body
//body_front();

//Back feet
//rotate([0, 90, 0]) back_feet();

//Back arms
//arm_rotated(backarm_length,back_arm_fix_width,nw_back,false);

//Front arms
//arm_rotated(frontarm_length,front_arm_fix_width,nw_front,true);

//Front feet
//rotate([0, 90, 0]) foot_front();

//Capot2
//rotate([0,180,0])capot2_thicker();
//rotate([0,180,0])capot3();


// Generate GIF of assembled drone.
//rotate([0, 0, $t*360]) translate([0, body_length*0.33, 0]) assembly();


//##############
//##### Assembly,
//sub-parts: 4*arm_rotated,body_back,body_front
// body:preassembly of body_back and body_front
module assembly(){
	//Front arms
	front_armAndFoot_positioned(isRight=1);// front-right arm
    front_armAndFoot_positioned(isRight=-1);	//front-left arm
	//Back arms
	back_arm_positioned(isRight=1);
	back_arm_positioned(isRight=-1);

	translate([0,-body_length,0])
		rotate([0,0,90])back_feet();
	body();
	
	//translate([0,0,body_height+thick/2+1])capot();

	//translate([0,-capot_width,body_height/2+2*thick]) capot2_thicker();
	//translate([0,-body_front_length+capot_width,body_height/2+2*thick]) capot2_thicker();
	translate([0,-2*capot_width,body_height/2+2*thick+2*capot_top]) capot3();

}

assembly();



module body(){
	body_front();
	translate([0,-body_front_length-body_back_length/2,body_height/2])body_back();
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
    translate([isRight*body_width/2,-body_length+thick,0])
	rotate([0,-angle_tail,90*(isRight-1)]){
		arm_rotated(backarm_length,back_arm_fix_width,nw_back,false);
		//%translate([1.0*backarm_length/nw_back,0,0])ESC();
	}
}
//##############
//#### Part: body_front

///////////////
module body_2_frontarms(){// body to front_arms junction
	difference(){
		trapeze(body_width,body_width-front_arm_fix_width*sin(angle_front)*2,front_arm_fix_width*cos(angle_front),body_height);

		translate([0,-thick,thick])trapeze(body_width-thick*2,body_width-front_arm_fix_width*sin(angle_front)*2-thick*2,front_arm_fix_width*cos(angle_front),body_height
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

module body_front(){ //battery
	translate([0,-body_front_length/2,body_height/2])
	difference(){
		cube([body_width,body_front_length,body_height],center=true);
		translate([0,thick,thick])cube([body_width-2*thick,body_front_length,body_height],center=true);
		translate([0,-2*thick,thick])cube([body_width/2,body_front_length,body_height],center=true);
		for(i=[-1,1]){
			for(j=[-1,1]){
			translate([i*3*body_width/8,-body_back_length/2,j*body_height/8*2])rotate([90,0,0])cylinder(h=20*thick,r=bolts_radius);
			}
		}
		for(i=[-1,1]){for(j=[-2:2]){
			translate([i*(body_width/2-thick-serre_hole1/2),j*body_front_length/5,-body_height/2])cube([serre_hole1,serre_hole2,4*thick],center=true);
		}}
	}

	translate([0,-body_length*0.3,26/2+2*thick])
		%battery_big();

    for(i=[-1:1]){for(j=[1:3]){
        translate([i*body_width/3,-j*body_front_length/4,0])cylinder(h=3.5*thick,r=thick);
    }}

	translate([0,(front_arm_fix_width*cos(angle_front))/2,0])body_2_frontarms();
}
//body_front();

//##############
//#### Part: body_back

module body_back(){  //electronics
	difference(){
			union(){
				cube([body_width,body_back_length,body_height],center=true);
				translate([0,elec_offset,0])
				cylinder(h=body_height,r=electronic_size*1.4/2+2*thick
					,center=true);
				}
			translate([0,0,thick]){
				translate([0,elec_offset,0])
				cylinder(h=body_height,r=electronic_size*1.42/2,center=true);
				cube([body_width-2*thick,body_back_length-2*thick,body_height],center=true);
			translate([0,-body_back_length/2+thick,0])
				cube([body_width+thick*2,back_entraxe*3/2,body_height],center=true);
			}
			translate([0,elec_offset,0])
			for (i=[-1,1]) for(j=[-1,1]){
				translate([i*45/2,j*45/2,-body_height/2])cylinder(h=3*thick,r=bolts_radius,center=true);
			}

		translate([0,2*thick,thick])cube([body_width/2,body_back_length,body_height],center=true);
		for(i=[-1,1]){
			for(j=[-1,1]){
			translate([i*3*body_width/8,body_front_length/2,j*body_height/8*2])rotate([90,0,0])cylinder(h=20*thick,r=bolts_radius);
			}
		}


	}
		translate([0,elec_offset,0])
			%DroFly();

// back arms fix
				translate([0,-body_back_length/2+thick,body_back_arm_fix_height/2-body_height/2])
					body_2_backarms(body_back_arm_fix_height);
			

}

module body_2_backarms_p1(body_height){
translate([-body_height*tan(angle_tail)/2,0,0]){
rotate([0,-angle_tail,0])
	difference(){
		cube([thick,back_entraxe*3/2,body_height/cos(angle_tail)],center=true);
		for(i=[-1,1]){
			translate([0,i*back_entraxe/2,0])
			rotate([0,90,0])
				cylinder(h=2*thick,r=bolts_radius,center=true);
		}
		rotate([0,90,0])
			cylinder(h=2*thick,r=motor_3wires_diam/2,center=true);
		}

	//cube([body_height*tan(angle_tail),back_entraxe*3/2,thick],center=true);
}
}

module body_2_backarms(body_height){

difference(){

	union(){
	translate([body_width/2,0,0])
	body_2_backarms_p1(body_height);
	translate([-body_width/2,0,0])rotate([0,0,180])body_2_backarms_p1(body_height);

	//This is the bottom plate
	translate([0,0,-body_height/2+thick/2])cube([body_width,back_entraxe*3/2,thick],center=true);

	//This is the front rectangles
	difference(){
		translate([0,back_entraxe*3/4,0])
			cube([body_width,thick,body_height],center=true);
		translate([0,back_entraxe*3/4,-thick/2])
			cube([body_width-body_height*tan(angle_tail)*2,thick*2,body_height+thick*2],center=true);
	}

	//This is the back trapezuuus
		translate([0,-back_entraxe*3/4+thick])rotate([90,0,0])trapeze(body_width,body_width-body_height*tan(angle_tail)*2,body_height,thick);     

	// This is the reinforcements
	difference(){
		translate([0,back_entraxe*1/4+thick])rotate([90,0,0])trapeze(body_width,body_width-body_height*tan(angle_tail)*2,body_height,thick);
		translate([0,back_entraxe*1/4+thick/2,-thick/2])cube([body_width-body_height*tan(angle_tail)*2,thick*2,body_height+thick*2],center=true);
	}
	}//End of union

	//Cleaning small edges
	translate([0,0,-body_height/2-thick/2])cube([body_width*1.1,back_entraxe*3/2*1.1,thick],center=true);

	translate([0,0,body_height/2+thick/2])cube([body_width*1.1,back_entraxe*3/2*1.1,thick],center=true);
	
    for (i=[-1,1]){
        translate([i*back_foot_support_width/2,-back_entraxe/4,-body_height/2])
        cylinder(h=3*thick,r=bolts_radius,center=true);
    }
    }// End of cleaning difference

}

//body_back();
//body();

//##############
//#### Part: arm (arm_rotated better positioned)
//#Sub modules: motor_mount, arm_wally, arm_fix
module motor_mount(){
	//%translate([0,0,motor_mount_height*2])cylinder(h=thick,r=propeller_radius);
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

//motor_arm(100);


//Capot
add_capot=6;
reach_walls=1.06;
module capot(){
    translate([0,-(body_length-back_arm_fix_width/2)/2+add_capot/2,0])
        //difference() {
        	cube([body_width,body_length-back_arm_fix_width/2-add_capot,thick],center=true);
        	//translate([(body_width/2-thick/2),-thick + (body_length-back_arm_fix_width/2-add_capot)/2, -thick/2]) cylinder(h=thick*2,r=1,center=true);
        //}
    translate([0,-body_length+body_back_length/2+elec_offset,0])
    	difference() {
        	cylinder(h=thick,r=electronic_size*1.42/2+2*thick,center=true);
        	for(i=[-1,1]) {
        		for(j=[-1,1]) {
        			translate([i*electronic_size*1.42/2*cos(30)*reach_walls, j*electronic_size*1.42/2*sin(30)*reach_walls, -thick/2]) cylinder(h=thick*2,r=1,center=true);
        		}
        	}
    	}
    translate([0,front_arm_fix_width*cos(angle_front)/2-1,-thick/2])
        trapeze(body_width,body_width-(2-0.2)*front_arm_fix_width*sin(angle_front),front_arm_fix_width*cos(angle_front),thick);
}
//%translate([0,0,body_height+thick/2+1])capot();





module capot2(){
	difference(){
		cube([body_width+2*thick,capot_width,body_height],center=true);

		translate([0,0,-1.5*thick])
		cube([body_width-4*thick,1.3*capot_width,body_height],center=true);

		translate([(-body_width+thick)/2,0,-1.5*thick])
		cube([thick,1.3*capot_width,body_height],center=true);

		translate([(body_width-thick)/2,0,-1.5*thick])
		cube([thick,1.3*capot_width,body_height],center=true);

		translate([0,0,-body_height/2])
		cube([body_width,1.3*capot_width,body_height],center=true);
	}
}

//capot2();



module capot2_thicker(){
	difference(){
		cube([body_width+2*capot_outside,capot_width,body_height],center=true);

		translate([0,0,-capot_top])
		cube([body_width-2*thick-2*capot_inside,1.3*capot_width,body_height],center=true);

		translate([(-body_width+thick)/2,0,-capot_top])
		cube([thick,1.3*capot_width,body_height],center=true);

		translate([(body_width-thick)/2,0,-capot_top])
		cube([thick,1.3*capot_width,body_height],center=true);

		//translate([0,0,-body_height/2])
		//cube([body_width,1.3*capot_width,body_height],center=true);
	}
}

module capot3(){
	difference(){
		cube([body_width+2*capot_outside,cap_tot_width,cap_height],center=true);

		translate([0,0,-capot_top])
		cube([body_width-2*thick-2*capot_inside,1.3*cap_tot_width,cap_height],center=true);

		translate([body_width/2,0,+capot_top])
		cube([body_width,cap_mid_width,cap_height],center=true);

		translate([(-body_width+thick)/2,0,-capot_top])
		cube([thick,1.3*cap_tot_width,cap_height],center=true);

		translate([(body_width-thick)/2,0,-capot_top])
		cube([thick,1.3*cap_tot_width,cap_height],center=true);
	}
}
//capot3();

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
