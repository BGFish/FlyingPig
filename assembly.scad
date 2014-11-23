//##############
//#### Assembly
$fn=30;

use <tools.scad>
use <body.scad>
use <arms.scad>
use <legs.scad>
include <parameters.scad>


//TODO : add holes to fix leg to arm


//variables defined here override those defined in parameters





module drone(){
	//body
	body();

	//front arms+legs
	for(i=[-1,1]){
		difference() {
					translate([-i*(body_w-front_shoulder_w*sin(front_a))/2,0,0])
					rotate([0,0,-90+i*(90-front_a)])
						union(){
							translate([-front_arm_l-side_t/2,0,0])
								arm(arm_l=front_arm_l,shoulder_w=front_shoulder_w,shoulder_h=body_h);
							translate([-front_arm_l/2,0,-hag])
								front_leg(hag=hag,ankle_w=ankle_w,hip_w=hip_w,leg_t=leg_t,leg_w=leg_w);
						}

					//Holes for the serre fil to hold feet (shitty implementation)
					translate([-i*(body_w-front_shoulder_w*sin(front_a))/2,0,0]){
						translate([i*(-front_arm_l/2+hip_w/10)*cos(front_a),front_shoulder_w*sin(front_a),floor_t])
						rotate([90, 90, -90+i*(90-front_a)])
						//translate([-front_arm_l/2+hip_w/5,front_shoulder_w,arm_t])
						cube([serre_w,serre_l,20*floor_t],center=true);

						translate([i*(-front_arm_l/2-6*hip_w/10)*cos(front_a),front_shoulder_w*sin(front_a),floor_t])
						rotate([90, 90, -90+i*(90-front_a)])
						cube([serre_w,serre_l,20*floor_t],center=true);
					}

				}

	}



	//back arms+legs
	translate([0,-body_centre_l-front_shoulder_w*cos(front_a)/2-back_shoulder_w/2,0]) {
	
	for(i=[-1,1]){

		difference() {
		union(){
				translate([i*body_w/2,0,0])
				rotate([0,back_a,(i+1)/2*180])
				translate([-back_arm_l-side_t/2,0,0])
					arm(arm_l=back_arm_l,shoulder_w=back_shoulder_w,shoulder_h=body_h/cos(back_a));

				translate([-i*(body_w/2+back_leg_fix_dist*cos(back_a)),0,-hag])
				rotate([0,0,(i+1)/2*180])
					back_leg(hag=hag, ankle_w=ankle_w, hip_w=hip_w, leg_t=leg_t, leg_w=leg_w, deport=deport, back_leg_fix_dist=back_leg_fix_dist, back_a=back_a);
		}

		//Holes for the serre fil to hold feet (shitty implementation)
		translate([i*(back_arm_l/2-3)*cos(back_a), 0, (back_arm_l/2-back_shoulder_w/2-2+2)*sin(back_a)])
		rotate([90, 90+back_a*-i,])
		cube([serre_w,serre_l,20*floor_t],center=true);

		translate([i*(back_arm_l/2-back_shoulder_w/2)*cos(back_a), 0, (back_arm_l/2-back_shoulder_w+2)*sin(back_a)])
		rotate([90, 90+back_a*-i,])
		cube([serre_w,serre_l,20*floor_t],center=true);
	}

	}

		

	}
}



//difference(){
//	drone();
///*	translate([0,150,0])*/
///*		cube([500,500,500],center=true);*/
///*	translate([-250,0,0])*/
///*		cube([500,500,500],center=true);*/
//}

drone();

//arm(arm_l=front_arm_l,shoulder_w=front_shoulder_w,shoulder_h=body_h);

//back_leg(hag=hag, ankle_w=ankle_w, hip_w=hip_w, leg_t=leg_t, leg_w=leg_w, deport=deport, back_leg_fix_dist=back_leg_fix_dist, back_a=back_a);

//body();