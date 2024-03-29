
%   AC grid OPF test case based on:
%   Sass, F., Sennewald, T., Marten, A.-K. and Westermann, D. (2017), 
%   Mixed AC high-voltage direct current benchmark test system for security constrained optimal power flow calculation. 
%   IET Gener. Transm. Distrib., 11: 447-455. https://doi.org/10.1049/iet-gtd.2016.0993
%   All DC libnks converter to AC
%

function mpc = case67
mpc.version = '2';
mpc.baseMVA = 100.0;

%% bus data
%	bus_i	type		Pd		Qd		  Gs	 Bs	   area		Vm	   Va		   baseKV	zone	  Vmax			 Vmin
mpc.bus = [
	1	 	3	 		0.0	 	0.0	 	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	2	 	2	 		0.0	    0.0	      0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	3	 	1	 		0.0	 	0.0	 	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	4	 	2	 		0.0	 	0.0	 	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	5	 	2	 	  	0.0	    0.0	      0.0	 0.0	 1	    1.0526	0	 		380.0	  1	      1.10000	    0.90000;
	6	 	1	 		191.0	76.0	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
    7	 	1	 		0.0	 	0.0	 	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	8	 	1	 		287.0	73.0	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	9	 	1	 		186.0	74.0	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	10 		2	 		0.0	 	0.0	 	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	11 		1	 		271.0	55.0	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	12 		1	 		171.0	87.0	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	13 		2	 		0.0	 	0.0	 	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	14 		1	 		199.0	60.0	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	15 		1	 		113.0	52.5	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	16 		1	 		38  	7.0 	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	17 		1	 		275.0	106.0	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	18 		2	 		0.0	 	0.0	 	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	19 		1	 		165.0	46.0	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	20 		1	 		178.0	82.5	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	21 		1	 		0.0	 	0.0	      0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	22 		1	 		30.0	7.0	      0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	23 		1	 		0.0	 	0.0	 	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	24 		1	 		32.0	7.0	      0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	25 		2	 		0.0	 	0.0	 	  0.0	 0.0	 1	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	26 		1	 		395.0	89.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	27 		1	 		0.0	 	0.0	 	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	28 		1	 		665.0	99.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	29 		2	 		0.0	 	0.0	 	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	30 		1	 		266.0	100.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	31 		1	 		845.0	119.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	32 		1	 		332.0	137.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	33 		2	 		0.0	 	0.0	 	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	34 		1	 		540.0	158.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	35 		1	 		460.0	97.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
    36 		2	 		0.0	 	0.0	 	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	37 		1	 		451.0	190.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	38 		1	 		150.0	0.0	      0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	39 		1	 		629.0	87.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	40 		1	 		0.0	 	0.0	 	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	41 		2	 		0.0	 	0.0	 	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	42 		1	 		859.0	180.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	43 		2	 		0.0	 	0.0	 	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	44 		1	 		474.0	92.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	45 		1	 		668.0	109.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	46 		1	 		614.0	95.0	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	47 		1	 		81.0	0.0	      0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	48 		1	 		0.0	 	0.0	 	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	49 		1	 		0.0	 	0.0	 	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	50 		2	 		0.0	 	0.0	 	  0.0	 0.0	 2	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	51 		1	 		430.0	123.0	  0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	52 		1	 		309.0	102.0	  0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	53 		1	 		100.0	30.0	  0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	54 		1	 		0.0	    0.0	      0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	55 		1	 		303.0	110.0	  0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	56 		2	 		0.0	    0.0	      0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	57 		1	 		0.0	    0.0	      0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	58 		1	 		324.0	157.0	  0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	59 		2	 		0.0	    0.0	      0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	60 		1	 		115.0	42.0	  0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	61 		1	 		187.0	75.0	  0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	62 		1	 		319.0	95.0	  0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	63 		2 			0.0	    0.0	      0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	64 		2 			0.0	    0.0	      0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	65 		1 			315.0	97.0	  0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	66 		2 			0.0	    0.0	      0.0	 0.0	 3	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	67 		2 			0.0	    0.0	      0.0	 0.0	 4	    1.0	    0	 		380.0	  1	      1.10000	    0.90000;
	
];

%% generator data
%	bus	   Pg	  Qg		Qmax		 Qmin	  Vg	   mBase	status		Pmax	  Pmin	 Pc1	 Pc2   Qc1min	Qc1max    Qc2min	Qc2max	ramp_agc	    ramp_10	      ramp_30	  ramp_q	   apf         alpha
mpc.gen = [
	1	  700.0	  23.0	 	1000.0	    -500.0	 1.0526    100.0	 1	 		1000.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	2	  1500.0  100.0	 	0.0	     	   0.0	 1.0526    100.0	 1	 		1500.0	  0.0    0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;  
	4	  523.0	  140.0	 	350.0	    -350.0	 1.0526    100.0	 1	 		560.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	5	  1200.0  100.0	 	000.0	     000.0	 1.0526    100.0	 1	 		1200.0	  0.0    0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	10	  436.0	  105.0	 	350.0	    -350.0	 1.0526	   100.0	 1			560.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0			0.0	 		0.0	 		0.0			1;
	13	  541.0	  117.0	 	300.0	    -300.0	 1.0526    100.0	 1			630.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0			0.0			1;
	18	  681.0	 -35.0	    400.0	    -400.0 	 1.0263    100.0	 1	 		720.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	25	  469.0	  59.0	    250.0	    -250.0   1.0395    100.0	 1	 		560.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	29	  500.0	  101.0	    350.0	    -350.0	 1.0263    100.0	 1	 		630.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	33	  496.0	  306.0	    500.0	    -500.0	 1.0263    100.0	 1	 		850.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	36	  512.0	  249.0	    400.0	    -400.0	 1.0263	   100.0	 1	 		720.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	41	  350.0	  238.0	    450.0	    -450.0	 1.0395    100.0	 1	 		850.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	43	  574.0	  223.0	    500.0	    -250.0	 1.0263    100.0	 1	 		720.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	50	  581.0	  150.0	    400.0	    -400.0	 1.0395    100.0	 1	 		720.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	56	  496.0	  56.0	    250.0	    -250.0	 1.0395    100.0	 1	 		560.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	59	  431.0	  206.0	    350.0	    -350.0	 1.0447    100.0	 1	 		720.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	63	  488.0	  152.0	    250.0	    -300.0	 1.0447    100.0	 1	 		520.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	64	  300.0	  61.0	    250.0	    -400.0   1.0474    100.0	 1	 		560.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	66	  537.0	  143.0	    300.0	    -400.0	 1.0447	   100.0	 1	 		630.0	  0.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
	67	  800.0	  0.0	 	  0.0	       0.0	 1.0526    100.0	 1	 		800.0	  0.0    0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;

];

%% generator data
%	bus	   Pg	  Qg		Qmax		 Qmin	  Vg	   mBase	status		Pmax	  Pmin	 Pc1	 Pc2   Qc1min	Qc1max    Qc2min	Qc2max	ramp_agc	    ramp_10	      ramp_30	  ramp_q	   apf         alpha
%mpc.gen = [
%	1	  700.0	  23.0	 	1000.0	    -500.0	 1.0526    100.0	 1	 		1000.0	  400.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	2	  1500.0  100.0	 	0.0	     	   0.0	 1.0526    100.0	 1	 		1500.0	  1500.0 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;  
%	4	  523.0	  140.0	 	350.0	    -350.0	 1.0526    100.0	 1	 		560.0	  220.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	5	  1200.0  100.0	 	000.0	     000.0	 1.0526    100.0	 1	 		1200.0	  1200.0 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	10	  436.0	  105.0	 	350.0	    -350.0	 1.0526	   100.0	 1			560.0	  220.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0			0.0	 		0.0	 		0.0			1;
%	13	  541.0	  117.0	 	300.0	    -300.0	 1.0526    100.0	 1			630.0	  250.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0			0.0			1;
%	18	  681.0	 -35.0	    400.0	    -400.0 	 1.0263    100.0	 1	 		720.0	  300.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	25	  469.0	  59.0	    250.0	    -250.0   1.0395    100.0	 1	 		560.0	  220.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	29	  500.0	  101.0	    350.0	    -350.0	 1.0263    100.0	 1	 		630.0	  250.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	33	  496.0	  306.0	    500.0	    -500.0	 1.0263    100.0	 1	 		850.0	  350.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	36	  512.0	  249.0	    400.0	    -400.0	 1.0263	   100.0	 1	 		720.0	  300.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	41	  350.0	  238.0	    450.0	    -450.0	 1.0395    100.0	 1	 		850.0	  350.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	43	  574.0	  223.0	    500.0	    -250.0	 1.0263    100.0	 1	 		720.0	  220.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	50	  581.0	  150.0	    400.0	    -400.0	 1.0395    100.0	 1	 		720.0	  300.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	56	  496.0	  56.0	    250.0	    -250.0	 1.0395    100.0	 1	 		560.0	  220.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	59	  431.0	  206.0	    350.0	    -350.0	 1.0447    100.0	 1	 		720.0	  300.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	63	  488.0	  152.0	    250.0	    -300.0	 1.0447    100.0	 1	 		520.0	  250.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	64	  300.0	  61.0	    250.0	    -400.0   1.0474    100.0	 1	 		560.0	  250.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	66	  537.0	  143.0	    300.0	    -400.0	 1.0447	   100.0	 1	 		630.0	  250.0	 0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%	67	  800.0	  0.0	 	  0.0	       0.0	 1.0526    100.0	 1	 		800.0	  800.0  0.0	 0.0	 0.0	  0.0	    0.0	     0.0	  0.0	 			0.0	 		0.0	 		0.0	 		0.0			1;
%
%];

%% branch data
%	fbus	tbus	r			 x			 b				  rateA	   rateB	   rateC	 ratio	  angle	    status	angmin	    angmax
mpc.branch = [
	1	 	5	 	0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0 	 0.0	  0.0	    1	 	-60.0	 	60.0;
	1	 	7	 	0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	    -60.0	 	60.0;
	1	 	8	 	0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	    -60.0	 	60.0;
	1	 	14 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	2	 	3 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	2	 	9 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	2	    12 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	3	 	4 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	3	 	10 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	3	 	12 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	3	 	9 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	4	 	14 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	4	 	19 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	5	 	6 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	5	 	7 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	5	 	8 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	6	 	7 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	7	 	15 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	7	 	16 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	8	 	9 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	10 		11 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	10 		22 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	11 		12 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	11 		13 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	12 		13 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	    -60.0	 	60.0;
	13 		53 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	14 		15 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	14 		18 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    16 		17 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	16 		18 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	17 		24 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	18 		24 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	19 		20 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	19 		23 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	20 		21 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	21 		25 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	21 		22 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	21 		23 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	22 		25 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	    -60.0	 	60.0;
	18 		20 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	24 		49 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	25 		43 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	26 		27 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	26 		31 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	26 		40 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	27 		28 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	28 		35 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	28 		37 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	29 		39 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	29 		44 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	30 		31 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	31 		27 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	30 		26 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	32 		40 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	41 		40 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	43 		44 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	33 		51 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	33 		34 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	34 		51 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	35 		33 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	35 		36 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	    -60.0	 	60.0;
	35 		47 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	29 		35 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	36 		37 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	36 		38 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	37 		38 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	39 		40 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	39 		43 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	41 		42 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	42 		43 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	42 		49 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	43 		49 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	44 		45 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	44 		48 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	45 		46 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	45 		50 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	47 		48 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	46 		48 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	47 		50 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	47 		51 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	47 		59 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	52 		53 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	52 		54 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	63 		55 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	22 		56 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	54 		65 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	55 		57 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	58 		61 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	56 		59 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	57 		58 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	56 		58 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	58 		60 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	62 		66 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	61 		62 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	52 		64 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	62 		63 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	59 		60 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	63 		57 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	65 		66 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	66 		54 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	66 		64 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
	30 		32 		0.00207756   0.01800554	 0.61242207 	  900.0	   900.0 	   900.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    7 		40 		0.00207756   0.01800554	 0.61242207 	 1575.0	  1575.0 	  1575.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    3 		23 		0.00207756   0.01800554	 0.61242207 	 1575.0	  1575.0 	  1575.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    23 		48 		0.00207756   0.01800554	 0.61242207 	 1575.0	  1575.0 	  1575.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    54 		57 		0.00207756   0.01800554	 0.61242207 	 1575.0	  1575.0 	  1575.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    7 		3 		0.00207756   0.01800554	 0.61242207 	 1575.0	  1575.0 	  1575.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    40 		27 		0.00207756   0.01800554	 0.61242207 	 1575.0	  1575.0 	  1575.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    27 		48 		0.00207756   0.01800554	 0.61242207 	 1575.0	  1575.0 	  1575.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    23 		54 		0.00207756   0.01800554	 0.61242207 	 1575.0	  1575.0 	  1575.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    40 		23 		0.00207756   0.01800554	 0.61242207 	 1575.0	  1575.0 	  1575.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    48 		57 		0.00207756   0.01800554	 0.61242207 	 1575.0	  1575.0 	  1575.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
    3 		67 		0.00207756   0.01800554	 0.61242207 	 1575.0	  1575.0 	  1575.0  	 0.0	  0.0	    1	 	-60.0	 	60.0;
];

%% generator cost data
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	2	 0.0	 0.0	 3	   0.000000	  10.000000	   0.000000;
	
];