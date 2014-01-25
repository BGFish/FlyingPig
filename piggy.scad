//import("scorpion/Front_Body.stl");
//import("scorpion/Front_Legs.stl");
//import("scorpion/Front_Top.stl");
//import("scorpion/Rear_Body.stl");

inch=25.4;

thick=2;
jeu=2;

bolts_radius=3/2;//M3

propeller_radius=9*inch/2;
body_length=300;
body_width=55;
body_height=16;
angle_front=120;
angle_tail=30;

motor_radius=28/2;
motor_mount_radius=motor_radius+jeu/2;
motor_mount_height=16; // dimension D
motor_3wires_diam=10;
motor_wire_length=115;

motor_frontarm_length=propeller_radius*2;
motor_backarm_length=propeller_radius*1.3;
motor_arm_add=30;
//motor_arm_add_front=body_width/2/cos(30)-motor_mount_radius*tan(30);
//motor_arm_add_back=body_width/2/cos(30);

motor_arm_height=motor_mount_height;

nw_front=5;
nw_back=3;

leg_width = 10;
leg_length = 10;
leg_height = 55;

battery_pos=-100;
drofly_pos=-210;

//##############
//#### Part: motor_arm
//#Sub modules: motor_mount, moto_arm_fix
module motor_mount(){
//%translate([-79,-16.5,-25])import("scorpion/Rear_Motor_Mounts.stl");
	%translate([0,0,motor_mount_height*2])cylinder(h=thick,r=propeller_radius);
	difference(){
		cylinder(h=motor_mount_height,r=motor_mount_radius+thick);
		translate([0,0,thick])
			cylinder(h=motor_mount_height,r=motor_mount_radius);
		translate([motor_radius,-motor_3wires_diam/2,thick])
			cube([motor_radius,motor_3wires_diam,motor_mount_height]);
	}
}

//motor_mount();

module motor_arm_fix(){
	difference(){
		translate([0,-motor_mount_radius,0])cube([thick,2*motor_mount_radius,motor_mount_height]);
		translate([0,0,motor_mount_height/2])rotate([0,90,0])
		union(){
			translate([0,-1.5*motor_mount_radius/2,0])cylinder(h=3*thick,r=bolts_radius,center=true);
			translate([0,1.5*motor_mount_radius/2,0])cylinder(h=3*thick,r=bolts_radius,center=true);
			cylinder(h=3*thick,r=motor_3wires_diam/2,center=true);
		}
	}
}

module motor_arm_wally(){
	difference(){
		translate([0,-motor_mount_radius,0])cube([thick,2*motor_mount_radius,motor_mount_height]);
		translate([0,0,motor_mount_height/2])rotate([0,90,0])
		union(){
			cylinder(h=3*thick,r=motor_3wires_diam/2,center=true);
		}
	}
}

module motor_arm(motor_arm_length,n_wallies){
	translate([motor_arm_length,0,0])mirror([1,0,0])
		motor_mount();
	translate([0,motor_mount_radius,0])
		cube([motor_arm_length,thick,motor_arm_height]);
	translate([0,-thick-motor_mount_radius,0])
		cube([motor_arm_length,thick,motor_arm_height]);
	
	motor_arm_fix();

	translate([motor_arm_length-motor_wire_length,0,motor_arm_height/2])
		ESC();

	incr=motor_arm_length/n_wallies;
	I=incr*(n_wallies-1);
	for ( i=[incr:incr:I] ){
		translate([i,0,0])
			motor_arm_wally();

	// essai
	translate([i-incr,-motor_mount_radius,0])
	rotate([0,0,(360/3.14)*motor_mount_radius/i])
		cube([incr*1.1,thick,motor_arm_height/4]);
	translate([i-incr,motor_mount_radius,0])
	rotate([0,0,-(360/3.14)*motor_mount_radius/i])
		cube([incr*1.1,thick,motor_arm_height/4]);
	}

	translate([0,-motor_mount_radius,0])
	rotate([0,0,(360/3.14)*motor_mount_radius/motor_arm_length])
		cube([motor_arm_length,thick,motor_arm_height/4]);
	translate([0,motor_mount_radius,0])
	rotate([0,0,-(360/3.14)*motor_mount_radius/motor_arm_length])
		cube([motor_arm_length,thick,motor_arm_height/4]);
}

//motor_arm(motor_frontarm_length,5);

//##############
//#### Part: body
module body(){
//translate([0,-body_length/2,0])scale([0.3,1,0.1])sphere(r=body_length/2);
	translate([-body_width/2,-body_length/2,body_height/2])
		cube([thick,body_length,body_height],center=true);
	translate([body_width/2,-body_length/2,body_height/2])
		cube([thick,body_length,body_height],center=true);
	translate([0,-body_length/2,0])legs();

// body_arm_join() positioning
	rotate([0,0,(180-angle_front)/2])
		body_arm_join();
	mirror([1,0,0])rotate([0,0,(180-angle_front)/2])
		body_arm_join();
	translate([0,-body_length,0]){
		rotate([0,-angle_tail,0])
			body_arm_join();
		mirror([1,0,0])rotate([0,-angle_tail,0])
			body_arm_join();
	}
}

module body_arm_join(){
translate([motor_arm_add-thick,0,0])
	motor_arm_fix();
}

//body();

module legs(){
color("orange")
translate([body_width/2,-body_length/4,-body_height])
cube([leg_width,leg_length,leg_height],center=true);

color("orange")
translate([-body_width/2,-body_length/4,-body_height])
cube([leg_width,leg_length,leg_height],center=true);

color("orange")
translate([body_width/2,body_length/2,-body_height])
cube([leg_width,leg_length,leg_height],center=true);

color("orange")
translate([-body_width/2,body_length/2,-body_height])
cube([leg_width,leg_length,leg_height],center=true);
}

//##############
//##### Assembly
module assembly(){
	rotate([0,0,(180-angle_front)/2])
	translate([motor_arm_add,0,0])
		motor_arm(motor_frontarm_length,nw_front);
	mirror([1,0,0])rotate([0,0,(180-angle_front)/2])
		translate([motor_arm_add,0,0])
		motor_arm(motor_frontarm_length,nw_front);
	translate([0,-body_length,0]){
		rotate([0,-angle_tail,0])
		translate([motor_arm_add,0,0])
			motor_arm(motor_backarm_length,nw_back);
		mirror([1,0,0])rotate([0,-angle_tail,0])
			translate([motor_arm_add,0,0])
			motor_arm(motor_backarm_length,nw_back);
}
	body();
	translate([0,battery_pos,0])battery_big();
	translate([0,drofly_pos,0])DroFly();
}

assembly();

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




