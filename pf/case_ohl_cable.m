% Case to test adding data to matpower file
% tests refrence bus detection
% tests basic ac and hvdc modeling
% tests when gencost is present but not dclinecost
% quadratic objective function

function mpc = case_ohl_cable
mpc.version = '2';
mpc.baseMVA = 100.0;
mpc.bus = [
	1	 3	 0.0	  0.0	 0.0	 0.0	 1	    1.00000	   -0.00000	 220.0	 1	    1.10000	    0.90000;
	2	 1	 30.0	  0.0	 0.0	 0.0	 1	    1.00000	    7.25883	 220.0	 1	    1.10000	    0.90000;
];

mpc.gen = [
	1	 30.0	 0.0	 1000.0	 -1000.0	 1.0	 100.0	 1	 2000.0	 0.0;
];

mpc.gencost = [
	2	 0.0	 0.0	 3	   0.110000	   5.000000	   0.000000;
];

mpc.branch = [
	1	 2	 0.065	 0.62	 0.45	 9000.0	 0.0	 0.0	 0.0	 0.0	 1	 -60.0	 60.0;
];



