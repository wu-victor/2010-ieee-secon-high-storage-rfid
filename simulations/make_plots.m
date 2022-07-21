% For NUM_RAND = 100 cases.

n = 100:100:1000;

% aloha, aloha-max, aloha-half
a = [109121.4800
231961.0800
367431.3500
583329.6500
888696.9100
1353184.2800
1991546.9000
2993716.7400
4446342.2500
6535160.4500];

am = [19804.6800
30271.7200
40805.4800
44700.2800
48000.2400
55959.4400
59215.6400
64174.3600
69514.9600
70800.8400];

ah = [28972.2400
52303.4800
72799.5200
91349.5200
103606.8800
111658.2800
118118.0400
127756.8800
141802.9600
154482.8400];

figure(1), plot(n,a,'k:o',n,am,'b:o',n,ah,'r:o');
axis([100 1000 0 2e6]);
title('Time to read newest tag');
xlabel('Number of tags');
ylabel('Time (bits transmitted)');
legend('aloha', 'aloha-max', 'aloha-half', 'location', 'northeast');
grid;

% aloha-max, aloha-half
am1 = [19804.6800
30271.7200
40805.4800
44700.2800
48000.2400
55959.4400
59215.6400
64174.3600
69514.9600
70800.8400];

am3 = [24573.3600
35075.9600
45554.4800
49159.8000
52751.0400
60906.9200
64363.6000
68780.7200
74662.3200
75767.2000];

am10 = [43213.0400
51373.3200
62229.1200
66155.8000
68760.5200
77969.6400
82510.5200
86767.9200
91017.5200
94061.9600];

am20 = [68784.6400
76906.5600
86542.8000
92155.7200
95251.2000
103552.9200
107370.2000
112932.3600
117222.5200
119938.1200];

ah1 = [28972.2400
52303.4800
72799.5200
91349.5200
103606.8800
111658.2800
118118.0400
127756.8800
141802.9600
154482.8400];

ah3 = [32664.8000
55959.4800
76455.5200
95023.8000
107262.8800
115332.5600
121774.0400
131431.1600
145495.5200
158138.8400];

ah10 = [46756.2800
69665.4800
89763.3600
108039.1600
120296.5200
128256.5200
136836.2400
144556.2000
159959.8800
171209.0400];

ah20 = [68820.2400
89755.2000
110156.8400
127141.7600
139563.6400
147304.2800
155847.4400
165054.5600
179172.1600
190512.7200];

figure(2), plot(n,am1,'b:o',n,am3,'b:s',n,am10,'b:^',n,am20,'b:v',...
                n,ah1,'r:o',n,ah3,'r:s',n,ah10,'r:^',n,ah20,'r:v');
title('Time to read i^{th} newest tag');
xlabel('Number of tags');
ylabel('Time (bits transmitted)');
legend('aloha-max, i = 1', 'aloha-max, i = 3', 'aloha-max, i = 10', 'aloha-max, i = 20', ...
       'aloha-half, i = 1', 'aloha-half, i = 3', 'aloha-half, i = 10', 'aloha-half, i = 20', ...
       'location', 'northwest');
grid;

% query tree, query tree-max
q = [34165.4600
69847.5400
105228.3200
140847.6400
176428.7600
212199.1200
248838.7200
283654.1800
319634.9200
356725.4200];

qm = [8002.8700
12349.0400
17657.2700
22121.8700
26083.9700
29100.6200
32527.3900
36672.1100
45381.7000
48057.5700];

figure(3), plot(n,q,'c:o',n,qm,'g:o');
title('Time to read newest tag');
xlabel('Number of tags');
ylabel('Time (bits transmitted)');
legend('query tree', 'query tree-max','location','northeast');
grid;

% query tree-max
qm1 = [8002.8700
12349.0400
17657.2700
22121.8700
26083.9700
29100.6200
32527.3900
36672.1100
45381.7000
48057.5700];

qm3 = [9761.9900
14187.7400
20652.2400
25426.9400
29790.0300
33344.4900
38143.6900
41888.1900
51078.1000
53557.8700];

qm10 = [14489.3700
20612.6200
28003.1200
33921.2300
39467.9400
42980.1700
47104.1900
53664.4800
62906.5900
67559.3200];

qm20 = [21767.9100
28653.4000
37330.4300
41506.0400
47952.1900
50707.0700
56040.3800
62833.1900
73770.3500
77378.7900];

figure(4), plot(n,qm1,'g:o',n,qm3,'g:s',n,qm10,'g:^',n,qm20,'g:v');
title('Time to read i^{th} newest tag');
xlabel('Number of tags');
ylabel('Time (bits transmitted)');
legend('query tree-max, i = 1', 'query tree-max, i = 3', 'query tree-max, i = 10', 'query tree-max, i = 20', ...
       'location', 'northwest');
grid;

% query tree, timeslots-query tree
q = [34165.46
69847.54
105228.32
140847.64
176428.76
212199.12
248838.72
283654.18
319634.92
356725.42];

ts = [19769.86
19518.67
19631.05
19480.94
19397.11
19309.49
19421.62
19310.44
19288.27
19172.63];

figure(5), plot(n,q,'c:o',n,ts,'m:o');
title('Time to read newest tag');
xlabel('Number of tags');
ylabel('Time (bits transmitted)');
legend('query tree', 'timeslots-query tree');
grid;

% all

figure(6), plot(n,a,'k:o',n,am,'b:o',n,ah,'r:o',n,q,'c:o',n,qm,'g:o',n,ts,'m:o');
axis([100 1000 0 5e5]);
title('Time to read newest tag');
xlabel('Number of tags');
ylabel('Time (bits transmitted)');
legend('aloha', 'aloha-max', 'aloha-half', 'query tree', 'query tree-max', 'timeslots-query tree');
%       'aloha-half, i = 1', 'aloha-half, i = 3', 'aloha-half, i = 10', 'aloha-half, i = 20', ...
%       'location', 'northwest');
grid;