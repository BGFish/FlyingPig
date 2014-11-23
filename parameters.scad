//l:length, w:width, t:thickness, r:radius, d:diameter, h:height, a:angle, s:spacing (usu. betweeen 2 screws)


//##############################
//FIXED PARAMETERS (DONT CHANGE)
//##############################

// Electronics fixing
electronic_l=50;// size of DroFly: 50mmx50mm
electronic_s=45;// separation between DroFly screws

//holes for serre-cables
serre_w=3;
serre_l=6;

//bolt and nuts
bolt_r=3/2;
m3nut_d=3.17;
wire_hole_d=12;

//hole for usb cable
usb_l=12;
usb_w=12;
usb_offset=-11.3;
elec_h=-5;


//motor parameters
motor_r=28/2;
motor_screw_r=3/2; 
motor_hole_d=3;
motor_s_small = 16; 
motor_s_large = 19; 
jeu=2;
propeller_r=9*25.4/2;







//##############################
//##GENERAL SHAPE (CUSTOMIZABLE)
//##############################


//arm angles
front_a=30;//angle between front arm and Left-Right axis
back_a=30;//angle between back arm and horizontal


//body parameters
side_t=4; // thickness of body side walls
floor_t=5;// thickness of body floor
body_h=33;


// Arm fixing.
front_shoulder_w=52;
back_shoulder_w=52;
shoulder_s_h=35;
shoulder_s_v=15;

//arm parameters
front_arm_l=150;
back_arm_l=150;
arm_t=3;// thickness of arm walls
n_renforts=2;// number of reinforcements
renfort_w=5;
wrist_h=16;


//leg parameters (see diagram)
hag=50;//height above ground
ankle_w=15;
hip_w=35;
leg_t=3;
leg_w=20;
deport=50;
back_leg_fix_dist=10;



//#####################################
//CONSTRAINED PARAMETERS (DONT CHANGE)
//#####################################

motor_mount_r=motor_r+jeu/2;
wrist_w=2*motor_mount_r+2*arm_t;

body_w=1.2*electronic_l;
body_centre_l=1.8*electronic_l; 
















