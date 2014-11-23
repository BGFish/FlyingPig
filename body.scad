//##############
//#### Part: body
//body();


use <tools.scad>
include <parameters.scad>



//Front part of body, connects to front arms
module body_front(){// body to front_arms junction

	//checks
	if (body_w-front_shoulder_w*sin(front_a)*2-side_t*2<0){
		echo("WARNING: body_w too small for chosen front_a and side_t");
		}

	difference(){
		union(){
			//floor
			trapeze(body_w,body_w-front_shoulder_w*sin(front_a)*2,front_shoulder_w*cos(front_a),floor_t);
			//nose
			translate([0,(front_shoulder_w*cos(front_a)-side_t)/2,body_h/2])
				cube([body_w-front_shoulder_w*sin(front_a)*2,side_t,body_h],center=true);
			//shoulders
			for(i=[-1,1]){
				translate([i*(front_shoulder_w*sin(front_a)-body_w/2),front_shoulder_w*cos(front_a)/2,0])
				rotate([90,0,-90-i*front_a])
				translate([front_shoulder_w/2,body_h/2,-i*side_t/2])
					5holeplank(front_shoulder_w,body_h,side_t,wire_hole_d,2*bolt_r,shoulder_s_h,shoulder_s_v);
				}
		}
	//cut edges
	translate([0,-(front_shoulder_w*cos(front_a)+side_t)/2,body_h/2])
		cube([1.1*body_w,side_t,1.1*body_h],center=true);

	}

}

	        

//Back part of body, connects to back arms
module body_back(){

	difference(){
		union(){
			//This is the bottom plate 
			translate([0,side_t/2,floor_t/2])
			cube([body_w,back_shoulder_w+side_t,floor_t],center=true);
	
			//This is piggy's backside
			translate([0,-(back_shoulder_w-side_t)/2,body_h/2])
			cube([body_w,side_t,body_h],center=true);
	
			//This is the connection with body_centre
			translate([0,(back_shoulder_w+side_t)/2,body_h/2])
			cube([body_w,side_t,body_h],center=true);
	
			//This is a reinforcement
			translate([0,back_shoulder_w/5,(body_h-side_t*sin(back_a))/2])
			cube([body_w,side_t,body_h-side_t*sin(back_a)],center=true);
			
			//These are the shoulders
			for(i=[-1,1]){   
				translate([-i*body_w/2,0,0])
				rotate([0,i*back_a,0])
				translate([i*(side_t)/2,0,body_h/cos(back_a)/2])
				rotate([90,0,90])
				5holeplank(back_shoulder_w,body_h/cos(back_a),side_t,wire_hole_d,2*bolt_r,shoulder_s_h,shoulder_s_v);
				}	
			}	
		
		//carve central alley
		translate([0,2*side_t,floor_t+body_h/2])
		cube([body_w-2*body_h*tan(back_a)-2*side_t*cos(back_a),back_shoulder_w,body_h],center=true);
		
		//carve sides
        for(i=[-1,1]){   
            translate([i*body_w/2,0,0])
            rotate([0,-i*back_a,0])
            translate([i*body_w/2,-side_t/2,body_h])
            cube([body_w,back_shoulder_w+side_t,2*body_h],center=true);
        	}	
        	
        //clean edges
        translate([0,0,-body_h/2])
        cube([1.5*body_w,1.5*back_shoulder_w,body_h],center=true);
           
		}
}





//Centre of body, where the brain is
module body_centre(){  //electronics
	translate([0,0,body_h/2])
	difference(){
			union(){//la base
				cube([body_w,body_centre_l,body_h],center=true);
				cylinder(h=body_h,r=1.2*body_w/2+side_t
					,center=true);
				}
			//on évide
			translate([0,0,floor_t]){
				cylinder(h=body_h,r=1.2*body_w/2,center=true);
				cube([body_w-2*side_t,1.1*body_centre_l,body_h],center=true);
					}
			for (i=[-1,1]) for(j=[-1,1]){// pour fixer l'électronique
				translate([i*electronic_s/2,j*electronic_s/2,-body_h/2]){
				    cylinder(h=3*floor_t,r=bolt_r,center=true);
				    translate([0,0,floor_t/4])scale(1.1)nut(m3nut_d,floor_t/2);
			    }}
			for(i=[-1,1]){for(j=[-1,1]){// pour des serre-cables
			translate([i*(body_w/2-side_t-serre_w/2),j*(electronic_s/2-3*side_t),-body_h/2])cube([serre_w,serre_l,4*floor_t],center=true);
			    }}
			// for usb cable
			translate([-body_w/2,usb_offset,elec_h])cube([body_w,usb_w,usb_l],center=true);	
		}
}


module body(){

	difference(){
		union(){
			body_front();

			translate([0,-body_centre_l/2-front_shoulder_w*cos(front_a)/2])
				body_centre();
				
			translate([0,-body_centre_l-front_shoulder_w*cos(front_a)/2-back_shoulder_w/2,0])
				body_back();
		}

	//hole for battery cable
	translate([0,-front_shoulder_w*cos(front_a)/2,0])
	for(i=[0,60,120]){
		rotate([0,0,i])
			cube([body_w/4,cos(30)*body_w/2,body_h],center=true);
		}
	}
}



body();




