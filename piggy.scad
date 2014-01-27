//translate([0,0,-100])import("scorpion/Final_V_tail_Complete.stl");
//import("scorpion/Front_Body.stl");
//import("scorpion/Front_Legs.stl");
//import("scorpion/Front_Top.stl");
//import("scorpion/Rear_Body.stl");
$fn=40;

inch=25.4;

thick=2;
jeu=2;

bolts_radius=3/2;//M3

propeller_radius=9*inch/2;
body_length=290;
body_width=60;
body_height=30;

angle_front=120;
angle_tail=30;

motor_frontarm_length=propeller_radius*1.5;//*2
motor_backarm_length=propeller_radius*1.3;
motor_arm_add=30;

motor_radius=28/2;
motor_mount_radius=motor_radius+jeu/2;
motor_mount_height=16; // dimension D
motor_3wires_diam=10;
motor_wire_length=115;

motor_arm_height=motor_mount_height;

nw_front=4;
nw_back=3;

leg_width = 10;
leg_length = 10;
leg_height = 55;

battery_pos=-100;
drofly_pos=-210;

electronic_size=50;//DroFly: 50mmx50mm
elec_offset=20;

body_front_length=170;
body_back_length=body_length-body_front_length;


front_arm_fix_width=50;// to be asked to baptiste to puzzle him, then claude, than the black
back_arm_fix_width=front_arm_fix_width;//back_entraxe*3/2;

body_back_arm_fix_height=body_height*cos(30);

//Gab variables
motor_mount_outradius=motor_mount_radius+thick;
arm_length=150;
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


//##############
//##### Assembly,
//sub-parts: 4*arm_mirrored,body_back,body_front
// body:preassembly of body_back and body_front
module assembly(){

	//Front arms
	rotate([0,0,(180-angle_front)/2])
	translate([motor_arm_add-thick,thick*5,0]){
		arm_mirrored(motor_frontarm_length,front_arm_fix_width,nw_front);
		translate([motor_frontarm_length*0.5,0,0])foot_front();
	}
		
	mirror([1,0,0])rotate([0,0,(180-angle_front)/2])
		translate([motor_arm_add-thick,thick*5,0]){
			arm_mirrored(motor_frontarm_length,front_arm_fix_width,nw_front);
			translate([motor_frontarm_length*0.5,0,0])foot_front();
		}
		
	//Back arms
	translate([0,-body_length,0]){
		rotate([0,-angle_tail,0])
		translate([motor_arm_add,0,-thick*8])
			arm_mirrored(motor_backarm_length,back_arm_fix_width,nw_back);
		mirror([1,0,0])rotate([0,-angle_tail,0])
			translate([motor_arm_add,0,-thick*8])
			arm_mirrored(motor_backarm_length,back_arm_fix_width,nw_back);
			rotate([0,0,90])back_feet();
}
	body();
	//translate([0,battery_pos,0])battery_big();
	//translate([0,drofly_pos,0])DroFly();
}

rotate([0,0,90])assembly();

module body(){
	body_front();
	translate([0,-body_front_length-body_back_length/2,body_height/2])body_back();
}


//##############
//#### Part: body_front

///////////////
module body_2_frontarms(){
	trapeze(body_width,body_width-front_arm_fix_width*sin(30)*2,front_arm_fix_width*cos(30),thick);

	difference(){
		trapeze(body_width,body_width-front_arm_fix_width*sin(30)*2,front_arm_fix_width*cos(30),body_height);

		translate([0,-thick,thick])trapeze(body_width-thick*2,body_width-front_arm_fix_width*sin(30)*2-thick*2,front_arm_fix_width*cos(30),body_height
);
	for(side=[-1,1]){
		translate([side*((body_width+body_width-front_arm_fix_width*sin(30)*2)/4-thick*0.8),0,body_height/2])rotate([0,0,side*30]){
			for(i=[-1,1]){
				translate([0,i*front_entraxe/2,0])
				rotate([0,90,0])
					cylinder(h=2*thick,r=bolts_radius,center=true);
			}
			rotate([0,90,0])
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
			translate([i*3*body_width/8,0,0])rotate([90,0,0])cylinder(h=100*thick,r=bolts_radius);
		}
	}

	translate([0,-body_length*0.3,17+2*thick])
		battery_big();

    for(i=[-1:1]){for(j=[1:3]){
        translate([i*body_width/3,-j*body_front_length/4,0])cylinder(h=3.5*thick,r=thick);
    }}

	translate([0,(front_arm_fix_width*cos(30))/2,0])body_2_frontarms();
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
			translate([i*3*body_width/8,0,0])rotate([-90,0,0])cylinder(h=100*thick,r=bolts_radius);
		}
	}
		translate([0,elec_offset,0])
			DroFly();

// back arms fix
				translate([0,-body_back_length/2+thick,body_back_arm_fix_height/2-body_height/2])
					body_2_backarms(body_back_arm_fix_height);
			

}

module body_2_backarms_p1(body_height){
translate([-body_height*tan(30)/2,0,0]){
rotate([0,-30,0])
	difference(){
		cube([thick,back_entraxe*3/2,body_height/cos(30)],center=true);
		for(i=[-1,1]){
			translate([0,i*back_entraxe/2,0])
			rotate([0,90,0])
				cylinder(h=2*thick,r=bolts_radius,center=true);
		}
		rotate([0,90,0])
			cylinder(h=2*thick,r=motor_3wires_diam/2,center=true);
		}

	//cube([body_height*tan(30),back_entraxe*3/2,thick],center=true);
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
			cube([body_width-body_height*tan(30)*2,thick*2,body_height+thick*2],center=true);
	}

	//This is the back trapezuuus
		translate([0,-back_entraxe*3/4+thick])rotate([90,0,0])trapeze(body_width,body_width-body_height*tan(30)*2,body_height,thick);     

	// This is the reinforcements
	difference(){
		translate([0,back_entraxe*1/4+thick])rotate([90,0,0])trapeze(body_width,body_width-body_height*tan(30)*2,body_height,thick);
		translate([0,back_entraxe*1/4+thick/2,-thick/2])cube([body_width-body_height*tan(30)*2,thick*2,body_height+thick*2],center=true);
	}
	}//End of union

	//Cleaning small edges
	translate([0,0,-body_height/2-thick/2])cube([body_width*1.1,back_entraxe*3/2*1.1,thick],center=true);

	translate([0,0,body_height/2+thick/2])cube([body_width*1.1,back_entraxe*3/2*1.1,thick],center=true);
	}// End of cleaning difference

}

//body_back();
//body();

//##############
//#### Part: arm (arm_mirrored better positioned)
//#Sub modules: motor_mount, arm_wally, arm_fix
module motor_mount(){
	%translate([0,0,motor_mount_height*2])cylinder(h=thick,r=propeller_radius);
	difference(){
		cylinder(h=motor_mount_height,r=motor_mount_outradius);
		translate([0,0,thick])
			cylinder(h=motor_mount_height,r=motor_mount_radius);
		translate([motor_radius,-motor_3wires_diam/2,thick])
			cube([motor_radius,motor_3wires_diam,motor_mount_height]);
	}
}

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

module arm(arm_length,arm_fix_width,n_wallies){
arm_angle_h=atan((arm_fix_width-2*motor_mount_outradius)/(2*arm_length));
arm_angle_v=atan((arm_fix_height-motor_mount_height)/arm_length);
	//motor mount
	motor_mount();

	//side walls
	translate([0,motor_mount_radius,0]) 
	rotate([0,0,arm_angle_h]) 
	rotate([0,-90,-90])
	demitrapeze(motor_mount_height,arm_fix_height,arm_length,thick);

	translate([0,-motor_mount_radius-thick,0]) 
	rotate([0,0,-arm_angle_h])
	rotate([0,-90,-90])
	demitrapeze(motor_mount_height,arm_fix_height,arm_length,thick);

	//wallies
	incr=arm_length/(n_wallies+1);
	for ( i=[1:1:n_wallies] ){
		translate([i*incr,0,0])
			arm_wally(motor_mount_height+i*incr*sin(arm_angle_v),2*(motor_mount_outradius+i*incr*sin(arm_angle_h)),thick);
	}

	//floor
	translate([arm_length/2,0,0])
	rotate([0,0,-90])
	trapeze(0.5*motor_mount_outradius,0.3*arm_fix_width,arm_length,thick);

	//fixation
	translate([arm_length,0,0])
	arm_fix(arm_fix_height,arm_fix_width,2*thick);
}

module arm_mirrored(arm_length,arm_fix_width,n_wallies){
    mirror([1,0,0])translate([-arm_length-thick,0,0])arm(arm_length,arm_fix_width,n_wallies);
}

//arm_mirrored(arm_length,front_arm_fix_width,3);


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
				mirror([0,-1,0])translate([-front_foot_thickness/2,front_foot_D/2,foot_height])foot_support(foot_support_height,front_foot_thickness,dummyLegDistance);
				
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
	mirror([0,1,0])translate([0,-back_foot_support_width/2,0])foot_back();
	translate([0,-back_foot_support_width/2,0])foot_back();
}


//foot_front();

//back_feet();

//motor_arm(100);



//#################
//#### Additional parts
module ESC(){
color("red")
//cube([33,23,6],center=true); //flyduino
translate([0,0,7/2])cube([36,26,7],center=true);	//grotek
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
