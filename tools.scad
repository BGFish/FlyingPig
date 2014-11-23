//#################
//#### Handy tools





module nut(size,height){
	union(){
		cube([5.5,size,height],center=true);
		rotate([0,0,60])cube([5.5,size,height],center=true);
		rotate([0,0,-60])cube([5.5,size,height],center=true);
    }
}



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


module trapeze(base,top,height,thick){
     linear_extrude(height=thick)
     polygon(points=[[base/2,-height/2],[-base/2,-height/2],[-top/2,height/2],[top/2,height/2]],paths=[ [0,1,2,3] ]);
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


module beam(start,end,thickness,caps=false){

	v1=end-start;
	v= caps ? v1+thickness*v1/sqrt(v1*v1) : v1; //vector

	center=(start+end)/2;
	lengthv=sqrt(v*v);
	costheta=v*[0,0,1]/lengthv;

	u=[v[0],v[1]]; //projection on XY plane
	lengthu=sqrt(u*u);
	cosphi=lengthu != 0 ? u*[1,0]/lengthu : 0;
	sinphi=lengthu != 0 ? u*[0,1]/lengthu : 0;

	theta=acos(costheta);
	phi= sinphi==0 ? acos(cosphi) : sinphi/abs(sinphi)*acos(cosphi);

/*	echo("cosphi", cosphi);*/
/*	echo("theta", theta);*/
/*	echo("phi", phi);*/

	translate(center)
	rotate(phi,[0,0,1])
	rotate(theta,[0,1,0])
		cube([thickness,thickness,lengthv],center=true);

}




module cbeam(start,end,thickness,caps=false){

	v1=end-start;
	v= caps ? v1+thickness*v1/sqrt(v1*v1) : v1; //vector

	center=(start+end)/2;
	lengthv=sqrt(v*v);
	costheta=v*[0,0,1]/lengthv;

	u=[v[0],v[1]]; //projection on XY plane
	lengthu=sqrt(u*u);
	cosphi=lengthu != 0 ? u*[1,0]/lengthu : 0;
	sinphi=lengthu != 0 ? u*[0,1]/lengthu : 0;

	theta=acos(costheta);
	phi= sinphi==0 ? acos(cosphi) : sinphi/abs(sinphi)*acos(cosphi);

	echo("cosphi", cosphi);
	echo("theta", theta);
	echo("phi", phi);

	translate(center)
	rotate(phi,[0,0,1])
	rotate(theta,[0,1,0])
		cylinder(h=lengthv,r=thickness/2,center=true);

}

