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
motor_wire_length=50;

motor_frontarm_length=propeller_radius*2;
motor_backarm_length=propeller_radius*1.3;
motor_arm_add=20;
motor_arm_height=motor_mount_height;

battery_pos=-100;
drofly_pos=-210;

//motor_mount();

module motor_arm(motor_arm_length){
	translate([motor_arm_length,0,0])mirror([1,0,0])
		motor_mount();
	translate([0,motor_mount_radius,0])cube([motor_arm_length,thick,motor_arm_height]);
	translate([0,-thick-motor_mount_radius,0])cube([motor_arm_length,thick,motor_arm_height]);
	difference(){
		translate([0,-motor_mount_radius,0])cube([thick,2*motor_mount_radius,motor_mount_height]);
		translate([0,0,motor_mount_height/2])rotate([0,90,0])
		union(){
			translate([0,-1.5*motor_mount_radius/2,0])cylinder(h=3*thick,r=bolts_radius,center=true);
			translate([0,1.5*motor_mount_radius/2,0])cylinder(h=3*thick,r=bolts_radius,center=true);
			cylinder(h=3*thick,r=motor_3wires_diam/2,center=true);
		}
	}

	translate([motor_wire_length,0,motor_arm_height/2]);

}

module motor_mount(){
	difference(){
		cylinder(h=motor_mount_height,r=motor_mount_radius+thick);
		translate([0,0,thick])cylinder(h=motor_mount_height,r=motor_mount_radius);
		translate([motor_radius,-motor_3wires_diam/2,thick])cube([motor_radius,motor_3wires_diam,motor_mount_height]);
	}
}

// Front foot variables
foot_support_height = 30;
foot_height = 5;

front_foot_thickness = 15;
front_foot_support_width = 2*(motor_mount_radius + thick);
front_foot_width = 0.75*front_foot_support_width;
front_foot_D = 10;	// Distance between the supports

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
					translate([0,dummyDiskDistance/2,0])cylinder(h=foot_height,r=front_foot_thickness/2,$fn=60);
					translate([0,-dummyDiskDistance/2,0])cylinder(h=foot_height,r=front_foot_thickness/2,$fn=60);
				}
			}
		}
		union(){
			translate([0,-front_foot_support_width/4,0])cylinder(h=3*thick,r=bolts_radius,center=true,$fn=60);
			translate([0,front_foot_support_width/4,0])cylinder(h=3*thick,r=bolts_radius,center=true,$fn=60);
		}
	}
}

// Back foot variables
back_foot_thickness = 15;
back_foot_support_width = body_width/2;
back_foot_width = 1.2*back_foot_support_width;
back_foot_D_1 = 16;	// Distance between the supports
back_foot_D_2 = 7.1;	// Distance between the supports
back_foot_pos_1 = -2;	// Distance between the supports
back_foot_pos_2 = 18;	// Distance between the supports
back_foot_dx = -11;

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
					translate([0,dummyDiskDistance/2+back_foot_dx,0])cylinder(h=foot_height,r=back_foot_thickness/2,$fn=60);
					translate([0,-dummyDiskDistance/2+back_foot_dx,0])cylinder(h=foot_height,r=back_foot_thickness/2,$fn=60);
				}
			}
		}
		union(){
			cylinder(h=3*thick,r=bolts_radius,center=true,$fn=60);
		}
	}
}

translate([20,0,0])
{
	foot_front();
}


translate([-50,0,0])
{
	mirror([0,1,0])translate([0,-back_foot_support_width/2,0])foot_back();
	translate([0,-back_foot_support_width/2,0])foot_back();
}

motor_arm(100);
