//##############
//#### Part: legs
//#Sub modules: back_leg, front_leg


use <tools.scad>
include <parameters.scad>

module back_leg(hag=50, ankle_w=15, hip_w=35, leg_t=3, leg_w=20, deport=30, back_leg_fix_dist=10, back_a=30){
	ankleL=[deport,0,leg_t/2];
	ankleR=[deport+ankle_w,0,leg_t/2];
	hipL=[leg_t/2*sin(back_a),0,hag+back_leg_fix_dist*sin(back_a)-leg_t/2*cos(back_a)];
	hipR=[hip_w*cos(back_a)+leg_t/2*sin(back_a),0,hag+(back_leg_fix_dist+hip_w)*sin(back_a)-leg_t/2*cos(back_a)];

	scale([1,leg_w/leg_t,1])
		union(){
			beam(ankleL,ankleR,leg_t,caps=true);//ankle
			beam(hipL,hipR,leg_t,caps=true);//hip
			beam(ankleL,hipL,leg_t);//sideL
			beam(ankleR,hipR,leg_t);//sideR
			beam(ankleL,hipR,leg_t);//crossLR
			beam(ankleR,hipL,leg_t);//crossRL
		}
}



module front_leg(hag=50, ankle_w=15, hip_w=35, leg_t=3, leg_w=20){
	ankleL=[-ankle_w/2,0,leg_t/2];
	ankleR=[ankle_w/2,0,leg_t/2];
	hipL=[-hip_w/2,0,hag-leg_t/2];
	hipR=[hip_w/2,0,hag-leg_t/2];

	scale([1,leg_w/leg_t,1])
		union(){
			beam(ankleL,ankleR,leg_t,caps=true);//ankle
			beam(hipL,hipR,leg_t,caps=true);//hip
			beam(ankleL,hipL,leg_t);//sideL
			beam(ankleR,hipR,leg_t);//sideR
			beam(ankleL,hipR,leg_t);//crossLR
			beam(ankleR,hipL,leg_t);//crossRL
		}
}




