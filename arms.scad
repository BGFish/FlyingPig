//###############
//#### Part: arm
//#Sub modules: motor_mount, sidewall,renfort, arm



use <tools.scad>
include <parameters.scad>


module arm(arm_l=150,shoulder_w=50,shoulder_h=50){

	arm_a=atan((shoulder_w-wrist_w)/(2*arm_l));

	//motor mount
	module motor_mount(){
		%translate([0,0,45+0*wrist_h*2])cylinder(h=10,r=propeller_r);

		difference(){
			rotate_extrude(convexity=10)
			translate([wrist_w/2,0,0])
			projection()
			rotate([0,90,90])
				softangle(1,arm_t,2*arm_t,arm_t,wrist_h,arm_t);
			translate([motor_r/2,-wire_hole_d/2,arm_t])
				cube([motor_r,wire_hole_d,wrist_h]);
		}

		translate([0,0,arm_t/2])
			3holeplank(2*motor_mount_r,wire_hole_d,arm_t,motor_hole_d,2*motor_screw_r,motor_s_large);

		rotate([0,0,90])translate([0,0,arm_t/2])
			3holeplank(2*motor_mount_r,wire_hole_d,arm_t,motor_hole_d,2*motor_screw_r,motor_s_small);

	}


	//side walls
	module sidewall(){
		softangle(arm_l,arm_t,2*arm_t,arm_t,wrist_h,2*arm_t);
		translate([arm_l,0,0])
		rotate([0,0,90])
			softangle(arm_t,wrist_h,arm_l,wrist_h,shoulder_h,shoulder_h-wrist_h);
	}

	//reinforcements
	module renfort(side1,side2){
		rotate([0,0,90])
		difference(){
				trapeze(side2,side1,renfort_w,wrist_h);
			translate([0,0,wrist_h+2*arm_t])
			rotate([90,0,0])
				cylinder(r=wrist_h,h=1.2*renfort_w,center=true);
		}
	}


	difference(){
		union(){
			//side walls
			translate([0,-wrist_w/2,0])
			rotate([0,0,-arm_a]) 
				sidewall();
			mirror([0,1,0])
			translate([0,-wrist_w/2,0])
			rotate([0,0,-arm_a])
				sidewall();
			//floor
			translate([arm_l/2,0,0])
			rotate([0,0,-90])
				trapeze(wrist_w,shoulder_w,arm_l,arm_t);
		}
		cylinder(h=2*wrist_h,r=wrist_w/2,center=true);
	}


	//motor mount
	motor_mount();


	//renforts
	incr=arm_l/(n_renforts+1);
	for ( i=[1:n_renforts] ){
		assign(
					side1=wrist_w+2*(i*incr-renfort_w/2)*sin(arm_a),
					side2=wrist_w+2*(i*incr+renfort_w/2)*sin(arm_a)
				)
		translate([i*incr,0,0])
			renfort(side1,side2);
	}


	//fixation vers body
	translate([arm_l,0,shoulder_h/2])
	rotate([90,0,90])
	3holeplank(shoulder_w,shoulder_h,2*arm_t, wire_hole_d,2*bolt_r,shoulder_s );


}

arm();

