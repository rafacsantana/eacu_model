clear
close all
format long g
warning off

time_lima  = datenum(2015,5,11,12,0,0):1:datenum(2016,5,15,12,0,0); % time of analysis
time_lima  = datenum(2015,7,11,12,0,0):1:datenum(2015,7,12,12,0,0); % time of analysis
%2015,5,1
time_lima  = datenum(2015,5,1,12,0,0):1:datenum(2015,5,3,12,0,0); % time of analysis
time_lima  = datenum(2015,5,1,12,0,0):1:datenum(2016,5,31,12,0,0); % time of analysis
%time_lima  = datenum(2015,5,1,12,0,0):1:datenum(2017,12,30,12,0,0); % time of analysis
%2015,1,3
%time_lima  = datenum(2015,1,3,12,0,0):1:datenum(2016,5,31,12,0,0); % time of analysis
%time_lima  = datenum(2015,1,3,12,0,0):1:datenum(2016,11,30,12,0,0); % time of analysis
%time_lima  = datenum(2015,1,3,12,0,0):1:datenum(2017,12,30,12,0,0); % time of analysis


runs=[79 80 96]; % part1 
%runs=[79 80 81]; % part1 
runs=[79 80 96 98 81]; % part1 
%runs=[96 98 81]; % part1 
%runs=[79 81 85 110]; % part2 m45
%runs=[79 91 94 102 92]; % 3days 
%runs=[79 114 118 119 117]; % 7 days

%runs=[79 113 115]; % a4 
%runs=[79 80 91 113 114]; % asf Xdays 
%runs=[79 81 117]; % aall
%runs=[79 117 120 121]; % m45
%runs=[79 105 116 114]; % started in january 
runs=[79 123 122 80]; % assh vs asst vs asf
runs=[124 125 126 81]; % twins
runs=[81 98 96 80]; % part1 
runs=[114 118 119 117]; % 7 days
%runs=[81 98 96 80 79]; % part1 
runs=[80 96 98 81]; % part1 
%runs=[79 80 96 98 81]; % part1 
%runs=[79 136 141 142 137];
%runs=[141];
runs=[136 142 141 137 81 79];
%runs=[137 141 142 136 81 79];

c=0

mooring=[4 5];
%mooring=[4];

% "increment_in_model_forcing.m"

calc_stats=c;
plot_pr   =0;
plot_td   =0;
plot_ser  =0;
plot_map  =1;
save_fig  =1

wtss      =0;
text_figs =0;
clean_data=1;
dif_mod   =0
layerp    =30
depthp    =100

colors={'r','k'}; % part 1
colors={'b','c','m','k','k','g','--b','--m','--r','--g','--c','--k','--y','r','b','m','c','k','y','g'}; % part 2
lstyle={'-','-','-','-','--','--' ,'-','-','-','-','-','-','-','-','-','-','-','-'};


% profiles
parampr=[7]; % 
% time depth
paramtd=[4]; % % 1 3 4 7 9 10
% series
params=[5 6 8 9 10 11 12 13]; %[2]; 1:9
params=[8 9 5 13]; %[2]; 1:9
%maps
paramm=[1:6]; % 7 9 10 [1 2 3 4 5 6 10]; % rmsd
paramm=[3 6 8 11 12]; % 7 9 10 [1 2 3 4 5 6 10]; % rmsd
paramm=[3]; % 7 9 10 [1 2 3 4 5 6 10]; % rmsd

variablespr={'serie_mod_u'   ,'serie_mod_v'    ,'serie_mod_t' ,'serie_mod_s',...
             'serie_rmsd_u'  ,'serie_rmsd_v'   ,'serie_inc_t' ,'serie_rmsd_s',...
             't_modcora_diff','s_modcora_diff' };

variablestd={'serie_mod_u' ,'serie_mod_v' ,'t_incs'        ,'serie_inc_t',... % serie_mod_u = inflow; serie_inc_t=timeseries t increment
             'serie_diff_u','serie_diff_v','serie_diff_t'  ,'serie_diff_s',... % serie_diff_t = t_obc
             'w_anas'      ,'t_modcora'   ,'t_modcora_diff','s_modcora_diff'}; % t_modcora    = t_flux

variabless={'serie_hfb'    ,'serie_hfa'    ,'serie_hfi',...
            'serie_wscb'   ,'serie_wsca'   ,'serie_wsci',...
            'serie_wscmb'  ,'serie_wscma'  ,'serie_wscmi',...
            'serie_mod_div','serie_mod_dre','serie_modw',...
            'serie_modwre'};

variablesm={'hfb','hfa','hfi','wscb','wsca','wsci',...
            'w_ana','w_anad',...
            't_bac','t_ana','t_inc','t_incd'};

udepth =[25,50,0,65,65]; % [m1 m2 m3 m4 m5]
tdepth =[45,75,100,100,100]; % 45,75,100,100,100
sdepth =[45,75,100,100,100];

%hycom
% /scale_wlg_nobackup/filesets/nobackup/niwa00020/data/hycom/GLBu0.08/nz$ ncdump -h expt_91.2/hycom_20160419.nc

% rivers on from 19 onwards
[exptss,expt_namess,start_times] = expt_names_dates(2);

adm={''}; %kr=kermadec ridge; ts=tasman sea; cr=cape reinga; ec=east cape

proc_insitu    =0;
proc_ts        =1; % either TS=1, velocity=0 or wind = 2
datatype       =1; % temp=1 salt=2 depth=3 for plot

rot_vel        =1; % 0 if plot section. Angle ~30o, calculated using distance
proc_qc_mean   =0; % in raw data - not used - 'QA/QC running mean - Emery and Thomsom 2004'  
proc_qc_sg     =1; % in raw data - used in M5 only- gradients

proc_int_data  =0; gap_interp =1; % PS: create matrixes before interpolating, int_data is not being saved, need to run avg together
proc_avg_data  =1; %raw_ts=0; % loop works with daily average only 
proc_sat_data  =0; interp_sat=1; npoints=20; if interp_sat==1 npoints=''; end % for time series only
calc_baroc_vel =0;

% type of data
plot_raw_data  =0; % if proc_ts==1 dont need to speficy the type of plot
plot_int_data  =0;
plot_avg_data  =1;
plot_baroc_vel =0;

%type of plot
plot_time_serie=1; plot_sat_data=0;
plot_depth_time=0; plot_backscatter=0; lim_y_lim=1; vis_pcolor=1;
plot_hodograph =0; vert_avg   =1;
plot_ts_diag   =1; 

visible        =0;
stop_fig       =0; 
close_fig      =1; 
save_data      =1;

days=1; % dont change it. averages are done inside the loopp 365; %1; % 1 to process the averages, 5 to plot the section
time_avgn  = datenum(0,0,days,00,0,0); % days
depth_avgn= 10; % meters


if calc_stats
display(['    '])
display(['PROCESSING EXPTS:'])
for i=1:length(runs)
  display([exptss{runs(i)}]);
  expts{i}=exptss{runs(i)};
  expt_names{i}=expt_namess{runs(i)};
  display([start_times{runs(i)}]);
  start_time{i}=start_times{runs(i)};
end
end

if plot_map || plot_ser || plot_td || plot_pr  
display(['    '])
display(['ANALYSING EXPTS:'])
for i=1:length(runs)
  display([exptss{runs(i)}]);
  expts{i}=exptss{runs(i)};
  expt_names{i}=expt_namess{runs(i)};
end
end

if plot_pr
display(['    '])
display(['PLOTTING MEAN PROFILE:'])
for i=1:length(parampr)
  display([variablespr{parampr(i)}]);
  variablepr{i}=variablespr{parampr(i)};
end
end

if plot_td
display(['    '])
display(['PLOTTING TIME DEPTH:'])
for i=1:length(paramtd)
  display([variablestd{paramtd(i)}]);
  variabletd{i}=variablestd{paramtd(i)};
end
end

if plot_ser
display(['    '])
display(['PLOTTING SERIES:'])
for i=1:length(params)
  display([variabless{params(i)}]);
  variables{i}=variabless{params(i)};
end
end

if plot_map 
display(['    '])
display(['PLOTTING MAPS:'])
for i=1:length(paramm)
  display([variablesm{paramm(i)}]);
  variablem{i}=variablesm{paramm(i)};
end
end


% time that span ADCP measurements
time_obs=datenum(2015,5,11):1/24/6:datenum(2016,5,17); % time of analysis
time_lim=time_obs; % time to set the depth_time plot limits and to plot the average sections

% ts profile parameters
time_profile=datenum(2015,7,20,0,0,0):1:datenum(2015,11,30,0,0,0); % time of analysis
timep=julian(datevec(time_profile));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% starting data processing
if proc_ts==1
  depth_obs = -2000:.25:0; %.25:0;
else
  depth_obs = -1100:.25:0; %.25:0;
end
depth_ts_sec=-2000:.25:0; %.25:0;

time_avgp=time_obs(1):1/24/6:[time_obs(1)+time_avgn];
depth_avgp=round(depth_avgn/abs(depth_obs(1)-depth_obs(2)));
time_avgl=time_lim(1):1/24/6:[time_lim(1)+time_avgn];

time_avg=time_obs(1)+time_avgn/2:time_avgn:time_obs(end)-time_avgn/2;
depth_avg=depth_obs(depth_avgp/2+1):depth_avgn:depth_obs(end);

time_avgpp=time_obs(1):1:[time_obs(1)+time_avgn];
time_avgll=time_lim(1):1:[time_lim(1)+time_avgn];

path_bath='/scale_wlg_persistent/filesets/project/niwa00020/data/topography/dtm/';
file_bath='nzbath250_2016.nc';

path_cora='/scale_wlg_persistent/filesets/project/niwa00020/santanarc/data/cora/';
path_ccmp='/scale_wlg_persistent/filesets/project/niwa00020/data/ccmp/';
path_aviso='/scale_wlg_persistent/filesets/project/niwa00020/data/aviso/adt/';
path_avhrr='/scale_wlg_persistent/filesets/project/niwa00020/data/oisst/south_pacific/AVHRR/';

path_data_mod='/scale_wlg_persistent/filesets/project/niwa00020/santanarc/data/hikurangi/sim26/small_grid/';

path_out_cora='hikurangi/sim26/small_grid/'; % model path
cora_prefix='CO_DMQCGL01_';
cora_sufix1={'_PR_'}; % _TS_
cora_sufix2={'PF','XB','CT','TE','BA'}; % _TS_
cora_sufix2={'PF'}; % _TS_
cora_color ={'m' ,'c' ,'r' ,'b' ,'k'}; % _TS_

%if plot_map==1 && plot_ser==1
  for i=1:length(expts)
    expt=expts{i};
    expt_name=expt_names{i};
  
    path_dm=[path_data_mod,expt,'/'];
    system(['mkdir -p ',path_dm]);
  
    if i==1
      if plot_map==1 && plot_ser==1
        path_fig=['/scale_wlg_nobackup/filesets/nobackup/niwa00020/santanarc/figures/hikurangi/sim26/small_grid/map_and_section/ssh_vel/',expt,''];
      elseif plot_map==1 && plot_ser==0
        path_fig=['/scale_wlg_nobackup/filesets/nobackup/niwa00020/santanarc/figures/hikurangi/sim26/small_grid/maps/ssh_vel/',expt,''];
      elseif plot_map==0 && plot_ser==1
        path_fig=['/scale_wlg_nobackup/filesets/nobackup/niwa00020/santanarc/figures/hikurangi/sim26/small_grid/sections/ssh_vel/',expt,''];
      elseif plot_map==0 && plot_td==1
        path_fig=['/scale_wlg_nobackup/filesets/nobackup/niwa00020/santanarc/figures/hikurangi/sim26/small_grid/sections/ssh_vel/',expt,''];
      elseif plot_map==0 && plot_pr==1
        path_fig=['/scale_wlg_nobackup/filesets/nobackup/niwa00020/santanarc/figures/hikurangi/sim26/small_grid/sections/ssh_vel/',expt,''];
      end
    else
      path_fig=[path_fig,'_',expt];
    end
    %path_fig=['/scale_wlg_nobackup/filesets/nobackup/niwa00020/santanarc/figures/hikurangi/obs/ne_moorings/sections/vel_ts/',...
    %         datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-avg-',num2str(time_avgn),'-day-gap',num2str(gap_interp),'/'];
  end
%end
path_fig=[path_fig,'/'];


path_data='/scale_wlg_persistent/filesets/project/niwa00020/santanarc/data/hikurangi/obs/ne_moorings/sections/vel_ts/';
path_adcp='/scale_wlg_nobackup/filesets/nobackup/niwa00020/santanarc/data/ne_moorings/DATA/Moorings/';
moorings={'M1','M2','M3','M4','M5'};
sufix_adcp='/working/WH/';
%sufix_adcp='/working/LR/';
files_adcp={'a1505eaa1_18120_tidied_filtered_above_80.mat',
            'a1505eab_19211_tidied_filtered_above_80.mat',
            ''
            'a1505ead1_19858_tidied_filtered_above_80.mat',
            'a1505eae1_18453_tidied_filtered_above_80.mat'};
            %  'M5EA_001_M5EA_002_M5EA_003.mat'};
sufix_lradcp='/working/LR/';
files_lradcp={'',
              '',
              ''
              'a1505ead2_12338_tidied_filtered_above_80.mat',
              'M5EA_001_M5EA_002_M5EA_003.mat'}; %'a1505eae1_11643c_tidied_filtered_above_85.mat'}; % commom file format only goes from aug2015 to apr2016

%system(['mkdir -p ',path_fig]);
system(['mkdir -p ',path_data]);

% TS data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
files_ts.m1={
'a1505eaa1_18120_tidied_filtered_above_80.mat'};
depth_ts_m1=[
54];

files_ts.m2={
's1505eab1_3431_qc.mat',
't1505eab3_2106_qc.mat',
't1505eab2_2097_qc.mat',
't1505eab4_2114_qc.mat',
%'a1505eab_19211_tidied_filtered_above_80.mat',
's1505eab2_7227_qc.mat'};
depth_ts_m2=[
50,
70,
80,
90,
%122,
122];

files_ts.m3={
's1505eac1_1627_qc.mat',
't1505eac1_868_qc.mat',
't1505eac2_2099_qc.mat',
't1505eac3_2102_qc.mat',
't1505eac4_2103_qc.mat',
't1505eac5_2109_qc.mat',
't1505eac6_2111_qc.mat',
't1505eac7_2112_qc.mat',
't1505eac8_2115_qc.mat',
's1505eac3_7039_qc.mat'}; % 8 thermistors
depth_ts_m3=[
50,
60,
70,
80,
90,
100,
120,
250,
300,
340];

files_ts.m4={
's1505ead1_5351_qc.mat',
't1505ead1_2101_qc.mat',
't1505ead2_4851_qc.mat',
%'a1505ead1_19858_tidied_filtered_above_80.mat',
't1505ead5_2105_qc.mat',
't1505ead6_4855_qc.mat',
's1505ead2_7038_qc.mat',
't1505ead7_875_qc.mat',
't1505ead8_902_qc.mat',
't1505ead9_4674_qc.mat',
't1505ead10_4857_qc.mat', 
's1505ead3_6302_qc.mat'}; % 8 thermistors
%'a1505ead2_12338_tidied_filtered_above_80.mat'};
depth_ts_m4=[
40,
50,
60,
%65,
90,
110,
190,
295,
500,
700,
900,
990];
%1000];

files_ts.m5={
's1505eae1_2763_qc.mat',
't1505eae1_903_qc.mat',
't1505eae2_4852_qc.mat',
%'a1505eae1_18453_tidied_filtered_above_80.mat', % wradcp
't1505eae3_874_qc.mat',
't1505eae4_4854_qc.mat',
't1505eae5_2100_qc.mat',
't1505eae6_4856_qc.mat',
's1505eae2_4969_qc.mat',
't1505eae7_2108_qc.mat',
't1505eae8_4850_qc.mat',
't1505eae9_4673_qc.mat',
't1505eae10_2098_qc.mat',
'M5EA_001_M5EA_002_M5EA_003.mat', %'a1505eae1_11643c_tidied_filtered_above_85.mat'}; % commom file format only goes from aug2015 to apr2016
's1505eae3_4840_qc.mat'}; % 10 thermistors
depth_ts_m5=[
25,
35,
45,
%50,
55,
65,
75,
135,
175,
280,
485,
685,
885,
985,
1780];


% M1 Deployment Position %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% File location M1/working/moor1505eaa.meta
% lat/lon format       :ddd mm.mmm H
m1lat                    =-(36+10.858/60);
m1lon                    =(174+54.803/60);
m1water_depth            =-60;
%m1declination            =19.5;
%% Deployment Timing
%time_format             :yyyy/mm/dd HH:MM:SS
m1start_time             ='2015/05/09 16:40:00';
m1stop_time              ='2016/05/27 12:39:40';
%utc_offset              :+12
%% Other
%notes                   :Trawled 10-Feb-2016, changed position
%
%% Instrumentation
%model,sn,depth        :sable,948970,54
%model,sn,depth        :whadcp,18120,54
%model,sn,depth        :ort,B9,57

% M2 Deployment Position %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lat/lon format       :ddd mm.mmm H
m2lat                    =-(35+48.590/60);
m2lon                    =(175+08.890/60);
m2water_depth            =-130;
%m2declination            =19.5
%
%% Deployment Timing
%time_format             =yyyy/mm/dd HH:MM:SS
m2start_time             ='2015/05/10 17:00:00';
m2stop_time              ='2016/05/20 15:00:00';
%utc_offset             :+12
%
%% Other
%notes                  :
%
%% Instrumentation
%model,sn,depth        :mcat,3431,50
%model,sn,depth,notes  :sbe56,865,60,flooded
%model,sn,depth        :sbe56,2097,70 %% 70 AND 80 M DEPTH - SWAPPED INSTRUMENTS
%model,sn,depth        :sbe56,2106,80
%model,sn,depth        :sbe56,2114,90
%model,sn,depth        :whadcp,19211,122
%model,sn,depth        :mcat,7227,122
%model,sn,depth        :dort,AF,123
%model,sn,depth        :dort,B1,123

% M3 Deployment Position %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lat/lon format       :ddd mm.mmm H 
m3lat                    =-(35+32.150/60);
m3lon                    =(175+18.727/60);
m3water_depth            =-438;
%m3declination            :19.5

% Deployment Timing
%time_format            :yyyy/mm/dd HH:MM:SS
m3start_time             ='2015/05/08 11:00:00';
m3stop_time              ='2016/05/25 07:30:00';
%m3utc_offset             :+12

% Other
%notes                  :Mooring recoverd in jul-2015 and redeployed with LR

% Instrumentation
%model,sn,depth        :mcat,1627,50
%model,sn,depth        :sbe56,868,60
%model,sn,depth        :sbe56,2099,70
%model,sn,depth        :sbe56,2102,80
%model,sn,depth        :sbe56,2103,90
%model,sn,depth        :sbe56,2109,100
%model,sn,depth        :sbe56,2111,120
%model,sn,depth,notes  :mcat,2443,200,flooded
%model,sn,depth        :sbe56,2112,250
%model,sn,depth        :sbe56,2115,300
%model,sn,depth        :mcat,7039,340
%model,sn,depth        :LRADCP,14749,328
%model,sn,depth        :ort,BA,431

% M4  Deployment Position %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lat/lon format       :ddd mm.mmm H 
m4lat                    =-(35+13.672/60);
m4lon                    =(175+30.049/60); 
m4water_depth            =-1105;
%m4declination            =19.5

% Deployment Timing
%time_format            :yyyy/mm/dd HH:MM:SS
m4start_time             ='2015/05/08 17:00:00';
m4stop_time              ='2016/05/23 08:00:00';
%utc_offset             :12
%
%% Other
%notes                  :
%
%% Instrumentation
%model,sn,depth        :mcat,5351,40
%model,sn,depth        :sbe56,2101,50
%model,sn,depth        :sbe56,4851,60
%model,sn,depth        :sable,193230,65
%model,sn,depth        :whadcp,19858,65
%model,sn,depth,notes  :sbe56,873,70,lost
%model,sn,depth,notes  :sbe56,4853,80,lost
%model,sn,depth        :sbe56,2105,90
%model,sn,depth        :sbe56,4855,110
%model,sn,depth        :mcat,7038,190
%model,sn,depth        :seaguard,1168,245
%model,sn,depth        :sbe56,875,295
%model,sn,depth        :seaguard,1112,400
%model,sn,depth        :sbe56,902,500
%model,sn,depth        :sbe56,4674,700
%model,sn,depth        :sbe56,4857,900
%model,sn,depth        :lradcp,12338,990
%model,sn,depth        :mcat,6302,990
%model,sn,depth        :dort,6B,993
%model,sn,depth        :dort,6F,993

% M5 Deployment Position %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lat/lon format       :ddd mm.mmm H 
m5lat                    =-(34+ 48.688/60);	
m5lon                    =(175+ 45.465/60);
m5water_depth            =-1800;
%m5declination            =19.5

% Deployment Timing
%time_format            :yyyy/mm/dd HH:MM:SS
m5start_time             ='2015/05/07 08:20:00';
m5stop_time              ='2016/05/18 06:40:00';
%utc_offset             :+12
%
%% Other
%notes                  :
%
%% Instrumentation
%model,sn,depth        :mcat,2763,25
%model,sn,depth        :sbe56,903,35
%model,sn,depth        :sbe56,4852,35
%model,sn,depth        :sable,6160,50
%model,sn,depth        :whadcp,18453,50
%model,sn,depth        :sbe56,874,55
%model,sn,depth        :sbe56,4854,65
%model,sn,depth        :sbe56,2100,75
%model,sn,depth        :sbe56,4856,135
%model,sn,depth        :mcat,4969,175
%model,sn,depth,notes  :seaguard,1109,230,raw file UTC
%model,sn,depth        :sbe56,2108,280
%model,sn,depth        :seaguard,129,385
%model,sn,depth        :sbe56,4850,485
%model,sn,depth        :sbe56,4673,685
%model,sn,depth        :sbe56,2098,885
%model,sn,depth        :lradcp,11643,985
%model,sn,depth,notes  :seaguard,1167,1190,raw file UTC
%model,sn,depth,notes  :seaguard,1111,1500,raw file UTC
%model,sn,depth        :mcat,4840,1780
%model,sn,depth,notes  :seaguard,127,1792,raw file UTC
%model,sn,depth        :dort,48,1793
%model,sn,depth        :dort,9E,1793


lonc_obs=[m1lon,m2lon,m3lon,m4lon,m5lon];
latc_obs=[m1lat,m2lat,m3lat,m4lat,m5lat];
disc_obs(1)=0;
for i=2:length(lonc_obs)
  disc_obs(i)=gsw_distance([lonc_obs(1) lonc_obs(i)],[latc_obs(1) latc_obs(i)])./1000; 
end

[p]=polyfit(lonc_obs,latc_obs,1);
lonc_obss(1)=174.792723; latc_obss(1)=(p(1)*lonc_obss(1))+p(2);
lonc_obss(2)=176.028868; latc_obss(2)=(p(1)*lonc_obss(2))+p(2); 

water_depth=[m1water_depth,m2water_depth,m3water_depth,m4water_depth,m5water_depth];

k=0;
for i=1:length(lonc_obs)-1
  k=k+1;
  lat_obs(k)=latc_obs(i);
  lon_obs(k)=lonc_obs(i);
  k=k+1;
  lat_obs(k)=(latc_obs(i)+latc_obs(i+1))./2;
  lon_obs(k)=(lonc_obs(i)+lonc_obs(i+1))./2;
end
k=k+1;
lat_obs(k)=latc_obs(length(lonc_obs));
lon_obs(k)=lonc_obs(length(lonc_obs));
%lat_obs = linspace(latc_obs(1),latc_obs(end),7); %:.25:latc_obs(end); %.10 interval
%lon_obs   = linspace(lonc_obs(1),lonc_obs(end),length(lat_obs)); % .05
dis_obs(1)=0;
for i=2:length(lon_obs)
  dis_obs(i)=gsw_distance([lon_obs(1) lon_obs(i)],[lat_obs(1) lat_obs(i)])./1000; 
end

dx=gsw_distance([lonc_obs(1) lonc_obs(end)],[latc_obs(1) latc_obs(1)]);
dy=gsw_distance([lonc_obs(1) lonc_obs(1)],[latc_obs(1) latc_obs(end)]);
%[dx,arc]=distance(latc_obs(1),lonc_obs(1),latc_obs(1),lonc_obs(end),6371);
%[dy,arc]=distance(latc_obs(1),lonc_obs(1),latc_obs(end),lonc_obs(1),6371);
ang_sec=atand(dy/dx);
%save([path_data,'m1m2m3m4m5_metadata.mat'])


% ROMS
v_spam=8;
path_mod='/scale_wlg_nobackup/filesets/nobackup/niwa00020/santanarc/work/hikurangi/sim26/';

% grd
sufix='small_grid/run_nov_2017/roms_his_0001.nc'; %grd/
filegrd=[path_mod,sufix];% ,'roms_grd_small.nc']; %'nz_roms_grid.nc'];
grd=roms_get_grid(filegrd,filegrd); % from a history file
h_mod=-grd.h;
dep_mod=grd.z_r;
lon_mod=grd.lon_rho;
lat_mod=grd.lat_rho;
i_nan_mod=find(h_mod>=-10); %h_mod(i_nan_mod)=nan;
inan200mod=find(h_mod>=-200); 

% model section for moorings
lon_modo=lonc_obs(1):1/48:lonc_obs(end);
%lat_modo=latc_obs(1):1/48:latc_obs(end);
lat_modo=linspace(latc_obs(1),latc_obs(end),length(lon_modo));

x_sec(1)=0;
for i=2:length(lon_modo)
  x_sec(i)=gsw_distance([lon_modo(1) lon_modo(i)],[lat_modo(1) lat_modo(i)])./1000;
end

for i=1:size(dep_mod,1)
  lat_mods(i,:)=lat_modo;
  lon_mods(i,:)=lon_modo;
  x_mods(i,:)=x_sec;
  dep_mods(i,:)=griddata(lon_mod,lat_mod,squeeze(dep_mod(i,:,:)),lon_modo,lat_modo);
end

% model indexes for moorings
%figure; hold on; imagesc(h_mod); colorbar; colorrr={'1','2','3','4','5'};
for m=1:5
  dist_mod=sqrt((lon_mod-lonc_obs(m)).^2+(lat_mod-latc_obs(m)).^2); 
  [ilatm(m),ilonm(m)]=find(dist_mod==nanmin(dist_mod(:)));
  %text(ilonm(m),ilatm(m),colorrr{m},'fontsize',10); caxis([-1801 -1800])
end

% for wsc
dx_mod=1./grd.pm;
dy_mod=1./grd.pn;

% depth sectoins from boundaries
dep_modb=[]; sbn=0; x_modb(1)=0; k=1;
for b=[1 4 3]

   if b==1 % NW or west
    ibi=find(grd.mask_rho(:,1)==1,1,'first');
    ibf=length(grd.mask_rho(:,1))-1;
    dep_modb=[dep_modb,squeeze(dep_mod(:,ibi:ibf,1))];

    for i=1:length(ibi:ibf)
      k=k+1;
      x_modb(k)=gsw_distance([lon_mod(ibi,1) lon_mod(ibi+i,1)],[lat_mod(ibi,1) lat_mod(ibi+i,1)])./1000;
    end
    x_mod=x_modb(end);

   elseif b==3 % SE or east
    ibi=find(grd.mask_rho(:,end)==1,1,'first');
    ibf=length(grd.mask_rho(:,1))-1;
    dep_modb=[dep_modb,flip(squeeze(dep_mod(:,ibi:ibf,end)),2)];

    for i=1:length(ibi:ibf)
      k=k+1;
      x_modb(k)=gsw_distance([lon_mod(ibi,end) lon_mod(ibi+i,end)],[lat_mod(ibi,end) lat_mod(ibi+i,end)])./1000+x_mod;
    end
    x_mod=x_modb(end);

   elseif b==4 % NE or north
    ibi=2; [~,ibf]=size(grd.mask_rho); ibf=ibf-1;
    dep_modb=[dep_modb,squeeze(dep_mod(:,end,ibi:ibf))];

    for i=1:length(ibi:ibf)-1
      k=k+1;
      x_modb(k)=gsw_distance([lon_mod(end,ibi) lon_mod(end,ibi+i)],[lat_mod(end,ibi) lat_mod(end,ibi+i)])./1000+x_mod;
    end
    x_mod=x_modb(end);

   end
   sbn=[sbn;sbn(end)+length(ibi:ibf)+1];

end
for i=1:size(dep_mod,1)
  x_modbb(i,:)=x_modb;
end
x_modb=x_modbb; clear x_modbb


% Map area
% pretty map area
loni=min(lon_mod(:)); % 172.66151247703385;
lonf=max(lon_mod(:)); %179.64135846748047;
lati=min(lat_mod(:)); %-38;%.87989849066502;
latf=max(lat_mod(:)); %-32.946064136149765;

%% lagged wind stress curl area
%loni=160;%172.66151247703385;
%lonf=190;% 179; %.64135846748047; %185; %
%lati=-45;%-38.87989849066502;     %-38; %
%latf=-25;%-32.946064136149765;    %-29; %
%
%% reduced lagged wind stress curl area
%loni=168;%172.66151247703385;
%lonf=184;% 179; %.64135846748047; %185; %
%lati=-40;%-38.87989849066502;     %-38; %
%latf=-32;%-32.946064136149765;    %-29; %

%AVISO
v_spaa=2;
aviso_file=[path_aviso,'2015/dt_global_allsat_phy_l4_20150510.nc'];
aviso_nc=aviso_file;
lon_aviso=double(ncread(aviso_nc,'longitude'));
lat_aviso=double(ncread(aviso_nc,'latitude'));
[difs ilona]=nanmin(abs(lon_aviso-loni)); 
[difs flona]=nanmin(abs(lon_aviso-lonf)); 
[difs ilata]=nanmin(abs(lat_aviso-lati)); 
[difs flata]=nanmin(abs(lat_aviso-latf)); 

lon_aviso=lon_aviso(ilona:flona);
lat_aviso=lat_aviso(ilata:flata);
[lon_avisom,lat_avisom]=meshgrid(lon_aviso,lat_aviso);

if plot_map==1 || calc_stats 

  bath_nc=[path_bath,file_bath];
  lon_bath=double(ncread(bath_nc,'lon'));
  lat_bath=double(ncread(bath_nc,'lat'));
  [difs ilonb]=nanmin(abs(lon_bath-loni)); 
  [difs flonb]=nanmin(abs(lon_bath-lonf)); 
  [difs ilatb]=nanmin(abs(lat_bath-lati)); 
  [difs flatb]=nanmin(abs(lat_bath-latf)); 
  lon_bath=lon_bath(ilonb:flonb);
  lat_bath=lat_bath(ilatb:flatb);
  %bath=ncread(bath_nc,'height',[ilonb ilatb],[flonb-ilonb+1 flatb-ilatb+1]);
  %bath=double(ncread(bath_nc,'height'));
  %bath=bath(ilonb:flonb,ilatb:flatb);
  [lon_bathm,lat_bathm]=meshgrid(lon_bath,lat_bath);
  lon_bathm=lon_bathm'; lat_bathm=lat_bathm';
 
  %CCMP
  v_spac=4;
  ccmp_file=[path_ccmp,'2015/CCMP_Wind_Analysis_20150501_V02.0_L3.0_RSS.nc'];
  ccmp_nc=ccmp_file;
  lon_ccmp=double(ncread(ccmp_nc,'longitude'));
  lat_ccmp=double(ncread(ccmp_nc,'latitude'));
  [difs ilonc]=nanmin(abs(lon_ccmp-loni)); 
  [difs flonc]=nanmin(abs(lon_ccmp-lonf)); 
  [difs ilatc]=nanmin(abs(lat_ccmp-lati)); 
  [difs flatc]=nanmin(abs(lat_ccmp-latf)); 
  
  lon_ccmp=lon_ccmp(ilonc:flonc);
  lat_ccmp=lat_ccmp(ilatc:flatc);
  [lon_ccmpm,lat_ccmpm]=meshgrid(lon_ccmp,lat_ccmp);

  dx_ccmp=nan(length(lon_ccmp)-1,length(lat_ccmp)-1);
  dy_ccmp=nan(length(lon_ccmp)-1,length(lat_ccmp)-1);
  for i=1:length(lon_ccmp)-1
   for ii=1:length(lat_ccmp)-1
    dx_ccmp(i,ii)=gsw_distance([lon_ccmp(i) lon_ccmp(i+1)],[lat_ccmp(ii) lat_ccmp(ii)]);
    dy_ccmp(i,ii)=gsw_distance([lon_ccmp(i) lon_ccmp(i)],[lat_ccmp(ii) lat_ccmp(ii+1)]);
   end
  end
  %dis_ccmp(:,end)=dis_ccmp(:,end-1);
  %dis_ccmp(end,:)=dis_ccmp(end-1,:);

  %AVISO
  v_spaa=2;
  aviso_file=[path_aviso,'2015/dt_global_allsat_phy_l4_20150510.nc'];
  aviso_nc=aviso_file;
  lon_aviso=double(ncread(aviso_nc,'longitude'));
  lat_aviso=double(ncread(aviso_nc,'latitude'));
  [difs ilona]=nanmin(abs(lon_aviso-loni)); 
  [difs flona]=nanmin(abs(lon_aviso-lonf)); 
  [difs ilata]=nanmin(abs(lat_aviso-lati)); 
  [difs flata]=nanmin(abs(lat_aviso-latf)); 
  
  lon_aviso=lon_aviso(ilona:flona);
  lat_aviso=lat_aviso(ilata:flata);
  [lon_avisom,lat_avisom]=meshgrid(lon_aviso,lat_aviso);
 
  %bath_aviso=griddata(lon_bathm,lat_bathm,bath,lon_avisom,lat_avisom);
  load('/scale_wlg_persistent/filesets/project/niwa00020/santanarc/scripts/niwa/matlab/bath_aviso.mat')
  inan200avi=find(bath_aviso>-200);

  %%AVHRR
  avhrr_file=[path_avhrr,'avhrr-only-v2.20150601.nc'];
  avhrr_nc=avhrr_file;
  lon_avhrr=ncread(avhrr_nc,'lon');
  lat_avhrr=ncread(avhrr_nc,'lat');
  [difs ilonv]=nanmin(abs(lon_avhrr-loni)); 
  [difs flonv]=nanmin(abs(lon_avhrr-lonf)); 
  [difs ilatv]=nanmin(abs(lat_avhrr-lati)); 
  [difs flatv]=nanmin(abs(lat_avhrr-latf)); 
  
  lon_avhrr=lon_avhrr(ilonv:flonv);
  lat_avhrr=lat_avhrr(ilatv:flatv);
  [lon_avhrrm,lat_avhrrm]=meshgrid(lon_avhrr,lat_avhrr);
  lon_avhrrm=double(lon_avhrrm);  lat_avhrrm=double(lat_avhrrm);

end

scrsz=[1 1 1366 768];
scrsz=[1 1 1920 1080];
scrsz=get(0,'screensize');  

load rwb; rwbreal=rwb; 
load gwb; gwbreal=gwb; 

%lon_aviso=lon_aviso(ilona:flona);
%lat_aviso=lat_aviso(ilata:flata);
%[lon_avisom,lat_avisom]=meshgrid(lon_aviso,lat_aviso);

%figure; 
%hold on
%colormap(jet); 
%%pcolor(lon_mod,lat_mod,h_mod); 
%imagesc(h_mod'); 
%shading flat; 
%colorbar
%caxis([-200 0])
%


for m=[mooring] 
  if strcmp(adm{1},'cr')
    lonc_obs(m)=172.963931;
    latc_obs(m)=-33.302201;
  elseif strcmp(adm{1},'cr2')
    lonc_obs(m)=175;
    latc_obs(m)=-33.5;
  elseif strcmp(adm{1},'ts')
    lonc_obs(m)=170.741491;
    latc_obs(m)=-35.532008;
  elseif strcmp(adm{1},'ts2')
    lonc_obs(m)=169;
    latc_obs(m)=-36;
  elseif strcmp(adm{1},'kr')
    lonc_obs(m)=178;
    latc_obs(m)=-35;
  elseif strcmp(adm{1},'ec')
    lonc_obs(m)=178;
    latc_obs(m)=-37.2;
  end
end

if visible==1; visibility='on'; else visibility='off'; end

if proc_insitu==1

    for m=[mooring]%:length(moorings)

        if plot_raw_data || proc_int_data

    	    display(['RAW DATA'])
            if proc_ts==0

    	      display(['Velocity DATA'])
              if m~=3
    	        file_obs=[path_adcp,moorings{m},sufix_adcp,files_adcp{m}];
    	        display(['Loading : ',file_obs])
    	        load([file_obs])
                time=time-0.5; % modifying time to 0 GMT
                time_vel=time;

                inan=find(bin_centres<2); u(inan)=nan; v(inan)=nan; % removing out of water data
                %bin_centres=fliplr(bin_centres); u=fliplr(u); v=fliplr(v);
                if rot_vel==1
                    [u,v]=rot2d(u,v,(90-ang_sec));
                end
                timej=julian(datevec(time));
                %datevec(time(1:3,1))

                if m==1
                    %figure; hold on;
                    %plot(instrument_depth)
                    %plot(bin_centres(:,1),'k')
                    bin_centres(:,2:end+1)=bin_centres(:,1:end); 
                    bin_centres(:,1)=instrument_depth; 
                    u(:,2:end+1)=u(:,1:end); 
                    u(:,1)=0; 
                    v(:,2:end+1)=v(:,1:end); 
                    v(:,1)=0; 
                end

                if m==2
                    inan=4:10;
                    if inan~=0
                        bin_check=bin_centres(1,inan); % removing low variability data
                        bin_centres(:,inan)=nan; u(:,inan)=nan; v(:,inan)=nan; % removing low variability data
                    end
                end

                if m==4 || m==5
                    time_sur=time; bin_centres_sur=bin_centres; u_sur=u; v_sur=v; 
    	            file_obs=[path_adcp,moorings{m},sufix_lradcp,files_lradcp{m}];
    	            display(['Loading: ',file_obs])
    	            load([file_obs])
                    time=time-0.5; % modifying time to 0 GMT
                    %bin_centres=fliplr(bin_centres); u=fliplr(u); v=fliplr(v);
                    if rot_vel==1
                        [u,v]=rot2d(u,v,(90-ang_sec));
                    end

                    if m==4 
                        bin_centres=[bin_centres,bin_centres_sur(1:length(time),:)];
                        u=[u,u_sur(1:length(time),:)];
                        v=[v,v_sur(1:length(time),:)];
                    end

                    if m==5
                        time_mobs=datenum(2015,5,8):1/24/6:datenum(2016,5,17); % time of analysis
                        if proc_qc_mean
                            display(['QA/QC running mean - Emery and Thomsom 2004'])
                            win=12; % 3 hours 
                            tstd=2;
                            for k=41:size(bin_centres,2)
                                for i=win/2:length(u)-win/2
                                    windo=i-win/2+1:i+win/2;
                                    um=nanmean(u(windo,k)); us=nanstd(u(windo,k));
                                    vm=nanmean(v(windo,k)); vs=nanstd(v(windo,k));
                                    if u(i,k)>um+us*tstd || u(i,k)<um-us*tstd || v(i,k)>vm+vs*tstd || v(i,k)<vm-vs*tstd %abs(v(i,k))>abs(nanmean(v(windo,k)))+nanstd(v(windo,k))*tstd
                                       if abs(u(i,k))>.35 || abs(v(i,k))>.35 
                                           u(i,k)=nan;
                                           v(i,k)=nan;
                                       end
                                    end
                                end
                                inan=find(abs(u(:,k))>.4); u(inan,k)=nan; v(inan,k)=nan; % removing peaks in the data                    
                                inan=find(abs(v(:,k))>.4); u(inan,k)=nan; v(inan,k)=nan; % removing peaks in the data                    
                            end
                            %u(:,42:end)=nan; % good data from 1:41 depth
                            %v(:,42:end)=nan;
                        end
                        if proc_qc_sg
                            display(['QA/QC gradients'])
                            for k=41:size(bin_centres,2)
                                dif=diff(u(:,k)); inan=find(abs(dif)>.2)+1; u(inan,k)=nan; v(inan,k)=nan; % removing peaks in the data                    
                                dif=diff(v(:,k)); inan=find(abs(dif)>.2)+1; u(inan,k)=nan; v(inan,k)=nan; % removing peaks in the data                    
                                for i=1:size(bin_centres,1)
                                    dif=diff(u(i,:)); inan=find(abs(dif)>.2)+1; u(i,inan)=nan; v(i,inan)=nan; % removing peaks in the data                    
                                    dif=diff(v(i,:)); inan=find(abs(dif)>.2)+1; u(i,inan)=nan; v(i,inan)=nan; % removing peaks in the data                    
                                end
                            end
                            %u(:,42:end)=nan; % good data from 1:41 depth
                            %v(:,42:end)=nan;
                        end

                        for i=1:size(bin_centres_sur,2)
                            bin_centres_sur_i(:,i)=interp1(time_sur,bin_centres_sur(:,i),time_mobs); 
                            u_sur_i(:,i)=interp1(time_sur,u_sur(:,i),time_mobs); 
                            v_sur_i(:,i)=interp1(time_sur,v_sur(:,i),time_mobs); 
                        end
                        for i=1:size(bin_centres,2)
                            bin_centres_i(:,i)=interp1(time,bin_centres(:,i),time_mobs); 
                            u_i(:,i)=interp1(time,u(:,i),time_mobs); 
                            v_i(:,i)=interp1(time,v(:,i),time_mobs); 
                        end
                        bin_centres=[bin_centres_i,bin_centres_sur_i];
                        u=[u_i,u_sur_i];
                        v=[v_i,v_sur_i];
                        time=time_mobs';
                    end

                end % m==4 || m==5        

              end % m~=3        

            % TS data
            else
    	      display(['PROCESSING TS DATA - CORRECTING DEPTH USING PRESSURE SENSORS - INCLUDING ADCP TEMP DATA'])
              length_ts=length(eval(['files_ts.m',num2str(m)]));

              depth_ts_obs=eval('base',['depth_ts_m',num2str(m)]);

			  % Preparing for temporal interpolation              
              temp_int=nan(length(time_obs),length_ts); %
              dept_int=nan(length(time_obs),length_ts); %
              salt_int=nan(length(time_obs),length_ts); %
       
              % fig properties
              xint=round(linspace(1,256,length_ts));
              jet=flipud(jet); jet_int=jet(xint,:);
              leg={};
              %figure('position',scrsz,'color',[1 1 1],'visible','on');  hold on; 

              i_dept=[]; x_dept=[];
              for i=1:length_ts

                file_ts=eval('base',['files_ts.m',num2str(m),'{',num2str(i),'}']);
                if file_ts(1)=='s' % if it has salinity data
    	          file_obs=[path_adcp,moorings{m},'/working/SBE37/',file_ts];

                  leg=[leg,{['depth: ',num2str(depth_ts_obs(i)),'m (ST)']}];

                elseif file_ts(1)=='a' ||  file_ts(1)=='M' % if it is an ADCP 
    	          file_obs=[path_adcp,moorings{m},'/working/WH/',file_ts]; % checking if it is a WHADCP
				  if exist(file_obs,'file')~=2
    	            file_obs=[path_adcp,moorings{m},'/working/LR/',file_ts]; % if not it is a LRADCP
                  end
                  leg=[leg,{['depth: ',num2str(depth_ts_obs(i)),'m (VT)']}];
                else
    	          file_obs=[path_adcp,moorings{m},'/working/SBE56/',file_ts];
                  leg=[leg,{['depth: ',num2str(depth_ts_obs(i)),'m (T)']}];
                end

    	        display(['Loading : ',file_obs])
    	        load([file_obs])


                % filling salinity data with linear regression between M4 and M5 data from similar depths
                if m==4 & (strcmp(file_ts,'s1505ead1_5351_qc.mat') || strcmp(file_ts,'s1505ead2_7038_qc.mat')) % M4 ts upper and middle sensor
                  if strcmp(file_ts,'s1505ead1_5351_qc.mat') % M4 upper sensor
                    % open M5 s1505eae1_2763_qc.mat
                    file_help=[path_adcp,'M5/working/SBE37/s1505eae1_2763_qc.mat'];

                  elseif strcmp(file_ts,'s1505ead2_7038_qc.mat') % M4 middler sensor
                    % open s1505eae2_4969_qc.mat
                    file_help=[path_adcp,'M5/working/SBE37/s1505eae2_4969_qc.mat'];
                  end

                  clear hs
                  hs=open([file_help]);
                  sh_int=interp1(hs.time,hs.sal,time);
                  salh=sal;  
                  inan=isnan(sh_int); sh_int(inan)=[]; salh(inan)=[]; 
                  inan=isnan(salh); sh_int(inan)=[]; salh(inan)=[]; 
                  figure; hold on; plot(sh_int,salh,'.k')
                  title(['Linear corr. = ',num2str(nancorr(sh_int,salh))])
                  xlabel('Sal at M5'); ylabel('Sal M4'); 
                  axis equal
                  pp=polyfit(sh_int,salh,1)
                  %figure; plot(time,sal)
                end

                time=time-0.5; % modifying time to 0 GMT

                % Assigning ADCP temp data
                time_mobs=datenum(2015,5,8):1/24/6:datenum(2016,5,17); % time of analysis for M5 deeper ADCP
                if file_ts(1)=='a' ||  file_ts(1)=='M' % if it is an ADCP file
                  display(['Planned depth: ',num2str(depth_ts_obs(i)),'. Actual median depth: ',num2str(nanmedian(bin_centres(:,1)))])
                  pre=interp1(time,bin_centres(:,1),time_mobs); 
                  tem=interp1(time,temperature,time_mobs); 
                  sal=nan(1,length(tem)); 
                  time=time_mobs;
                  % quality control at M1
                  if m==1;
                    inan=find(tem>21); tem(inan(1)-4:inan(end))=nan; pre(inan(1)-4:inan(end))=nan;
                  end
                elseif file_ts(1)=='s' 
                  display(['Planned depth: ',num2str(depth_ts_obs(i)),'. Actual median depth: ',num2str(nanmedian(pre(:)))])
                end

                %datevec(time(1:7))


                [dif,loci]=nanmin(abs(time_obs(1)-time)); %loci=loci-2;
                [dif,locf]=nanmin(abs(time_obs(end)-time)); %locf=locf+2;
                temp_int(:,i)=interp1(time(loci:locf),tem(loci:locf),time_obs,'linear');

				% Salinity and depth data
                if file_ts(1)=='s' || file_ts(1)=='a' ||  file_ts(1)=='M'  % if it has salinity data or if it is ADCP data
			      x_dept=[x_dept;i];
                  dept_int(:,i)=interp1(time(loci:locf),pre(loci:locf),time_obs,'linear');
                  i_nan=isnan(dept_int(:,i)); 
                  dept_int(i_nan,i)=nanmedian(dept_int(:,i));
                  salt_int(:,i)=interp1(time(loci:locf),sal(loci:locf),time_obs,'linear');

                  if m==4 & (strcmp(file_ts,'s1505ead1_5351_qc.mat') || strcmp(file_ts,'s1505ead2_7038_qc.mat')) % M4 ts upper and middle sensor

                    hs.time=hs.time-0.5; %hs=open([file_help]);
                    [~,locih]=nanmin(abs(time_obs(1)-hs.time)); %loci=loci-2;
                    [~,locfh]=nanmin(abs(time_obs(end)-hs.time)); %locf=locf+2;
                    %if m==4 & (strcmp(file_ts,'s1505ead2_7038_qc.mat')); return; end; % M4 ts upper and middle sensor
                    sh_int=interp1(hs.time(locih:locfh),hs.sal(locih:locfh),time_obs,'linear');
                    i_nanh=isnan(salt_int(:,i));
                    salt_int(i_nanh,i)=pp(1).*sh_int(i_nanh)+pp(2);

                  end

         
				  %figure; hold on; 
                  %plot(time,pre,'r'); 
                  %plot(time_obs,dept_int(:,i),'k'); 
                  %datetick('x')
                  %title(['Depth M',num2str(m),' - depth: ',num2str(depth_ts_obs(i)),'m',' - level: ',num2str(i)])
				  %figure; hold on; 
                  %plot(time,sal,'r'); 
                  %plot(time_obs,salt_int(:,i),'k'); 
                  %datetick('x')
                  %title(['Salinity M',num2str(m),' - depth: ',num2str(depth_ts_obs(i)),'m',' - level: ',num2str(i)])
                else
			      i_dept=[i_dept;i];
                end
              
				%figure; hold on; 
                %figure('position',scrsz,'color',[1 1 1],'visible','on');  hold on; 
                %plot(time,tem,'r'); 
                %plot(time_obs,temp_int(:,i),'k'); 
                %title(['Temperature M',num2str(m),' - depth: ',num2str(depth_ts_obs(i)),'m',' - level: ',num2str(i)])
                %datetick('x')

                deri=diff(temp_int(:,i)); % identifying number with the same slope as a result of long interpolation

                % works with m3 level 5 deri=diff(diff(temp_int(:,i))); % identifying number with the same slope as a result of long interpolation
                %i_zero=find(deri==0); deri(i_zero)=nan; % removing non-variant data
                %deri=diff(deri); % checking time derivatives again, now misinterpolated values should be equal or close to zero

                %i_deri=find(abs(deri)<1E-11)+1;
                i_deri=find(deri==mode(deri) & deri~=0)+1;

                ii_deri=find(diff(i_deri)<=4); % using points that are somehow close enough
                i_deri=i_deri(ii_deri); 
                while length(i_deri)>300 %62 %300

				  %figure; hold on; 
                  %plot(time_obs(i_deri),temp_int(i_deri,i),'.g'); 
                  %plot(time,tem,'r'); 
                  %plot(time_obs,temp_int(:,i),'b'); 
                  %title(['Temperature M',num2str(m),' - depth: ',num2str(depth_ts_obs(i)),'m'])
                  %legend('deleted','raw','interpolated')
                  %datetick('x')

                  temp_int(i_deri(1):i_deri(end),i)=nan;

                  deri=diff(temp_int(:,i)); i_deri=find(deri==mode(deri) & deri~=0)+1;
                  ii_deri=find(diff(i_deri)<=4); % using points that are somehow close enough
                  i_deri=i_deri(ii_deri); 
                end
                %plot(time,temp,'color',[jet_int(i,:)]); 
                
              end % for i=1:length_ts

                %legend(leg)
                %datetick('x')

			  % Correcting depth of TS measurements
              for i=1:length(i_dept)
				j=find(x_dept>i_dept(i),1,'first');
                dept_norm=(depth_ts_obs(i_dept(i))-depth_ts_obs(x_dept(j-1)))./(depth_ts_obs(x_dept(j))-depth_ts_obs(x_dept(j-1)));
                dept_int(:,i_dept(i))=dept_norm;
				dept_int(:,i_dept(i))=((dept_int(:,x_dept(j))-dept_int(:,x_dept(j-1))).*dept_int(:,i_dept(i)))+dept_int(:,x_dept(j-1));
              end % for i=1:length_ts


              if plot_raw_data % plot_raw_ts==1

             
                %depth_ts_obs=[depth_ts_obs,instrument_depth(1)];
                figure('position',scrsz,'color',[1 1 1],'visible','on')
                %figure;
                hold on; 
                if datatype==1
                  plot(time_obs,temp_int'); 
                  title(['Raw Temp Data M',num2str(m)])
                  ylabel('Temperature (^oC)')
                  legend(leg,'location','best')
                elseif datatype==2
                  plot(time_obs,salt_int(:,x_dept)'); 
                  title(['Raw Salt Data M',num2str(m)])
                  ylabel('Salinity (g/Kg)')
                  legend(leg{x_dept},'location','best')
                elseif datatype==3
                  plot(time_obs,-dept_int'); 
                  title(['Raw Depth Data M',num2str(m)])
                  ylabel('Depth (m)')
                  legend(leg,'location','best')
                end
                datetick('x')
                %xlim([time_obs(1) datenum(2015,6,1)])


                figure('position',scrsz,'color',[1 1 1],'visible','on')
                hold on; 
                if datatype==1
                  pcolor(time_obs,-[dept_int';dept_int(:,end)'-100],[temp_int';temp_int(:,end)']); shading flat; colorbar; 
                  title(['Temperature Data M',num2str(m)])
                elseif datatype==2
                  pcolor(time_obs,-[dept_int(:,x_dept)';dept_int(:,x_dept(end))'-100],[salt_int(:,x_dept)';salt_int(:,x_dept(end))']); shading flat; colorbar; 
                  title(['Salinity Data M',num2str(m)])
                elseif datatype==3
                  pcolor(time_obs,-[dept_int';dept_int(:,end)'-100],-[dept_int';dept_int(:,end)']); shading flat; colorbar; 
                  title(['Depth Data M',num2str(m)])
                end
                %pcolor([salt_int(:,x_dept)';salt_int(:,x_dept(end))']); shading flat; colorbar; 
                %pcolor(time_obs,-dept_int(:,x_dept)',salt_int(:,x_dept)'); shading flat; colorbar; 
			    %ylim([-300 0])
                %caxis([35.4 35.8])
                datetick('x')
                %xlim([time_obs(1) datenum(2015,6,1)])
                ylabel('Depth (m)')

              end % plot_raw_ts


              if m==1;
                  dept_int=[dept_int,dept_int(:,end)-20];
                  temp_int=[temp_int,temp_int(:,end)];  
              end


              if proc_int_data && gap_interp==0 

                dataname=[path_data,'m',num2str(m),'_ts_p_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(0),'.mat'];
                display(['Saving:  ',dataname])
                save([dataname],'lonc_obs','latc_obs','depth_ts_obs','dept_int','temp_int','salt_int','time_obs')

              end

            end % proc_ts

        end % raw_data


        if proc_int_data


          clear u_zint v_zint u_int v_int 
          clear t_zint s_zint d_zint t_int s_int d_int  

          if proc_ts==0   

            [dif,loci]=nanmin(abs(time_obs(1)-time)); %loci=loci-2;
            [dif,locf]=nanmin(abs(time_obs(end)-time)); %locf=locf+2;
            [dif,locl]=nanmin(abs(lonc_obs(m)-lon_obs)); 
    
            u_zint=nan(length(loci:locf),length(depth_obs)); %v_zint u_int v_int 
            v_zint=nan(length(loci:locf),length(depth_obs)); %v_zint u_int v_int 
            k=0;
            for loc=loci:locf
                k=k+1;
                %display(['Time: ',datestr(time_obs(k))])
                display(['Obs : ',datestr(time(loc,1))])
                %u_obs(:,locl,k)=interp1(-bin_centres(loc,:),u(loc,:),depth_obs);
                if gap_interp==1;
                    uloc=u(loc,:); inan=isnan(uloc); uloc(inan)=[]; 
                    vloc=v(loc,:); vloc(inan)=[]; 
                    bin_centresloc=bin_centres(loc,:); bin_centresloc(inan)=[];
                    if length(uloc)>=2
                        u_zint(k,:)=interp1(-bin_centresloc,uloc,depth_obs);
                        v_zint(k,:)=interp1(-bin_centresloc,vloc,depth_obs);
                    else
                        u_zint(k,:)=nan(length(depth_obs),1);
                        v_zint(k,:)=nan(length(depth_obs),1);
                    end 
                else
                    u_zint(k,:)=interp1(-bin_centres(loc,:),u(loc,:),depth_obs);
                    v_zint(k,:)=interp1(-bin_centres(loc,:),v(loc,:),depth_obs);
                end
            end
            u_int=nan(length(time_obs),length(depth_obs)); %v_zint u_int v_int 
            v_int=nan(length(time_obs),length(depth_obs)); %v_zint u_int v_int 
            for k=1:size(u_zint,2)
                display(['Depth int: ',num2str(depth_obs(k))])
                u_int(:,k)=interp1(time(loci:locf),u_zint(:,k),time_obs);
                v_int(:,k)=interp1(time(loci:locf),v_zint(:,k),time_obs);
            end

            dataname=[path_data,'m',num2str(m),'_proc_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'-rot',num2str(rot_vel),'.mat'];
            display(['Saving:  ',dataname])
            save([dataname],'lonc_obs','latc_obs','depth_obs','u_int','v_int','time_obs')

          else

            if gap_interp==1;
    	      display(['TS DATA'])

              t_zint=nan(length(time_obs),length(depth_obs)); 
              s_zint=nan(length(time_obs),length(depth_obs)); 
              d_zint=nan(length(time_obs),length(depth_obs)); 
              k=0;
              for loc=1:length(time_obs)
                  k=k+1;
                  display(['Obs : ',datestr(time_obs(loc))])

                      tloc=temp_int(loc,:); inan=isnan(tloc); tloc(inan)=[]; 
                      bin_centresloc=dept_int(loc,:); bin_centresloc(inan)=[];
                      if length(tloc)>=2
                          t_zint(k,:)=interp1(-bin_centresloc,tloc,depth_obs);
                      else
                          t_zint(k,:)=nan(length(depth_obs),1);
                      end 

                      sloc=salt_int(loc,:); inan=isnan(sloc); sloc(inan)=[]; 
                      bin_centresloc=dept_int(loc,:); bin_centresloc(inan)=[];
                      if length(sloc)>=2
                          s_zint(k,:)=interp1(-bin_centresloc,sloc,depth_obs);
                      else
                          s_zint(k,:)=nan(length(depth_obs),1);
                      end 


                  %else

                %    t_zint(k,:)=interp1(-dept_int(loc,:),temp_int(loc,:),depth_obs);
                %    s_zint(k,:)=interp1(-dept_int(loc,:),salt_int(loc,:),depth_obs);

              end

              t_int=t_zint; 
              s_int=s_zint; 

              dataname=[path_data,'m',num2str(m),'_ts_p_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(1),'.mat'];
              display(['Saving:  ',dataname])
              save([dataname],'lonc_obs','latc_obs','depth_obs','t_int','s_int','time_obs')

            end
            %t_int=t_zint; 
            %s_int=s_zint; 

            %dataname=[path_data,'m',num2str(m),'_ts_p_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
            %display(['Saving:  ',dataname])
            %save([dataname],'lon_obs','lonc_obs','latc_obs','depth_obs','t_int','s_int','time_obs')

          end % proc_ts
    
        end % if proc_int_data

        if plot_int_data || proc_avg_data
            %rwb(1,:)=1;
    	  display(['INT DATA'])

          if proc_ts==0   
            dataname=[path_data,'m',num2str(m),'_proc_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'-rot',num2str(rot_vel),'.mat'];
            display(['Loading: ',dataname])
            load([dataname])
            display(['Loaded'])
            %save([dataname],'lon_obs','lonc_obs','latc_obs','depth_obs','u_int','time_obs')
            time=time_obs'; u=u_int; v=v_int;
            bin_centres=nan(size(u,1),size(u,2));
            timej=julian(datevec(time));
            for i=2:size(u,1)
                bin_centres(i,:)=-depth_obs; %bin_centres(1,:);
            end

          else

    	    display(['TS DATA'])
            dataname=[path_data,'m',num2str(m),'_ts_p_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
            
            if gap_interp==1 %raw_ts==0             

              display(['Loading: ',dataname])
              load([dataname])
              display(['Loaded'])
              %save([dataname],'lon_obs','lonc_obs','latc_obs','depth_obs','u_int','time_obs')
              time=time_obs'; 
              u=t_int; v=s_int;
              u_int=t_int; v_int=s_int;
              bin_centres=nan(size(u,1),size(u,2));
              timej=julian(datevec(time));
              for i=2:size(u,1)
                  bin_centres(i,:)=-depth_obs; %bin_centres(1,:);
              end

            else
    	      display(['NON-VERT INTERP TS DATA'])

              %dataname=[path_data,'m',num2str(m),'_ts_r_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'.mat'];
              %dataname=[path_data,'m',num2str(m),'_ts_p_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
              display(['Loading: ',dataname])
              load([dataname])
              display(['Loaded'])
              %save([dataname],'lon_obs','lonc_obs','latc_obs','depth_obs','u_int','time_obs')
              time=time_obs'; 
              u=temp_int; v=salt_int;
              u_int=u; v_int=v;
              bin_centres=nan(size(u,1),size(u,2));
              timej=julian(datevec(time));
              for i=2:size(u,1)
                  bin_centres(i,:)=-depth_ts_obs; %bin_centres(1,:);
              end

            end

          end

        end

        if proc_avg_data
          display(['AVERAGING DATA'])
          u_avg=nan(length(time_avg),length(depth_avg)); %v_zint u_int v_int 
          v_avg=nan(length(time_avg),length(depth_avg)); %v_zint u_int v_int 
          i=0;
          for iobs=1:length(time_avgp)-1:length(time_obs)-1
              i=i+1; j=0;
              display(['M',num2str(m),' - Processing data from: ',datestr(time_obs(iobs),'yyyymmdd-HHMM'),' to ',datestr(time_obs(iobs+length(time_avgp)-2),'yyyymmdd-HHMM')])

              if gap_interp % raw_ts==0             

                for idep=1:depth_avgp:length(depth_obs)-depth_avgp
                    j=j+1;
                    u_avg(i,j)=nanmean(nanmean(u_int(iobs:iobs+length(time_avgp)-2,idep:idep+depth_avgp)));
                    v_avg(i,j)=nanmean(nanmean(v_int(iobs:iobs+length(time_avgp)-2,idep:idep+depth_avgp)));
                end

              else

                for idep=1:length(depth_ts_obs)
                    j=j+1;
                    u_avg(i,j)=nanmean(nanmean(u_int(iobs:iobs+length(time_avgp)-2,idep)));
                    v_avg(i,j)=nanmean(nanmean(v_int(iobs:iobs+length(time_avgp)-2,idep)));
                end
 
              end
            
          end

          %rwb(1,:)=1;
          %figure; colormap(rwb); hold on; imagesc(time_avg,depth_avg,u_avg'); colorbar; caxis([-.5 .5]); datetick('x')

          if proc_ts==0   
            dataname=[path_data,'m',num2str(m),'_avg_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'-rot',num2str(rot_vel),'.mat'];
            display(['Saving:  ',dataname])
            save([dataname],'lonc_obs','latc_obs','depth_avg','u_avg','v_avg','time_avg')

            %if plot_sat_data==1
            %  %%AVISO
            %  aviso_nc=[path_aviso,'2015/dt_global_allsat_phy_l4_20150915.nc'];
            %  lon_aviso=double(ncread(aviso_nc,'longitude'));
            %  lat_aviso=double(ncread(aviso_nc,'latitude'));
            %  [difs ilona]=nanmin(abs(lon_aviso-lonc_obs(m))); 
            %  [difs ilata]=nanmin(abs(lat_aviso-latc_obs(m))); 
            %  lon_aviso=lon_aviso(ilona);
            %  lat_aviso=lat_aviso(ilata);
            %  u_aviso=nan(1,length(time(1):time(end))); 
            %  v_aviso=nan(1,length(time(1):time(end))); 
            %  k=0; 
            %  time_aviso=time(1):time(end);
            %  for i=time(1):time(end)
            %    aviso_nc=[path_aviso,datestr(time(i),'yyyy'),'/dt_global_allsat_phy_l4_',datestr(time(i),'yyyymmdd'),'.nc'];
            %    display(['Loading AVISO: ',aviso_nc]); k=k+1;
            %    u_aviso=ncread(aviso_nc,'ugos',[ilona ilata 1],[1 1 Inf]);
            %    v_aviso=ncread(aviso_nc,'vgos',[ilona ilata 1],[1 1 Inf]);
            %    z_aviso=ncread(aviso_nc,'adt', [ilona ilata 1],[1 1 Inf]);

            %    t_avhrr(k)=ncread(avhrr_nc,'sst',[ilonv ilatv 1 1],[1 1 Inf Inf]);
            %  end
            %  dataname=[path_data,'avhrr',num2str(m),'_ts_a_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
            %  display(['Saving:  ',dataname])
            %  save([dataname],'t_avhrr','time_avhrr')

            %  avhrr_nc=[path_avhrr,'avhrr-only-v2.20150601.nc'];
            %  lon_avhrr=ncread(avhrr_nc,'lon');
            %  lat_avhrr=ncread(avhrr_nc,'lat');
            %  [difs ilonv]=nanmin(abs(lon_avhrr-lonc_obs(m))); 
            %  [difs ilatv]=nanmin(abs(lat_avhrr-latc_obs(m))); 
            %  lon_avhrr=lon_avhrr(ilonv);
            %  lat_avhrr=lat_avhrr(ilatv);
            %  t_avhrr=nan(1,length(time(1):time(end))); k=0; time_avhrr=time(1):time(end);
            %  for i=time(1):time(end)
            %    avhrr_nc=[path_avhrr,'/avhrr-only-v2.',datestr(i,'yyyymmdd'),'.nc'];
            %    display(['Loading AVHRR: ',avhrr_nc]); k=k+1;
            %    t_avhrr(k)=ncread(avhrr_nc,'sst',[ilonv ilatv 1 1],[1 1 Inf Inf]);
            %  end
            %  dataname=[path_data,'avhrr',num2str(m),'_ts_a_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
            %  display(['Saving:  ',dataname])
            %  save([dataname],'t_avhrr','time_avhrr')

            %end

          else
    	    display(['TS DATA'])

            t_avg=u_avg; s_avg=v_avg;

            if gap_interp %raw_ts==0             
    	      display(['SAVING VERT INTERP AVG TS DATA'])
            else
    	      display(['SAVING NON-VERT INTERP AVG TS DATA'])
              depth_avg=depth_ts_obs';
            end
            dataname=[path_data,'m',num2str(m),'_ts_a_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];

            display(['Saving:  ',dataname])
            save([dataname],'lonc_obs','latc_obs','depth_avg','t_avg','s_avg','time_avg')

            %if plot_sat_data==1
            %  %%AVHRR
            %  avhrr_nc=[path_avhrr,'avhrr-only-v2.20150601.nc'];
            %  lon_avhrr=ncread(avhrr_nc,'lon');
            %  lat_avhrr=ncread(avhrr_nc,'lat');
            %  [difs ilonv]=nanmin(abs(lon_avhrr-lonc_obs(m))); 
            %  [difs ilatv]=nanmin(abs(lat_avhrr-latc_obs(m))); 
            %  lon_avhrr=lon_avhrr(ilonv);
            %  lat_avhrr=lat_avhrr(ilatv);
            %  t_avhrr=nan(1,length(time(1):time(end))); k=0; time_avhrr=time(1):time(end);
            %  for i=time(1):time(end)
            %    avhrr_nc=[path_avhrr,'/avhrr-only-v2.',datestr(i,'yyyymmdd'),'.nc'];
            %    display(['Loading AVHRR: ',avhrr_nc]); k=k+1;
            %    t_avhrr(k)=ncread(avhrr_nc,'sst',[ilonv ilatv 1 1],[1 1 Inf Inf]);
            %  end
            %  dataname=[path_data,'avhrr',num2str(m),'_ts_a_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
            %  display(['Saving:  ',dataname])
            %  save([dataname],'t_avhrr','time_avhrr')

            %end

          end % proc_ts==0

        end % if proc_avg_data

        if proc_sat_data
          display(['PROC SAT DATA'])
          if proc_ts==0   
    	    display(['UV DATA'])
            time=time_obs;
            %%AVISO
            aviso_nc=[path_aviso,'2015/dt_global_allsat_phy_l4_20150510.nc'];
            lon_aviso=double(ncread(aviso_nc,'longitude'));
            lat_aviso=double(ncread(aviso_nc,'latitude'));

            [difs ilona]=nanmin(abs(lon_aviso-loni)); 
            [difs flona]=nanmin(abs(lon_aviso-lonf)); 
            [difs ilata]=nanmin(abs(lat_aviso-lati)); 
            [difs flata]=nanmin(abs(lat_aviso-latf)); 

            %[difs ilona]=nanmin(abs(lon_aviso-lonc_obs(m))); 
            %[difs ilata]=nanmin(abs(lat_aviso-latc_obs(m))); 

            lon_aviso=lon_aviso(ilona);
            lat_aviso=lat_aviso(ilata);

            u_aviso=nan(1,length(time(1):time(end))); 
            v_aviso=nan(1,length(time(1):time(end))); 
            k=0; 
            time_aviso=time(1):time(end);
            for i=time(1):time(end)
              aviso_nc=[path_aviso,datestr(i,'yyyy'),'/dt_global_allsat_phy_l4_',datestr(i,'yyyymmdd'),'.nc'];
              display(['Loading AVISO: ',aviso_nc]); k=k+1;
              %u_aviso(k)=ncread(aviso_nc,'ugos',[ilona ilata 1],[1 1 Inf]);
              %v_aviso(k)=ncread(aviso_nc,'vgos',[ilona ilata 1],[1 1 Inf]);
              %z_aviso(k)=ncread(aviso_nc,'adt', [ilona ilata 1],[1 1 Inf]);

              u_av=ncread(aviso_nc,'ugos',[ilona ilata 1],[flona-ilona+1 flata-ilata+1 Inf]);
              v_av=ncread(aviso_nc,'vgos',[ilona ilata 1],[flona-ilona+1 flata-ilata+1 Inf]);
              z_av=ncread(aviso_nc,'adt',[ilona ilata 1],[flona-ilona+1 flata-ilata+1 Inf]);
              u_aviso(k)=interp2(lon_avisom,lat_avisom,u_av',lonc_obs(m),latc_obs(m)); % used in section plot
              v_aviso(k)=interp2(lon_avisom,lat_avisom,v_av',lonc_obs(m),latc_obs(m));
              z_aviso(k)=interp2(lon_avisom,lat_avisom,z_av',lonc_obs(m),latc_obs(m));

            end

            dataname=[path_data,'aviso',num2str(m),'_uv_a_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
            display(['Saving:  ',dataname])
            save([dataname],'u_aviso','v_aviso','z_aviso','time_aviso')

          elseif proc_ts==1
    	    display(['TS DATA'])
            time=time_obs;
            %%AVHRR
            avhrr_nc=[path_avhrr,'avhrr-only-v2.20150601.nc'];
            lon_avhrr=ncread(avhrr_nc,'lon');
            lat_avhrr=ncread(avhrr_nc,'lat');
            [difs ilonv]=nanmin(abs(lon_avhrr-lonc_obs(m))); 
            [difs ilatv]=nanmin(abs(lat_avhrr-latc_obs(m))); 
            lon_avhrr=lon_avhrr(ilonv);
            lat_avhrr=lat_avhrr(ilatv);
            t_avhrr=nan(1,length(time(1):time(end))); k=0; time_avhrr=time(1):time(end);
            for i=time(1):time(end)
              avhrr_nc=[path_avhrr,'/avhrr-only-v2.',datestr(i,'yyyymmdd'),'.nc'];
              display(['Loading AVHRR:',avhrr_nc]); k=k+1;
              t_avhrr(k)=ncread(avhrr_nc,'sst',[ilonv ilatv 1 1],[1 1 Inf Inf]);
            end
            dataname=[path_data,'avhrr',num2str(m),'_ts_a_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
            display(['Saving:  ',dataname])
            save([dataname],'t_avhrr','time_avhrr')

          elseif proc_ts==2 % wind
            time=time_obs; time_ccmp=time(1):time(end);
            iloncm=find(lon_ccmp<lonc_obs(m),1,'last');
            ilatcm=find(lat_ccmp<latc_obs(m),1,'last');
		    %CCMP
            clear u_cc v_cc tx_cc ty_cc wsc_cc
            k=0;
            for i=time(1):time(end)
              k=k+1;
              ccmp_nc=[path_ccmp,datestr(i,'yyyy'),'/CCMP_Wind_Analysis_',datestr(i,'yyyymmdd'),'_V02.0_L3.0_RSS.nc'];
              display(['Loading CCMP: ',ccmp_nc])
              u_ccmp=double(nanmean(ncread(ccmp_nc,'uwnd',[ilonc ilatc 1],[flonc-ilonc+1 flatc-ilatc+1 Inf]),3));
              v_ccmp=double(nanmean(ncread(ccmp_nc,'vwnd',[ilonc ilatc 1],[flonc-ilonc+1 flatc-ilatc+1 Inf]),3));
              mag_ccmp=sqrt(u_ccmp.^2+v_ccmp.^2);
              cd=(0.75+0.067.*mag_ccmp)*1E-3; % garratt 1977 apud zeldis 2004
              tx_ccmp=1.3.*cd.*abs(u_ccmp).*u_ccmp;
              ty_ccmp=1.3.*cd.*abs(v_ccmp).*v_ccmp;
              %ty_ccmp=1.2.*0.0015.*abs(v_ccmp).*v_ccmp; % google
              dtxdy=(tx_ccmp(1:end-1,2:end)-tx_ccmp(1:end-1,1:end-1))./(dy_ccmp); % # ((grid.lat_rho[:,1:]-grid.lat_rho[:,:-1])*100000)#
              dtydx=(ty_ccmp(2:end,1:end-1)-ty_ccmp(1:end-1,1:end-1))./(dx_ccmp); % # ((grid.lat_rho[:,1:]-grid.lat_rho[:,:-1])*100000)#
              dtxdy(:,end+1)=dtxdy(:,end); dtxdy(end+1,:)=dtxdy(end,:);
              dtydx(:,end+1)=dtydx(:,end); dtydx(end+1,:)=dtydx(end,:);
              wsc_ccmp=dtydx-dtxdy;

              if interp_sat==1
                u_cc(k)=interp2(lon_ccmpm,lat_ccmpm,u_ccmp',lonc_obs(m),latc_obs(m)); % used in section plot
                v_cc(k)=interp2(lon_ccmpm,lat_ccmpm,v_ccmp',lonc_obs(m),latc_obs(m));
                tx_cc(k)=interp2(lon_ccmpm,lat_ccmpm,tx_ccmp',lonc_obs(m),latc_obs(m));
                ty_cc(k)=interp2(lon_ccmpm,lat_ccmpm,ty_ccmp',lonc_obs(m),latc_obs(m));
                wsc_cc(k)=interp2(lon_ccmpm,lat_ccmpm,wsc_ccmp',lonc_obs(m),latc_obs(m));
              else
                if npoints>5
                  u_cc(k)=nanmean(nanmean(u_ccmp(iloncm-5+1:iloncm+npoints,ilatcm-5+1:ilatcm+npoints))); 
                  v_cc(k)=nanmean(nanmean(v_ccmp(iloncm-5+1:iloncm+npoints,ilatcm-5+1:ilatcm+npoints))); 
                  tx_cc(k)=nanmean(nanmean(tx_ccmp(iloncm-5+1:iloncm+npoints,ilatcm-5+1:ilatcm+npoints))); 
                  ty_cc(k)=nanmean(nanmean(ty_ccmp(iloncm-5+1:iloncm+npoints,ilatcm-5+1:ilatcm+npoints))); 
                  wsc_cc(k)=nanmean(nanmean(wsc_ccmp(iloncm-5+1:iloncm+npoints,ilatcm-5+1:ilatcm+npoints))); 
                else
                  u_cc(k)=nanmean(nanmean(u_ccmp(iloncm-npoints+1:iloncm+npoints,ilatcm-npoints+1:ilatcm+npoints))); 
                  v_cc(k)=nanmean(nanmean(v_ccmp(iloncm-npoints+1:iloncm+npoints,ilatcm-npoints+1:ilatcm+npoints))); 
                  tx_cc(k)=nanmean(nanmean(tx_ccmp(iloncm-npoints+1:iloncm+npoints,ilatcm-npoints+1:ilatcm+npoints))); 
                  ty_cc(k)=nanmean(nanmean(ty_ccmp(iloncm-npoints+1:iloncm+npoints,ilatcm-npoints+1:ilatcm+npoints))); 
                  wsc_cc(k)=nanmean(nanmean(wsc_ccmp(iloncm-npoints+1:iloncm+npoints,ilatcm-npoints+1:ilatcm+npoints))); 
                end
              end

            end
            u_ccmp=u_cc; v_ccmp=v_cc; 
            tx_ccmp=tx_cc; ty_ccmp=ty_cc; wsc_ccmp=wsc_cc; 

            dataname=[path_data,'ccmp',num2str(m),adm{1},'_wind_a',num2str(npoints),'_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
            display(['Saving:  ',dataname])
            save([dataname],'u_ccmp','v_ccmp','tx_ccmp','ty_ccmp','wsc_ccmp','time_ccmp')

          end % proc_ts==0

        end % if proc_sat_data


        if plot_avg_data
            %rwb(1,:)=1;
    	    display(['AVG DATA'])
          if proc_ts==0   
            dataname=[path_data,'m',num2str(m),'_avg_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'-rot',num2str(0),'.mat'];
            display(['Loading: ',dataname])
            load([dataname])
            %save([dataname],'lonc_obs','latc_obs','depth_obs','u_int','time_obs')
            bin_centres=-depth_avg; time=time_avg'; u=u_avg; v=v_avg;
            if rot_vel==1
                [u,v]=rot2d(u,v,(90-ang_sec));
            end
            timej=julian(datevec(time));
            for i=2:size(u,1)
                bin_centres(i,:)=bin_centres(1,:);
            end

          else
    	    display(['TS DATA'])

            if gap_interp % raw_ts==0             
    	      display(['LOADING VERT INTERP AVG TS DATA'])
            else
    	      display(['LOADING NON-VERT INTERP AVG TS DATA'])
            end
            dataname=[path_data,'m',num2str(m),'_ts_a_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
            display(['Loading: ',dataname])
            load([dataname])
            %save([dataname],'lon_obs','lonc_obs','latc_obs','depth_obs','u_int','time_obs')
            bin_centres=-depth_avg; time=time_avg'; u=t_avg; v=s_avg;
            timej=julian(datevec(time));
            for i=2:size(u,1)
                bin_centres(i,:)=bin_centres(1,:);
            end

            if plot_sat_data==1
              %%AVHRR
              %avhrr_nc=[path_avhrr,'avhrr-only-v2.20150601.nc'];
              %lon_avhrr=ncread(avhrr_nc,'lon');
              %lat_avhrr=ncread(avhrr_nc,'lat');
              %[difs ilonv]=nanmin(abs(lon_avhrr-lonc_obs(m))); 
              %[difs ilatv]=nanmin(abs(lat_avhrr-latc_obs(m))); 
              %lon_avhrr=lon_avhrr(ilonv);
              %lat_avhrr=lat_avhrr(ilatv);
              %t_avhrr=nan(1,length(time(1):time(end))); k=0; time_avhrr=time(1):time(end);
              %for i=time(1):time(end)
              %  avhrr_nc=[path_avhrr,'/avhrr-only-v2.',datestr(i,'yyyymmdd'),'.nc'];
              %  display(['Loading AVHRR: ',avhrr_nc]); k=k+1;
              %  t_avhrr(k)=ncread(avhrr_nc,'sst',[ilonv ilatv 1 1],[1 1 Inf Inf]);
              %end
              dataname=[path_data,'avhrr',num2str(m),'_ts_a_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
              display(['Loading: ',dataname])
              load([dataname])%,'t_avhrr','time_avhrr')

            end

          end


        end


        if plot_time_serie

            uleg={}; vleg={};
            uk=[]; vk=[];
            if plot_sat_data==1; t_avhrri=interp1(time_avhrr,t_avhrr,time); end
            for i=1:size(bin_centres,2)
              if sum(isnan(u(:,i)))~=size(u,1)
                if plot_sat_data==1
                  c=nancorr(t_avhrri,u(:,i));
                  uleg=[uleg,{['depth: ',num2str(bin_centres(1,i)),'m (',num2str(c,'%.2f'),')']}];
                else
                  uleg=[uleg,{['depth: ',num2str(bin_centres(1,i)),'m']}];
                end
                uk=[uk,i];
              end
              if sum(isnan(v(:,i)))~=size(v,1)
                vleg=[vleg,{['depth: ',num2str(bin_centres(1,i)),'m']}];
                vk=[vk,i];
              end
            end

            display(['Ploting M',num2str(m)]) 
            figure('position',scrsz,'color',[1 1 1],'visible','on')
 
            if plot_raw_data && plot_backscatter
                ylims=[-130 -80];
                u=beam4_amplitude  ;%+beam4_amplitude+beam4_amplitude+beam4_amplitude)./4;
                v=beam4_correlation;%+beam4_correlation+beam4_correlation+beam4_correlation)./4;
                w=beam4_perc_good  ;%+beam4_perc_good+beam4_perc_good+beam4_perc_good)./4;
                ut='Amp'; vt='Corr'; wt='Perc';
            elseif proc_ts==0
                ut='U'; vt='V'; wt='W';
                %ylims=[min(depth_obs(~isnan(u(size(u,1)/2,:)))) max(depth_obs(~isnan(u(size(u,1)/2,:))))];
                ylims=[min(depth_obs) max(depth_obs)];
                if m==1; ylims(1)=-80; end
                if m==2; ylims(1)=-140; end

            else
                ut='T'; vt='S'; wt='D';
                %ylims=[min(depth_obs(~isnan(u(size(u,1)/2,:)))) max(depth_obs(~isnan(u(size(u,1)/2,:))))];
                ylims=[min(depth_obs) max(depth_obs)];
                if m==1; ylims(1)=-80; end
                if m==2; ylims(1)=-140; end
            end

            %subplot(4,1,[1 2])
            set(gca,'fontsize',12,'fontweight','bold')
            hold on; 

            if plot_sat_data==1
              uleg=[{['Sat. data (corr. coef)']},uleg];
              plot(julian(datevec(time_avhrr)),t_avhrr,'--k'); 
            end

            if ~isempty(uk)
              plot(timej,u(:,uk)); 
              if gap_interp==0 %raw_ts==1
                legend(uleg,'location','bestoutside')
              end
            else
              plot(timej,u); 
            end

    	    title(['M',num2str(m),' ',ut])%,' rot=',num2str(rot_vel)])
            xlim([julian(datevec(time_lim(1))) julian(datevec(time_lim(end)))])
            %if plot_raw_data && plot_backscatter
            if lim_y_lim
            %ylim([ylims(1) ylims(2)])
            end
            %end
            %datetick('x','keeplimits','keepticks')
            gregaxd(timej(:,1),round((length(time_lim)*(time_lim(2)-time_lim(1)))/10))
            %set(gca,'xtick','')
            grid

return 

            %subplot(4,1,[3 4])
            %set(gca,'fontsize',12,'fontweight','bold')
            %hold on;
            %if ~isempty(vk)
            %  plot(timej,v(:,vk)); 
            %  if gap_interp==0 %raw_ts==1
            %    legend(vleg,'location','bestoutside')
            %  end
            %else
            %  plot(timej,v); 
            %end
    	    %title(['M',num2str(m),' ',vt])%,' rot=',num2str(rot_vel)])
            %xlim([julian(datevec(time_lim(1))) julian(datevec(time_lim(end)))])
            %if lim_y_lim
            %%ylim([ylims(1) ylims(2)])
            %end
            %%datetick('x','keeplimits','keepticks')
            %gregaxd(timej(:,1),round((length(time_lim)*(time_lim(2)-time_lim(1)))/10))
            %grid


            %subplot(3,1,3)
            %set(gca,'fontsize',12,'fontweight','bold')
            %hold on; pcolor(time,-bin_centres,w); colorbar; 
            %%caxis([24.5 25.5]); 
            %shading flat; colormap(rwb)
    	    %title(['M',num2str(m),' ',wt,' rot=',num2str(rot_vel)])
            %xlim([time_obs(1) time_obs(end)])
            %ylim([ylims(1) ylims(2)])
            %%ylim([-140 0])
            %%gregaxm(timej(:,1),1)
            %datetick('x','keeplimits','keepticks')
            %grid
    
    
            if save_fig==1
                if plot_raw_data && plot_backscatter
                   figname=['m',num2str(m),'_backscatter-',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'-rot',num2str(rot_vel)];
                else
                   figname=['m',num2str(m),'_depth_time-',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'-rot',num2str(rot_vel)];
                end
                figname=[path_fig,figname];
            	display(['Saving: ',figname])
            	export_fig(gcf,figname,'-png','-r300' );
            	%print('-dpng','-r300',figname)
            	%saveas(gcf,figname,'fig')
            end
            if close_fig==1
            	close
            end
    
        end % plot_time_serie

        if plot_depth_time
            %nan(size(u,1),size(u,2));
            for i=2:size(u,2)
                time(:,i)=time(:,1);
                timej(:,i)=timej(:,1);
            end
            display(['Ploting M',num2str(m)]) 
            figure('position',scrsz,'color',[1 1 1],'visible','on')
 
            if plot_raw_data && plot_backscatter
                ylims=[-130 -80];
                u=beam4_amplitude  ;%+beam4_amplitude+beam4_amplitude+beam4_amplitude)./4;
                v=beam4_correlation;%+beam4_correlation+beam4_correlation+beam4_correlation)./4;
                w=beam4_perc_good  ;%+beam4_perc_good+beam4_perc_good+beam4_perc_good)./4;
                ut='Amp'; vt='Corr'; wt='Perc';
            elseif proc_ts==0
                ut='Across-line velocities'; vt='Along-line velocities'; wt='W';
                %ylims=[min(depth_obs(~isnan(u(size(u,1)/2,:)))) max(depth_obs(~isnan(u(size(u,1)/2,:))))];
                ylims=[min(depth_obs) max(depth_obs)];
                if m==1; ylims(1)=-80; end
                if m==2; ylims(1)=-140; end
                if m==3; ylims(1)=-500; end

            else
                ut='T'; vt='S'; wt='D';
                %ylims=[min(depth_obs(~isnan(u(size(u,1)/2,:)))) max(depth_obs(~isnan(u(size(u,1)/2,:))))];
                ylims=[min(depth_obs) max(depth_obs)];
                if m==1; ylims(1)=-80; end
                if m==2; ylims(1)=-140; end
                if m==3; ylims(1)=-500; end
                if m==4; ylims(1)=-1200; end
            end

            if vis_pcolor==1;
                u(:,end+1)=u(:,end);
                v(:,end+1)=v(:,end);
                bin_centres(:,end+1)=bin_centres(:,end)-abs(bin_centres(:,end-1)-bin_centres(:,end));
                timej(:,end+1)=timej(:,end);
            end

            subplot(2,1,1)
            set(gca,'fontsize',12,'fontweight','bold')
            hold on; pcolor(timej,-bin_centres,u); colorbar; 
            if proc_ts==0   
              caxis([-.5 .5]); 
              colormap(rwb)
            end
            shading flat; 
    	    title(['M',num2str(m),' ',ut])%,' rot=',num2str(rot_vel)])
            xlim([julian(datevec(time_lim(1))) julian(datevec(time_lim(end)))])
            %if plot_raw_data && plot_backscatter
            if lim_y_lim
            ylim([ylims(1) ylims(2)])
            end
            %end
            %datetick('x','keeplimits','keepticks')
            plot([timep(1) timep(1)],[ylims(1) 0],'--k','linewidth',2)
            plot([timep(end) timep(end)],[ylims(1) 0],'--k','linewidth',2)
            gregaxd(timej(:,1),round((length(time_lim)*(time_lim(2)-time_lim(1)))/10))
            grid

            subplot(2,1,2)
            set(gca,'fontsize',12,'fontweight','bold')
            hold on; pcolor(timej,-bin_centres,v); colorbar; 
            if proc_ts==0   
              caxis([-.5 .5]); 
              colormap(rwb)
            end
            %caxis([120 135]); 
            shading flat; 
    	    title(['M',num2str(m),' ',vt])%,' rot=',num2str(rot_vel)])
            xlim([julian(datevec(time_lim(1))) julian(datevec(time_lim(end)))])
            if lim_y_lim
            ylim([ylims(1) ylims(2)])
            end
            %datetick('x','keeplimits','keepticks')
            plot([timep(1) timep(1)],[ylims(1) 0],'--k','linewidth',2)
            plot([timep(end) timep(end)],[ylims(1) 0],'--k','linewidth',2)
            gregaxd(timej(:,1),round((length(time_lim)*(time_lim(2)-time_lim(1)))/10))
            grid

            %subplot(3,1,3)
            %set(gca,'fontsize',12,'fontweight','bold')
            %hold on; pcolor(time,-bin_centres,w); colorbar; 
            %%caxis([24.5 25.5]); 
            %shading flat; colormap(rwb)
    	    %title(['M',num2str(m),' ',wt,' rot=',num2str(rot_vel)])
            %xlim([time_obs(1) time_obs(end)])
            %ylim([ylims(1) ylims(2)])
            %%ylim([-140 0])
            %%gregaxm(timej(:,1),1)
            %datetick('x','keeplimits','keepticks')
            %grid
    
            umean=nanmean(u,1);                                                                             
            ustd=nanstd(u,1);    
            vmean=nanmean(v,1);                                                                             
            vstd=nanstd(v,1);
            %subplot(3,1,3)
            %set(gca,'fontsize',12,'fontweight','bold')
            %hold on; 
            %plot(umean,-nanmean(bin_centres,1),'b','linewidth',2);                 
            %plot(vmean,-nanmean(bin_centres,1),'r','linewidth',2);             
            %plot(umean+ustd,-nanmean(bin_centres,1),'b--','linewidth',2);      
            %plot(umean-ustd,-nanmean(bin_centres,1),'b--','linewidth',2);      
            %plot(vmean+vstd,-nanmean(bin_centres,1),'r--','linewidth',2);      
            %plot(vmean-vstd,-nanmean(bin_centres,1),'r--','linewidth',2);      
            %if lim_y_lim
            %ylim([ylims(1) ylims(2)])
            %end
            %grid
            %if proc_ts==0   
    	    %  legend('U mean','V mean')%,'','','','')
            %else
    	    %  legend('T mean','S mean')%,'','','','')
            %end

    	    %title(['Mooring ',num2str(m)])
    
            if save_fig==1
                if plot_raw_data && plot_backscatter
                   figname=['m',num2str(m),'_backscatter-',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'-rot',num2str(rot_vel)];
                else
                   figname=['m',num2str(m),'_depth_time-',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'-rot',num2str(rot_vel)];
                end
                figname=[path_fig,figname];
            	display(['Saving: ',figname])
            	export_fig(gcf,figname,'-png','-r300' );
            	%print('-dpng','-r300',figname)
            	%saveas(gcf,figname,'fig')
            end
            if close_fig==1
            	close
            end
    
        end % plot_depth_time

        if plot_hodograph
            bin_centresm=nanmean(bin_centres,1);
			depths=linspace(0,nanmax(bin_centres(:)),5);
			depths=0:300:1200;    
            months=6:12;
            jet=jet;
            ico=linspace(1,length(jet),length(months)); 
            figure('position',scrsz,'color',[1 1 1],'visible','on')
            for i=1:length(depths)-1
                [dif,locf]=nanmin(abs(bin_centresm-depths(i))); 
                [dif,loci]=nanmin(abs(bin_centresm-depths(i+1)));
                % montlhy averages
                timev=datevec(time);
                k=0;
                legs={};
                for month=months
                    k=k+1;
                    imonth=find(timev(:,2)==month);
                    if vert_avg
                        umean=nanmean(u(imonth,loci:locf),2);
                        vmean=nanmean(v(imonth,loci:locf),2);
                        [l1,l2,thetap]=principal_axes(umean,vmean);
                        legs=[legs,[num2str(month),', theta=',num2str((thetap*180)/pi,'%.f')]];
                        %[p]=polyfit(umean,vmean,1);
                        %up=[nanmin(umean)*3 nanmax(umean)*3]; vp=(p(1)*up)+p(2);
                        up=[-cos(thetap) cos(thetap)]; 
                        vp=[-sin(thetap) sin(thetap)]; 
                    else
                        umean=nanmean(u(imonth,loci:locf));%,2);
                        vmean=nanmean(v(imonth,loci:locf));%,2);
                    end

                    subplot(round(length(depths)/2)-1,round(length(depths)/2)-1,i); hold on
                    if month==months(1)
                        k=0;
                        for month=months
                            k=k+1;
                            plot(10,10,'.','markersize',12,'color',jet(round(ico(k)),:)); %colorbar; caxis([-.5 .5]); shading flat; colormap(rwb)
                        end
                        k=1;
                    end
                    set(gca,'fontsize',12,'fontweight','bold')
                    plot(umean,vmean,'.','markersize',12,'color',jet(round(ico(k)),:)); %colorbar; caxis([-.5 .5]); shading flat; colormap(rwb)
                    plot(up,vp,'linewidth',2,'color',jet(round(ico(k)),:)); %colorbar; caxis([-.5 .5]); shading flat; colormap(rwb)
                end
                if vert_avg
     	            title([{['M',num2str(m),' vert. avg vel. (',num2str(depths(i),'%.0f'),'-',num2str(depths(i+1),'%.0f'),'m),',]}])%,...
                         % {['l1=',num2str(l1),' ,l2=',num2str(l2),' ,theta=',num2str((thetap*180)/pi)]}])
                    plot([0 0],[-.5 .5],'k'); %colorbar; caxis([-.5 .5]); shading flat; colormap(rwb)
                    plot([-.5 .5],[0 0],'k'); %colorbar; caxis([-.5 .5]); shading flat; colormap(rwb)
                else
     	            title([{['M',num2str(m),' vert. avg vel. (',num2str(depths(i),'%.0f'),'-',num2str(depths(i+1),'%.2f'),'m)',]}])
                    plot([0 0],[-.2 .2],'k'); %colorbar; caxis([-.5 .5]); shading flat; colormap(rwb)
                    plot([-.2 .2],[0 0],'k'); %colorbar; caxis([-.5 .5]); shading flat; colormap(rwb)
                end
                %gregaxm(timej(:,1),1)
                grid
                ylim([-.5 .5])
                xlim([-.6 .6])
                axis equal
                legend('6','7','8','9','10','11','12')
                legend(legs)
            end

            if save_fig==1
                figname=['m',num2str(m)];
                if vert_avg
                figname=[figname,'-vertical_mean-currents-05-2015-05-2016_interp'];
                else
                figname=[figname,'-temporal_mean-currents-05-2015-05-2016_interp'];
                end
                figname=[path_fig,figname];
            	display(['Saving: ',figname])
            	export_fig(gcf,figname,'-png','-r300' );
            	%print('-dpng','-r300',figname)
            	%saveas(gcf,figname,'fig')
            end
            if close_fig==1
            	close
            end
        end % hodograph
       
    end % for m=
    
end % if proc_insitu==1


if calc_baroc_vel==1

  display(['Computing Baroclinic Geostrophic Velocities'])
  display(['AVG DATA'])
  display(['TS DATA'])
  for m=[mooring]%:length(moorings)

    dataname=[path_data,'m',num2str(m),'_ts_a_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
  	if exist(dataname,'file')~=2
        display(['File does not exist: ',dataname,', FILE DOES NOT EXIST! '])
    else
        display(['Loading: ',dataname])
        load([dataname])
        %save([dataname],'lon_obs','lonc_obs','latc_obs','depth_avg','t_avg','s_avg','time_avg')

        %if m==5 
        %  [dif inan]=nanmin(abs(depth_avg--900)); 
        %  t_avg(:,1:inan)=nan;
        %end

        depth_ts_sec=depth_avg; t=t_avg; s=s_avg;
        t_int=t;
        s_int=s;
        
        [dif,loci]=nanmin(abs(time_lima(1)-time_avg)); %loci=loci-2;
        [dif,locf]=nanmin(abs(time_lima(end)-time_avg)); %locf=locf+2;
        t_int=t_int(loci:locf,:);
        s_int=s_int(loci:locf,:);

        %return
        if m==mooring(1)
            t_obs=nan(length(depth_ts_sec),length(mooring),length(time_lima));
            s_obs=nan(length(depth_ts_sec),length(mooring),length(time_lima));
            %v_obs=nan(length(depth_obs),length(lon_obs),length(time_obs));
        end
        %if m==2;
        t_obs(:,m,:)=t_int';
        s_obs(:,m,:)=s_int';
        %else    
        %u_obs(:,locl,:)=u_int;    
        %end
    end
  end


  d_obs=gsw_rho(s_obs,t_obs,10.1325);
  lat_baroc=lat_obs(2:2:end); 
  u_baroc=nan(size(t_obs,1),length(lat_baroc),size(t_obs,3));

  for i=1:size(t_obs,2)
      p_obs(:,i)= depth_ts_sec'.*(-1); % rho_obs(:,length(fxbt)+1-ixbt).*9.8.*depth_xbt';
  end
  p_geo=flipud(p_obs(:,1:2)); 

  for i=1:size(t_obs,3) % time

    display(['Computing Baroc. Velocities on: ',datestr(time_avg(i))])

    for ii=2:size(t_obs,2)-1 % lon,lat, dist

      p_ref1=p_obs(find(~isnan(d_obs(:,ii,i))==1,1,'first'),ii);
      p_ref2=p_obs(find(~isnan(d_obs(:,ii+1,i))==1,1,'first'),ii+1);

      if ~isempty(p_ref1) & ~isempty(p_ref2)

        p_ref=nanmin([p_ref1,p_ref2,900]);
        s_geo=flipud(s_obs(:,ii:ii+1,i)); t_geo=flipud(t_obs(:,ii:ii+1,i)); 
        geo_strf = gsw_geo_strf_dyn_height(s_geo,t_geo,p_geo-10.1325,p_ref-10.1325);
        %geo_strf = gsw_geo_strf_dyn_height(s_geo,t_geo,p_geo,p_ref);
        [u_geo,~,~]=gsw_geostrophic_velocity(geo_strf,lonc_obs(ii:ii+1),latc_obs(ii:ii+1));

%return

        %d_geo=flipud(d_obs(:,ii:ii+1,i));
        %f=2.*7.292E-5.*sind(lat_baroc(ii)); 
        %u_geo=(9.8.*(d_geo(:,2)-d_geo(:,1)))./(f.*(disc_obs(ii+1)-disc_obs(ii)).*1000);
        %%u_geo=(9.8.*flipud(p_obs(:,ii:ii+1,i)).*(d_geo(:,2)-d_geo(:,1)))./(f.*(disc_obs(ii+1)-disc_obs(ii)).*1000);

        u_baroc(:,ii,i)=u_geo;
      end
    end
  end

  %[dif locxi]=nanmin(abs(lon_xbt-xlims(1))); temp_xbt(:,1:locxi+1)=nan;
  %[dif locxf]=nanmin(abs(lon_xbt-xlims(2))); temp_xbt(:,locxf:end)=nan;
  %locxi=locxi+2;
  %locxf=locxf-1;
  dataname=[path_data,'baroc_vel_a_data_',datestr(time_baroc(1),'yyyy-mm-dd'),'-to-',datestr(time_baroc(end),'yyyy-mm-dd'),'-gap',num2str(gap_interp),'.mat'];
  display(['Saving: ',dataname])
  save([dataname],'u_baroc','lat_baroc')

end % calc_baroc_vel


%if plot_map==0
%  bath_nc=[path_bath,file_bath];
%  lon_bath=double(ncread(bath_nc,'lon'));
%  lat_bath=double(ncread(bath_nc,'lat'));
%  bath=double(ncread(bath_nc,'height'));
%  [difs ilonb]=nanmin(abs(lon_bath-loni)); 
%  [difs flonb]=nanmin(abs(lon_bath-lonf)); 
%  [difs ilatb]=nanmin(abs(lat_bath-lati)); 
%  [difs flatb]=nanmin(abs(lat_bath-latf)); 
%  lon_bath=lon_bath(ilonb:flonb);
%  lat_bath=lat_bath(ilatb:flatb);
%  bath=bath(ilonb:flonb,ilatb:flatb);
%  [lon_bathm,lat_bathm]=meshgrid(lon_bath,lat_bath);
%end

%lon_bath_sec=linspace(lonc_obs(1),lonc_obs(end),100);%length(lon_bathm));
%lat_bath_sec=linspace(latc_obs(1),latc_obs(end),100);%length(lon_bathm));
%lon_bath_sec=lon_obs; lat_bath_sec=lat_obs;
%bath_sec=interp2(lon_bathm',lat_bathm',bath',lon_bath_sec,lat_bath_sec);
%dis_bath_sec(1)=0;
%for i=2:length(lon_bath_sec)
%  dis_bath_sec(i)=gsw_distance([lon_bath_sec(1) lon_bath_sec(i)],[lat_bath_sec(1) lat_bath_sec(i)])./1000; 
%end

rwb(1,:)=1;
display(['AVG DATA'])
display(['TS DATA'])
for m=[1:5]%:length(moorings)

    dataname=[path_data,'m',num2str(m),'_ts_a_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'.mat'];
	if exist(dataname,'file')~=2
      display(['File does not exist: ',dataname])
    else
      display(['Loading: ',dataname])
      load([dataname])
      %save([dataname],'lon_obs','lonc_obs','latc_obs','depth_avg','t_avg','s_avg','time_avg')

      if clean_data==1
        if m==4
          [~,inan]=nanmin(abs(depth_ts_sec--225));
          [~,inan]=nanmin(abs(depth_ts_sec--80));
          t_int(:,inan:end)=nan;
          s_int(:,inan:end)=nan;
        elseif m==5
          [~,inan]=nanmin(abs(depth_ts_sec--100));
          [~,inan]=nanmin(abs(depth_ts_sec--50));
          t_int(:,inan:end)=nan;
          s_int(:,inan:end)=nan;
        end
      end

      depth_ts_sec=depth_avg; t=t_avg; s=s_avg;
      t_int=t;
      s_int=s;
      %timej=julian(datevec(time));
      %for i=2:size(u,1)
      %    bin_centres(i,:)=bin_centres(1,:);
      %end


      %  dataname=[path_data,'m',num2str(m),'_proc_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'-rot',num2str(rot_vel),'.mat'];
      %display(['Loading: ',dataname])
      %load([dataname])
      [dif,loci]=nanmin(abs(time_lima(1)-time_avg)); %loci=loci-2;
      [dif,locf]=nanmin(abs(time_lima(end)-time_avg)); %locf=locf+2;
      t_int=t_int(loci:locf,:);
      s_int=s_int(loci:locf,:);
      %figure('position',scrsz,'color',[1 1 1],'visible','on')
      %set(gca,'fontsize',12,'fontweight','bold')
      %hold on; pcolor(time_obs,depth_obs,u_int); colorbar; caxis([-.5 .5]); shading flat; colormap(rwb)
	  %title(['U mooring ',num2str(m)])
      %return
      if m==mooring(1)
          t_obs=nan(length(depth_ts_sec),5,length(time_lima));
          s_obs=nan(length(depth_ts_sec),5,length(time_lima));
          %v_obs=nan(length(depth_obs),length(lon_obs),length(time_obs));
      end
      %if m==2;
      [dif,loci]=nanmin(abs(time_lima-time_avg(1))); %loci=loci-2;
      [dif,locf]=nanmin(abs(time_lima-time_avg(end))); %locf=locf+2;
      t_obs(:,m,loci:locf)=t_int';
      s_obs(:,m,loci:locf)=s_int';
      %time_obs_avg=time_avg(loci:locf); 
      %else    
      %u_obs(:,locl,:)=u_int;    
      %end


    end
end


display(['UV DATA'])
locla=[];
for m=[1:5]%:length(moorings)

    dataname=[path_data,'m',num2str(m),'_avg_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'-rot',num2str(0),'.mat'];
	if exist(dataname,'file')~=2
      display(['File does not exist: ',dataname])
    else
      display(['Loading: ',dataname])
      load([dataname])
      %save([dataname],'lon_obs','lonc_obs','latc_obs','depth_obs','u_int','time_obs')
      depth_uv_sec=depth_avg; u=u_avg; v=v_avg;
      [u,v]=rot2d(u,v,(90-ang_sec));

      if clean_data==1
        if m==4
          [~,inan]=nanmin(abs(depth_uv_sec--50));
          u(:,inan:end)=nan;
          v(:,inan:end)=nan;
        elseif m==5
          [~,inan]=nanmin(abs(depth_uv_sec--945));
          u(:,1:inan)=nan;
          v(:,1:inan)=nan;
        end
      end

      u_int=u;
      v_int=v;
      %timej=julian(datevec(time));
      %for i=2:size(u,1)
      %    bin_centres(i,:)=bin_centres(1,:);
      %end

      %  dataname=[path_data,'m',num2str(m),'_proc_data_',datestr(time_obs(1)),'-to-',datestr(time_obs(end)),'-gap',num2str(gap_interp),'-rot',num2str(rot_vel),'.mat'];
      %display(['Loading: ',dataname])
      %load([dataname])
      [dif,loci]=nanmin(abs(time_lima(1)-time_avg)); %loci=loci-2;
      [dif,locf]=nanmin(abs(time_lima(end)-time_avg)); %locf=locf+2;
      u_int=u_int(loci:locf,:);
      v_int=v_int(loci:locf,:);
      %figure('position',scrsz,'color',[1 1 1],'visible','on')
      %set(gca,'fontsize',12,'fontweight','bold')
      %hold on; pcolor(time_obs,depth_obs,u_int); colorbar; caxis([-.5 .5]); shading flat; colormap(rwb)
	  %title(['U mooring ',num2str(m)])
      %return
      if m==mooring(1)
          u_obs=nan(length(depth_uv_sec),length(dis_obs),length(time_lima));
          v_obs=nan(length(depth_uv_sec),length(dis_obs),length(time_lima));
      end
      [dif,locl]=nanmin(abs(disc_obs(m)-dis_obs)); 
      %if m==2;
      [dif,loci]=nanmin(abs(time_lima-time_avg(1))); %loci=loci-2;
      [dif,locf]=nanmin(abs(time_lima-time_avg(end))); %locf=locf+2;
      u_obs(:,locl,loci:locf)=u_int';
      v_obs(:,locl,loci:locf)=v_int';
      %time_obs_avg=time_avg(loci:locf); 
      %else    
      %u_obs(:,locl,:)=u_int;    
      %end
    end
    [dif,locl]=nanmin(abs(disc_obs(m)-dis_obs)); 
    locla=[locla,locl];
end

if calc_stats

    if plot_baroc_vel==1

      display(['Loading Baroclinic Geostrophic Velocities'])
      dataname=[path_data,'baroc_vel_a_data_',datestr(time_lima(1),'yyyy-mm-dd'),'-to-',datestr(time_lima(end),'yyyy-mm-dd'),'-gap',num2str(gap_interp),'.mat'];
      display(['Loading: ',dataname])
      load([dataname])%,'u_baroc','lat_baroc')

      depth_baroc_sec=flipud(depth_ts_sec');
      locdepf=find(depth_baroc_sec==depth_uv_sec(1));

      for i=1:size(u_baroc,2)
        [dif,loclat]=nanmin(abs(lat_baroc(i)-lat_obs)); 
        u_obs(:,loclat,:)=flipud(u_baroc(1:locdepf,i,1:time_lima(end)-time_lima(1)+1));
      end
    end


    clear lon_obs;  k=0;
    for i=1:length(lonc_obs)-1
      k=k+1;
      lon_obs(k)=lonc_obs(i);
      k=k+1;
      lon_obs(k)=(lonc_obs(i)+lonc_obs(i+1))./2;
    end
    k=k+1;
    lon_obs(k)=lonc_obs(length(lonc_obs));
    %depth_uv_sec=[depth_uv_sec,depth_uv_sec(end)+abs(depth_uv_sec(end)-depth_uv_sec(end-1))]; 

    % Loop in the expts
    for ex=1:length(expts)
      kkk=0;
      corak=0;

      expt=expts{ex};
      expt_name=expt_names{ex};
      path_dm=[path_data_mod,expt,'/'];

      jact=nan(length(time_lima),20);
      jnol=nan(length(time_lima),20);
      mh=nan(1,length(time_lima));
      mt=nan(1,length(time_lima));

      serie_mod_ssh=nan(1,length(time_lima));
      serie_obs_ssh=nan(1,length(time_lima));
      std_mod_ssh=nan(1,length(time_lima));
      std_obs_ssh=nan(1,length(time_lima));
      serie_corr_ssh=nan(1,length(time_lima));
      serie_rmsd_ssh=nan(1,length(time_lima));

      % forcing
      serie_hfb=nan(1,198);
      serie_hfa=nan(1,198);
      serie_wscb=nan(1,198);
      serie_wsca=nan(1,198);
      serie_wscmb=nan(1,198);
      serie_wscma=nan(1,198);
      serie_inc_t=nan(size(dep_mod,1),5,198);
 
      % boudaries
      t_obc=0; t_oba=0; t_obb=0; t_bac=0; t_ana=0; t_inc=0;
      u_obc=0; u_oba=0; u_obb=0; u_bac=0; u_ana=0; u_inc=0;
      v_obc=0; v_oba=0; v_obb=0; v_bac=0; v_ana=0; v_inc=0;
      w_ana=0; 
 
      % initial 
      t_bacs=[]; t_anas=[]; t_incs=[]; 
      w_anas=[];  
      obc_adj=0;

      serie_obs_div=nan(1,length(time_lima));

      serie_mod_sst=nan(1,length(time_lima));
      serie_bias_sst=nan(1,length(time_lima));
      serie_obs_sst=nan(1,length(time_lima));
      std_mod_sst=nan(1,length(time_lima));
      std_obs_sst=nan(1,length(time_lima));
      serie_corr_sst=nan(1,length(time_lima));
      serie_rmsd_sst=nan(1,length(time_lima));
      serie_mod_t=nan(size(dep_mod,1),5,length(time_lima));
      serie_mod_s=nan(size(dep_mod,1),5,length(time_lima));
      serie_mod_u=nan(size(dep_mod,1),5,length(time_lima));
      serie_mod_v=nan(size(dep_mod,1),5,length(time_lima));
 
      time_modcora=[];
      dept_modcora=[];
      t_modcora=[];
      s_modcora=[];

      map_mod_ssh_acum=nan(length(lon_aviso),length(lat_aviso),length(time_lima));
      map_obs_ssh_acum=nan(length(lon_aviso),length(lat_aviso),length(time_lima));
      map_mod_sst_acum=nan(length(lon_aviso),length(lat_aviso),length(time_lima));
      map_obs_sst_acum=nan(length(lon_aviso),length(lat_aviso),length(time_lima));

      map_mod_ssh_mean =nan(length(lon_aviso),length(lat_aviso));
      map_mod_ssh_std =nan(length(lon_aviso),length(lat_aviso));
      map_obs_ssh_mean =nan(length(lon_aviso),length(lat_aviso));
      map_obs_ssh_std =nan(length(lon_aviso),length(lat_aviso));
      map_corr_ssh=nan(length(lon_aviso),length(lat_aviso));
      map_rmsd_ssh=nan(length(lon_aviso),length(lat_aviso));
      map_mod_sst_mean =nan(length(lon_aviso),length(lat_aviso));
      map_mod_sst_std =nan(length(lon_aviso),length(lat_aviso));
      map_obs_sst_mean =nan(length(lon_aviso),length(lat_aviso));
      map_obs_sst_std =nan(length(lon_aviso),length(lat_aviso));
      map_corr_sst=nan(length(lon_aviso),length(lat_aviso));
      map_rmsd_sst=nan(length(lon_aviso),length(lat_aviso));

      % Loop in time

      if strncmp(expt,'as',2)==1
       ndays=2
      else
       ndays=str2num(expt(2));
      end
      %for iobs=1:length(time_avgll)-1:length(time_lima)-length(time_avgll)+1
      for iobs=1:ndays:length(time_lima)-length(time_avgll)+1
          display(['Run: ',num2str(runs(ex))])

          kkk=kkk+1; % counter to compute mean

          if plot_map==0 || plot_ser==0
            %figure('color',[1 1 1],'visible',visibility,'position',scrsz)
          end


          %display(['Averaging Velocities between ',datestr(time_lima(iobs)),' and ',datestr(time_lima(iobs+length(time_avgll)-2))])
          %umean=nanmean(squeeze(u_obs(:,:,iobs:iobs+length(time_avgll)-2)),3);
          %vmean=nanmean(squeeze(v_obs(:,:,iobs:iobs+length(time_avgll)-2)),3);
          %tmean=nanmean(squeeze(t_obs(:,:,iobs:iobs+length(time_avgll)-2)),3);
          %smean=nanmean(squeeze(s_obs(:,:,iobs:iobs+length(time_avgll)-2)),3);
          %[unotr,vnotr]=rot2d(umean(:,locla),vmean(:,locla),-(90-ang_sec));

          %if plot_map==1

	  	  %ROMS
            clear u_mods


            for i=iobs:iobs+length(time_avgll)-2


              if strncmp(expt,'free_',5)==1

                dn=(time_lima(1)-.5-datenum(start_time{ex},'yyyymmdd'));
                roms_nc=[path_mod,'/small_grid/',expt,'/','roms_avg_',num2str(i+dn,'%04d'),'.nc'];
                if exist(roms_nc)~=2
                  display(['FILE DOES NOT EXIST: ',roms_nc])
                  break;
                else

                  %roms_nc=[path_mod,'/small_grid/',expt,'/output/','roms_avg_0001_',num2str(i+dn,'%04d'),'.nc'];
                  display(['Loading ROMS: ',roms_nc])
                  time_mod=nanmean(ncread(roms_nc,'ocean_time'),1)./86400+datenum(1990,1,1);
                  display(['                                                                                                 ROMS time: ',datestr(time_mod,'yyyymmdd')])


                  display(['surface fluxes'])
                  hfa=double(nanmean(ncread(roms_nc,'shflux',[1 1 1],[Inf Inf Inf]),3))';
                  txa=double(nanmean(ncread(roms_nc,'sustr', [1 1 1],[Inf Inf Inf]),3))';
                  tya=double(nanmean(ncread(roms_nc,'svstr', [1 1 1],[Inf Inf Inf]),3))';

                  txa=u2rho_2d(txa).*grd.mask_rho;
                  tya=v2rho_2d(tya).*grd.mask_rho;

                  % wsc
                  dtxa=txa(2:end,:)-txa(1:end-1,:); % in y direction
                  dtya=tya(:,2:end)-tya(:,1:end-1); % in x direction

                  dtxa=v2rho_2d(dtxa)./dy_mod;
                  dtya=u2rho_2d(dtya)./dx_mod;

                  [txa,tya]=rot2d(txa,tya,(grd.angle.*(180/pi))); % normal x y system
                  wsca=dtya-dtxa;

                  txb=txa; tyb=tya; wscb=wsca; hfb=hfa;        

                  %z_mod=ncread(roms_nc,'zeta');
                  %u_mod=ncread(roms_nc,'u');
                  %v_mod=ncread(roms_nc,'v');
                  t_ana=ncread(roms_nc,'temp',[1 1 1 1],[Inf Inf Inf 1]);
                  t_bac=t_ana;
                  t_inc=t_ana-t_bac;
                  w_ana=ncread(roms_nc,'w',[1 1 1 1],[Inf Inf 30 Inf]);
                  %% moorings
                  %for m=[1 2 3 4 5]
                  %  t_mo=squeeze(ncread(roms_nc,'temp',[ilonm(m) ilatm(m) 1 1],[1 1 Inf Inf]));
                  %  %t_mo=interp1(dep_mod(:,ilatm(m),ilonm(m)),t_mo,-tdepth(m));
                  %  t_mod(:,m)=t_mo;
                  %  s_mo=squeeze(ncread(roms_nc,'salt',[ilonm(m) ilatm(m) 1 1],[1 1 Inf Inf]));
                  %  %s_mo=interp1(dep_mod(:,ilatm(m),ilonm(m)),s_mo,-tdepth(m));
                  %  s_mod(:,m)=s_mo;
                  %  utd_mod(:,m)=nanmean(ncread(roms_nc,'u',[ilonm(m) ilatm(m) 1 1],[1 1 Inf Inf]),4);
                  %  vtd_mod(:,m)=nanmean(ncread(roms_nc,'v',[ilonm(m) ilatm(m) 1 1],[1 1 Inf Inf]),4);
                  %end

                  %% profiles (Argo, ctd, xbt)
                  %for ii=1:length(cora_sufix1)
                  %  for iii=1:length(cora_sufix2)
                  %    corasave=[path_cora,path_out_cora,cora_prefix,datestr(time_lima(i),'yyyymmdd'),cora_sufix1{ii},cora_sufix2{iii},'.mat'];
                  %    if exist(corasave)==2
                  %      display(['CORAname: ',corasave])
                  %      corak=corak+1;
                  %      load(corasave)
                  %      t_mo=squeeze(ncread(roms_nc,'temp',[iloncs ilatcs 1 1],[1 1 Inf Inf]));
                  %      %t_mo=interp1(dep_mod(:,ilatm(m),ilonm(m)),t_mo,-tdepth(m));
                  %      t_modcora(:,corak)=t_mo;
                  %      s_mo=squeeze(ncread(roms_nc,'salt',[iloncs ilatcs 1 1],[1 1 Inf Inf]));
                  %      %s_mo=interp1(dep_mod(:,ilatm(m),ilonm(m)),s_mo,-tdepth(m));
                  %      s_modcora(:,corak)=s_mo;
                  %      time_modcora(:,corak)=time_mod;
                  %      dept_modcora(:,corak)=squeeze(dep_mod(:,ilatcs,iloncs));
                  %    end
                  %  end
                  %end

                  %%ubar_mod=ncread(roms_nc,'ubar');
                  %%vbar_mod=ncread(roms_nc,'vbar');
                  %ubar_mod=nanmean(u_mod(:,:,20),3);
                  %vbar_mod=nanmean(v_mod(:,:,20),3);

                end

              else

                if strncmp(expt,'a3',2)==1
                  modi=mod(i,3);
                  if modi==1; nn=[1 9]; n=round(i/3)+mod(i,3);
                  elseif modi==2; nn=[9 17]; n=round(i/3); 
                  elseif modi==0; nn=[17 25]; n=i/3;
                  end
                  dn=round((time_lima(1)-.5-datenum(start_time{ex},'yyyymmdd'))/3); 

                elseif strncmp(expt,'a4',2)==1
                  an=4; % window length
                  % n = number of the fwd file
                  modi=mod(i,an);
                  if modi==1; nn=[1 9]; n=round(i/an)+mod(i,an);
                  elseif modi==2; nn=[9 17]; n=round(i/an); 
                  elseif modi==3; nn=[17 25]; n=round(i/an);
                  elseif modi==0; nn=[25 33]; n=i/an;
                  end
                  dn=round((time_lima(1)-.5-datenum(start_time{ex},'yyyymmdd'))/an); % number of files that add to n 

                elseif strncmp(expt,'a7',2)==1
                  an=7; dan=1;
                  modi=mod(i,an);
                  if modi==1; nn=[1 9]; n=round(i/an)+mod(i,an); dan=0; 
                  elseif modi==2; nn= [9 17]; n=round(i/an); 
                  elseif modi==3; nn=[17 25]; n=round(i/an);
                  elseif modi==4; nn=[25 33]; n=round(i/an)-1;
                  elseif modi==5; nn=[33 41]; n=round(i/an)-1;
                  elseif modi==6; nn=[41 49]; n=round(i/an)-1;
                  elseif modi==0; nn=[49 57]; n=i/an; dan=0;
                  end
                  dn=round((time_lima(1)-.5-datenum(start_time{ex},'yyyymmdd'))/an)+dan; % number of files that add to n 

                else
                  if abs(mod(i,2))==1; n=i; nn=[1 9]; else; n=i-1; nn=[9 17]; end
                  n=round(i/2);
                  dn=round((time_lima(1)-.5-datenum(start_time{ex},'yyyymmdd'))/2); % difference between wanted time and model start time

                end
                %nn=[1 17];


                romb_nc=[path_mod,'/small_grid/',expt,'/','roms_fwd_',num2str(n+dn,'%04d'),'_000.nc'];
                roms_nc=[path_mod,'/small_grid/',expt,'/','roms_fwd_',num2str(n+dn,'%04d'),'_001.nc'];
                adjo_nc=[path_mod,'/small_grid/',expt,'/','roms_adj_',num2str(n+dn,'%04d'),'.nc'];
                rome_nc=[path_mod,'/small_grid/',expt,'/ocean_mod_',num2str(n+dn,'%04d'),'.nc'];

                if exist(roms_nc)~=2
                  display(['FILE DOES NOT EXIST: ',roms_nc])
                  break;
                else

                  display(['Loading ROMS: ',romb_nc])
                  time_mod=ncread(roms_nc,'ocean_time',[1],[Inf])./86400+datenum(1990,1,1);
                  %time_obc=ncread(adjo_nc,'ocean_time',[1],[Inf])./86400+datenum(1990,1,1);

                  %a2=17 a7 =57
                  %adj2=6 adj7=16

                  if length(time_mod)~=17 & length(time_mod)~=25 & length(time_mod)~=33 & length(time_mod)~=57
                    display(['FILE IS SHORT IN TIME: ',roms_nc,', FINAL DATE IS: ',datestr(time_mod(end))])
                    break;
                  else
                    display(['                                                                                                 ROMS time: ',datestr(nanmean(time_mod(nn(1):nn(2))),'yyyymmdd HH:MM')])

                    % 4dvar output
                    %Jact=ncread(rome_nc,'Jact')'./2;
                    %jact(iobs,:)=Jact(2:end);
                    %Jnol=ncread(rome_nc,'NL_fDataPenalty')'./2;
                    %jnol(iobs,1:length(Jnol))=Jnol;

                    %obs_type=ncread(rome_nc,'obs_type')';
                    %obs_error=ncread(rome_nc,'obs_error')';
                    %it=find(obs_type==1); mh(iobs)=nanmean(obs_error(it));
                    %it=find(obs_type==6); mt(iobs)=nanmean(obs_error(it));

                    % adoint output temp_obc(ocean_time, obc_adjust, boundary, s_rho, IorJ) % these positions are inversed;
                    %t_obc=nanmean(ncread(adjo_nc,'temp_obc',[1 1 1 1 length(time_obc)],[Inf Inf Inf 1 1]),4);
                    %u_obc=nanmean(ncread(adjo_nc,'u_obc'   ,[1 1 1 1 length(time_obc)],[Inf Inf Inf 1 1]),4);
                    %v_obc=nanmean(ncread(adjo_nc,'v_obc'   ,[1 1 1 1 length(time_obc)],[Inf Inf Inf 1 1]),4);

                    % lateral conditions (dont vary with ocean condition)
                    obc_adj=1;
                    display(['lateral conditions'])
                    % roms background output temp_obc(ocean_time, obc_adjust, boundary, s_rho, IorJ) % these positions are inversed;
                    t_obb=nanmean(ncread(romb_nc,'temp_obc',[1 1 1 1 nn(1)],[Inf Inf Inf 1 nn(2)-nn(1)+1]),5);
                    u_obb=nanmean(ncread(romb_nc,'u_obc'   ,[1 1 1 1 nn(1)],[Inf Inf Inf 1 nn(2)-nn(1)+1]),5);
                    v_obb=nanmean(ncread(romb_nc,'v_obc'   ,[1 1 1 1 nn(1)],[Inf Inf Inf 1 nn(2)-nn(1)+1]),5);
                    t_oba=nanmean(ncread(roms_nc,'temp_obc',[1 1 1 obc_adj nn(1)],[Inf Inf Inf 1 nn(2)-nn(1)+1]),5);
                    u_oba=nanmean(ncread(roms_nc,'u_obc'   ,[1 1 1 obc_adj nn(1)],[Inf Inf Inf 1 nn(2)-nn(1)+1]),5);
                    v_oba=nanmean(ncread(roms_nc,'v_obc'   ,[1 1 1 obc_adj nn(1)],[Inf Inf Inf 1 nn(2)-nn(1)+1]),5);
 
                    % boundary increment
                    t_obc=t_oba-t_obb;
                    u_obc=u_oba-u_obb;
                    v_obc=v_oba-v_obb;

                    % surface conditions (vary with ocean condition)
                    display(['surface fluxes'])
                    hfb=double(nanmean(ncread(romb_nc,'shflux',[1 1 nn(1)],[Inf Inf nn(2)-nn(1)+1]),3))';
                    hfa=double(nanmean(ncread(roms_nc,'shflux',[1 1 nn(1)],[Inf Inf nn(2)-nn(1)+1]),3))';

                    txb=double(nanmean(ncread(romb_nc,'sustr',[1 1 nn(1)],[Inf Inf nn(2)-nn(1)+1]),3))';
                    tyb=double(nanmean(ncread(romb_nc,'svstr',[1 1 nn(1)],[Inf Inf nn(2)-nn(1)+1]),3))';
                    txa=double(nanmean(ncread(roms_nc,'sustr',[1 1 nn(1)],[Inf Inf nn(2)-nn(1)+1]),3))';
                    tya=double(nanmean(ncread(roms_nc,'svstr',[1 1 nn(1)],[Inf Inf nn(2)-nn(1)+1]),3))';

                    txb=u2rho_2d(txb).*grd.mask_rho;
                    txa=u2rho_2d(txa).*grd.mask_rho;
                    tyb=v2rho_2d(tyb).*grd.mask_rho;
                    tya=v2rho_2d(tya).*grd.mask_rho;

                    % wsc
                    dtxb=txb(2:end,:)-txb(1:end-1,:); % in y direction
                    dtxa=txa(2:end,:)-txa(1:end-1,:); % in y direction
                    dtyb=tyb(:,2:end)-tyb(:,1:end-1); % in x direction
                    dtya=tya(:,2:end)-tya(:,1:end-1); % in x direction

                    dtxb=v2rho_2d(dtxb)./dy_mod;
                    dtxa=v2rho_2d(dtxa)./dy_mod;
                    dtyb=u2rho_2d(dtyb)./dx_mod;
                    dtya=u2rho_2d(dtya)./dx_mod;

                    [txb,tyb]=rot2d(txb,tyb,(grd.angle.*(180/pi))); % normal x y system
                    [txa,tya]=rot2d(txa,tya,(grd.angle.*(180/pi))); % normal x y system
                    wscb=dtyb-dtxb;
                    wsca=dtya-dtxa;

                    % initial conditions

                    display(['initial conditions'])
                    %z_mod=nanmean(ncread(roms_nc,'zeta',[1 1 nn(1)],[Inf Inf nn(2)-nn(1)+1]),3);
                    t_bac=ncread(romb_nc,'temp',[1 1 1 1],[Inf Inf Inf 1]);
                    t_ana=ncread(roms_nc,'temp',[1 1 1 1],[Inf Inf Inf 1]);
                    t_inc=t_ana-t_bac;
                    %w_mod=nanmean(ncread(roms_nc,'w',[1 1 20 nn(1)],[Inf Inf 1 nn(2)-nn(1)+1]),4);
                    w_ana=nanmean(ncread(roms_nc,'w',[1 1 1 1],[Inf Inf 30 Inf]),4);
                    for m=[1 2 3 4 5]
                      t_bc=squeeze(ncread(romb_nc,'temp',[ilonm(m) ilatm(m) 1 1],[1 1 Inf 1]));
                      t_an=squeeze(ncread(roms_nc,'temp',[ilonm(m) ilatm(m) 1 1],[1 1 Inf 1]));
                      %t_obs=nan(length(depth_ts_sec),5,length(time_lima));
                      %t_mo=interp1(dep_mod(:,ilatm(m),ilonm(m)),t_mo,-tdepth(m));
                      t_bcm(:,m)=t_bc;
                      t_anm(:,m)=t_an;
                      %s_mo=nanmean(squeeze(ncread(roms_nc,'salt',[ilonm(m) ilatm(m) 1 nn(1)],[1 1 Inf nn(2)-nn(1)+1])),2);
                      %%s_mo=interp1(dep_mod(:,ilatm(m),ilonm(m)),s_mo,-tdepth(m));
                      %s_mod(:,m)=s_mo;
                      %utd_mod(:,m)=nanmean(ncread(roms_nc,'u',[ilonm(m) ilatm(m) 1 nn(1)],[1 1 Inf nn(2)-nn(1)+1]),4);
                      %vtd_mod(:,m)=nanmean(ncread(roms_nc,'v',[ilonm(m) ilatm(m) 1 nn(1)],[1 1 Inf nn(2)-nn(1)+1]),4);
                    end
                    %%ubar_mod=nanmean(ncread(roms_nc,'ubar',[1 1 nn(1)],[Inf Inf nn(2)-nn(1)+1]),3);
                    %%vbar_mod=nanmean(ncread(roms_nc,'vbar',[1 1 nn(1)],[Inf Inf nn(2)-nn(1)+1]),3);
                    %ubar_mod=nanmean(u_mod(:,:,20),3);
                    %vbar_mod=nanmean(v_mod(:,:,20),3);

                  end

                end

              end

              if i==1 % iobs
                  expt
                  t_ob=t_obc; t_ba=t_oba; t_bb=t_obb; 
                  u_ob=u_obc; u_ba=u_oba; u_bb=u_obb; 
                  v_ob=v_obc; v_ba=v_oba; v_bb=v_obb; 

                  hfbb=hfb; hfaa=hfa; 
                  txbb=txb; txaa=txa; 
                  tybb=tyb; tyaa=txa; 
                  wscbb=wscb; wscaa=wsca; 

                  t_bacc=t_bac; t_anaa=t_ana; t_incc=t_inc; 
                  w_anaa=w_ana;  
              else
                  t_ob=t_ob+t_obc; t_ba=t_ba+t_oba; t_bb=t_bb+t_obb; 
                  u_ob=u_ob+u_obc; u_ba=u_ba+u_oba; u_bb=u_bb+u_obb; 
                  v_ob=v_ob+v_obc; v_ba=v_ba+v_oba; v_bb=v_bb+v_obb; 

                  hfbb =hfbb+ hfb; hfaa =hfaa+ hfa; 
                  txbb =txbb+ txb; txaa =txaa+ txa; 
                  tybb =tybb+ tyb; tyaa =tyaa+ txa; 
                  wscbb=wscbb+wscb; wscaa=wscaa+wsca; 

                  t_bacc=t_bacc+t_bac; t_anaa=t_anaa+t_ana; t_incc=t_incc+t_inc; 
                  w_anaa=w_anaa+w_ana;  
              end
             
            end
  
            serie_hfb(kkk)=nanmean(hfb(:));
            serie_hfa(kkk)=nanmean(hfa(:));
            serie_wscb(kkk)=nanmean(wscb(:));
            serie_wsca(kkk)=nanmean(wsca(:));
            serie_wscmb(kkk)=nanmean(nanmean(wscb(70:111,89:107)));
            serie_wscma(kkk)=nanmean(nanmean(wsca(70:111,89:107)));

            if ~strncmp(expt,'free_',5)
              serie_inc_t(:,:,kkk)=t_anm(:,:)-t_bcm(:,:);
            end

            if exist(roms_nc)~=2
              display(['FILE DOES NOT EXIST: ',roms_nc])
              break;
            end 
            if (length(time_mod)~=17 & length(time_mod)~=25 & length(time_mod)~=33 & length(time_mod)~=57) & strncmp(expt,'free_',5)~=1
              display(['FILE IS SHORT IN TIME: ',roms_nc,', FINAL DATE IS: ',datestr(time_mod(end))])
              break;
            end

            %ubar_mod=v2rho_2d(ubar_mod);
            %vbar_mod=u2rho_2d(vbar_mod);
            %ubar_modnr=ubar_mod; vbar_modnr=vbar_mod; % grid x y system
            %[ubar_mod,vbar_mod]=rot2d(ubar_mod,vbar_mod,(grd.angle.*(180/pi))'); % normal x y system
            %[utd_mod,vtd_mod]=rot2d(utd_mod,vtd_mod,(grd.angle(1,1).*(180/pi))'); % normal x y system
            %[utd_mod,vtd_mod]=rot2d(utd_mod,vtd_mod,(90-ang_sec)); % along slope direction

            if exist(roms_nc)~=2
              display(['FILE DOES NOT EXIST: ',roms_nc])
              break;
            end
            if length(time_mod)~=17 & length(time_mod)~=25 & length(time_mod)~=33 & length(time_mod)~=57 & strncmp(expt,'free_',5)~=1
              display(['FILE IS SHORT IN TIME: ',roms_nc,', FINAL DATE IS: ',datestr(time_mod(end))])
              break;
            end

      end % iobs=1:length(time_avgll)-1:length(time_lima)-length(time_avgll)+1

      %kkk ~= (length(time_lima)-length(time_avgll)+1);

      % bnd
      t_obc=t_ob./(kkk); 
      t_oba=t_ba./(kkk);
      t_obb=t_bb./(kkk);

      % surf
      hfb=hfbb./(kkk);
      hfa=hfaa./(kkk);
      txb=txbb./(kkk);
      txa=txaa./(kkk);
      tyb=tybb./(kkk);
      tya=tyaa./(kkk);
      wscb=wscbb./(kkk);
      wsca=wscaa./(kkk);

      % ini
      t_bac=t_bacc./(kkk);
      t_ana=t_anaa./(kkk);
      t_inc=t_incc; %./(kkk);
      w_ana=w_anaa./(kkk); 

      % computing zonal velocities for the section
      for i=1:size(dep_mod,1)
        %u_mo=v2rho_2d(squeeze(u_mod(:,:,i)));
        %v_mo=u2rho_2d(squeeze(v_mod(:,:,i)));
        %[u_mo,v_mo]=rot2d(u_mo,v_mo,grd.angle(1,1)*180/pi); % normal x y system
        %[u_mo,v_mo]=rot2d(u_mo,v_mo,(90-ang_sec)); % along slope direction
        %u_mods(i,:)=griddata(lon_mod,lat_mod,u_mo',lon_modo,lat_modo);
        t_bacs(i,:)=griddata(lon_mod,lat_mod,t_bac(:,:,i)',lon_modo,lat_modo);
        t_anas(i,:)=griddata(lon_mod,lat_mod,t_ana(:,:,i)',lon_modo,lat_modo);
        t_incs(i,:)=griddata(lon_mod,lat_mod,t_inc(:,:,i)',lon_modo,lat_modo);
        w_anas(i,:)=griddata(lon_mod,lat_mod,w_ana(:,:,i)',lon_modo,lat_modo);
      end
      %w_ana=w_ana(:,:,15); % saving layer, rather than 3D

      fname=['series-forc-inc-',datestr(time_lima(1),'yyyymmdd'),'-',datestr(time_lima(end),'yyyymmdd'),'.mat'];
      fname=[path_dm,fname];
      
      if save_data
        display(['Saving: ',fname])
        save(fname,'time_lima','kkk','obc_adj',...
                   't_obc','u_obc','v_obc',... 
                   't_oba','u_oba','v_oba',...
                   't_obb','u_obb','v_obb',...
                   't_bacs','t_anas','t_incs',...
                   't_bac','t_ana','t_inc',...
                   'w_ana','w_anas',...
                   'hfb','hfa',...
                   'txb','tyb','wscb',...
                   'txa','tya','wsca',...
                   'serie_inc_t',...
                   'serie_hfb','serie_hfa',... 
                   'serie_wscb','serie_wsca',... 
                   'serie_wscmb','serie_wscma') 

      end
      %print('-dpng','-r300',figname)
      %saveas(gcf,figname,'fig')

    end % for ex=1:length(expts)

end % calc_stats



if plot_map

  load rwb.mat

  % Loop in the variables
  for vari=1:length(variablem)

    varib=variablem{vari};

    figure('position',scrsz,'color',[1 1 1],'visible','on');  hold on;
    % Loop in the expts
    lege={};

    exx=0;
    for ex=1:length(expts)
      exx=exx+1;

      expt=expts{ex};
      expt_name=expt_names{ex};
      path_dm=[path_data_mod,expt,'/'];

      fname=['series-forc-inc-',datestr(time_lima(1),'yyyymmdd'),'-',datestr(time_lima(end),'yyyymmdd'),'.mat'];
      fname=[path_dm,fname];
      display(['Loading: ',fname])
      load(fname)

      subp =[
      1 2 3 10 11 12 19 20 21;
      4 5 6 13 14 15 22 23 24;
      7 8 9 16 17 18 25 26 27;
      28 29 30 37 38 39 46 47 48;
      31 32 33 40 41 42 49 50 51;
      34 35 36 43 44 45 52 53 54];

      ax(exx)=subplot(6,9,subp(ex,:));


      sadd=mod(length(expts),2);
      %%if strcmp(varib(end),'i') % length(expts)<=2
      %%  ax(exx)=subplot(2,round((length(expts)+1)/2),exx); hold on 
      %%else % length(expts)>2

        %ax(exx)=subplot(2,round((length(expts))/2),exx); 

        hold on 
        %%subplot(round(length(expts)/2)-sadd,round(length(expts)/2)-0,ex); hold on 
        %%ax(exx)=subplot(1,2,exx); hold on 
      %%end

      set(gca,'fontsize',18,'fontweight','bold')

      fdx=20; fdy=20; fstd=1;


      if strcmp(varib,'map_mod_sst_bias')
        model=map_mod_sst_mean-map_obs_sst_mean;
      elseif strcmp(varib,'hfi')

        if strncmp(expt,'free_',5)
          model=hfb;
        else
          model=hfa-hfb;
        end

        colormap(ax(exx),gwb)
        %colormap(ax(exx),cmocean('delta'))
        caxis([-50 50])
        tname='increment Heat flux';
        lon_p=lon_mod; lat_p=lat_mod;

        %m_proj('Equidistant Cylindrical','long',[172.875 178.875],'lat',[-37.625 -33.625]);
        m_proj('Equidistant Cylindrical','long',[173 lonf],'lat',[-38 latf]);

        m_pcolor(lon_p,lat_p,model)
        m_contour(lon_mod,lat_mod,h_mod,[-1000 -200],'k','linewidth',2)

      elseif strcmp(varib,'hfa') || strcmp(varib,'hfb')
        eval(['model=',strcat(varib,';')])
        colormap(ax(exx),gwb)
        caxis([-1e2 1e2])
        if strcmp(varib,'hfa')
          tname='analysis Heat flux';
        elseif strcmp(varib,'hfb')
          tname='background Heat flux';
        end
        pcolor(lon_p,lat_p,model)
        contour(lon_mod,lat_mod,h_mod,[-1000 -200],'k','linewidth',2)

      elseif strcmp(varib,'wsci')
        model=wsca-wscb;
        fdx=10; fdy=10; fstd=1;
        %gauss = fspecial('gaussian',[fdx fdy],fstd); % [dx & dy] & std max
        gauss = fspecial('average',[4 4]); % [dx & dy] & std max
        model= imfilter(model,gauss,'replicate');
        %model=griddata(lon_mod,lat_mod,model,lon_avisom,lat_avisom);
        %lon_mod=lon_avisom; lat_mod=lat_avisom;
        colormap(ax(exx),cmocean('curl'))
        caxis([-5e-7 5e-7])
        tname='increment WSC';
        umod=txa; vmod=txa;
        %umod=griddata(lon_mod,lat_mod,umod,lon_avisom,lat_avisom);
        %vmod=griddata(lon_mod,lat_mod,vmod,lon_avisom,lat_avisom);
        lon_p=lon_mod; lat_p=lat_mod;
        pcolor(lon_p,lat_p,model)
        quiver(lon_mod(3:v_spam:end,3:v_spam:end),lat_mod(3:v_spam:end,3:v_spam:end),umod(3:v_spam:end,3:v_spam:end),vmod(3:v_spam:end,3:v_spam:end),'k')
        contour(lon_mod,lat_mod,h_mod,[-1000 -200],'k','linewidth',2)

      elseif strcmp(varib,'wsca') || strcmp(varib,'wscb')
        eval(['model=',strcat(varib,';')])
        model=griddata(lon_mod,lat_mod,model,lon_avisom,lat_avisom);
        %gauss = fspecial('average',[4 4]); % [dx & dy] & std max
        %model= imfilter(model,gauss,'replicate');
        if strcmp(varib,'wsca')
          colormap(ax(exx),rwb)
          caxis([-1e-6 1e-6])
          tname='analysis WSC';
        elseif strcmp(varib,'wscb')
          colormap(ax(exx),rwb)
          caxis([-10e-7 10e-7])
          tname='background WSC';
        end

        if strcmp(varib,'wscb')
          umod=txb; vmod=txb;
        elseif strcmp(varib,'wsca')
          umod=txa; vmod=txa;
        end
        umod=griddata(lon_mod,lat_mod,umod,lon_avisom,lat_avisom);
        vmod=griddata(lon_mod,lat_mod,vmod,lon_avisom,lat_avisom);
        lon_p=lon_avisom; lat_p=lat_avisom;
        pcolor(lon_p,lat_p,model)
        quiver(lon_p,lat_p,umod,vmod,'k')
        contour(lon_mod,lat_mod,h_mod,[-1000 -200],'k','linewidth',2)

      elseif strncmp(varib,'w_ana',5) 
        model=w_ana;
        if strcmp(varib,'w_anad') 
          clear modelo
          for i=1:size(model,3); modelo(i,:,:)=model(:,:,i)'; end
          [model,~,~] = roms_zslice_var(modelo,time_lima,depthp,grd);
        else
          model=squeeze(model(:,:,layerp))';
        end
        gauss = fspecial('average',[10 10]); % [dx & dy] & std max
        model= imfilter(model,gauss,'replicate');
        pcolor(lon_mod,lat_mod,model)
        contour(lon_mod,lat_mod,h_mod,[-1000 -200],'k','linewidth',2)
        wsca=griddata(lon_mod,lat_mod,wsca,lon_avisom,lat_avisom);
        z_contour=wsca; lon_contour=lon_avisom; lat_contour=lat_avisom;

        % wsc maybe yellow and black
        %%[cs,h]=contour(lon_contour,lat_contour,z_contour,[0:3e-7:1e-6],'color','m','linewidth',2);
        %%clabel(cs,h,'color',[1 0 1],'fontsize',8,'fontweight','bold','LabelSpacing',2000)
        [cs,h]=contour(lon_contour,lat_contour,z_contour,[-1e-6:3e-7:0],'color','g','linewidth',2);
        clabel(cs,h,'color',[0 1 0],'fontsize',8,'fontweight','bold','LabelSpacing',2000)
        [cs,h]=contour(lon_contour,lat_contour,z_contour,[0 0],'color','w','linewidth',2);
        clabel(cs,h,'color',[1 1 1],'fontsize',8,'fontweight','bold','LabelSpacing',2000)

        caxis([-1e-5 1e-5])
        %caxis([-1e-4 1e-4])
        colormap(ax(exx),flipud(rwb))
        if strcmp(varib,'w_anad') 
          tname=['w-ana depth=',num2str(depthp)];
        else
          tname=['w-ana layer=',num2str(layerp)];
        end

      elseif strcmp(varib,'t_inc')
        eval(['model=',strcat(varib,';')])
        model=squeeze(model(:,:,layerp))';
        model=model./(kkk);
        pcolor(lon_mod,lat_mod,model)
        caxis([-.1 .1])
        colormap(ax(exx),rwb)
        tname=['t-inc level=',num2str(layerp)];
        contour(lon_mod,lat_mod,h_mod,[-1000 -200],'k','linewidth',2)

      elseif strcmp(varib,'t_incd')
        eval(['model=t_inc',';'])
        model=model./(kkk);
        clear modelo
        for i=1:size(model,3); modelo(i,:,:)=model(:,:,i)'; end
        [model,~,~] = roms_zslice_var(modelo,time_lima,depthp,grd);
        pcolor(lon_mod,lat_mod,model)

        eval(['model=t_inc',';'])
        model=model./(kkk);
        clear modelo
        for i=1:size(model,3); modelo(i,:,:)=model(:,:,i)'; end
        [model,~,~] = roms_zslice_var(modelo,time_lima,100,grd);
         model(inan200mod)=nan;
        [cs,h]=contour(lon_mod,lat_mod,model,[0 0]      ,'g','linewidth',2);
        clabel(cs,h,'color',[0 0 0],'fontsize',8,'fontweight','bold','LabelSpacing',2000)
        [cs,h]=contour(lon_mod,lat_mod,model,[-.01 -.01],'b','linewidth',2);
        clabel(cs,h,'color',[0 0 0],'fontsize',8,'fontweight','bold','LabelSpacing',2000)
        [cs,h]=contour(lon_mod,lat_mod,model,[.01 .01]  ,'r','linewidth',2);
        clabel(cs,h,'color',[0 0 0],'fontsize',8,'fontweight','bold','LabelSpacing',2000)

        tname=['t-inc depth=',num2str(depthp)];
        caxis([-.08 .08])
        colormap(ax(exx),rwb)
        [cs,h]=contour(lon_mod,lat_mod,h_mod,[-1000 -200],'k','linewidth',2);
        clabel(cs,h,'color',[0 0 0],'fontsize',10,'fontweight','bold','LabelSpacing',2000)


      else
        eval(['model=',strcat(varib,';')])
        tname=replace([varib],'_','-');
        pcolor(lon_mod,lat_mod,model)
      end


      if strncmp(expt,'free_',5) 
        tname=replace(tname,'analysis ','');
        tname=replace(tname,'increment ','');
      end

      %contourf(lon_p,lat_p,model)
      shading flat

      m_gshhs_i('patch',[.7 .7 .7],'edgecolor','k','linewidth',.5);
      ii=ex;
      if ii==1 %|| ii==3
        %m_grid('xtick',[],'xticklabels',[],'fontname','helvetica','fontsize',14,'fontweight','bold');
        m_grid('xtick',[round(172.875):2:round(178.875)],'xticklabels',[],'fontname','helvetica','fontsize',18,'fontweight','bold');
      elseif ii==2 || ii==3
        m_grid('xtick',[round(172.875):2:round(178.875)],'xticklabels',[],'yticklabels',[],'fontname','helvetica','fontsize',18,'fontweight','bold');
      elseif ii==4
        %m_grid('fontname','helvetica','fontsize',14,'fontweight','bold');
        m_grid('xtick',[round(172.875):2:round(178.875)],'xticklabels',[round(172.875):2:round(178.875)],'fontname','helvetica','fontsize',18,'fontweight','bold');
      elseif ii==6 || ii==5
        %m_grid('ytick',[],'yticklabels',[],'fontname','helvetica','fontsize',14,'fontweight','bold');
        m_grid('xtick',[round(172.875):2:round(178.875)],'xticklabels',[round(172.875):2:round(178.875)],'yticklabels',[],'fontname','helvetica','fontsize',18,'fontweight','bold');
      end

      lt={'(a)','(b)','(c)','(d)','(e)','(f)'};
      title([lt{ex},' ',expt_name,': heat flux increment'],'fontsize',16,'fontweight','bold')% ,tname,' - mean=',num2str(nanmean(model(:)),'%.3f')]) 
      if ii==6
        title([lt{ex},' ',expt_name,': mean heat flux'],'fontsize',16,'fontweight','bold')% ,tname,' - mean=',num2str(nanmean(model(:)),'%.3f')]) 
        HCB=colorbar;
        set(HCB,'position',[0.915 0.10975 0.0125661375661376 0.8152]) % [left bottom width height]
        set(get(HCB,'ylabel'),'string','Surface heat flux increment (W/m^2)','fontsize',18,'fontweight','bold');
        %set(HCB,'ylabel','string','Along-slope velocity (m/s)','fontsize',fsize,'fontweight','bold');
      end

      %title([expt_name,' - ',tname,' - mean=',num2str(nanmean(model(:)),'%.3f')]) 
      m_plot(lonc_obs,latc_obs,'color',[.7 .7 .7],'linewidth',2) 
      m_plot(lonc_obs,latc_obs,'.','color',[.7 .7 .7],'markersize',14) 
      %lege=[lege,{[expt_name,' = ',num2str(nanmean(mod),'%.3f')]}];


      %if ex==1
        if strncmp(varib,'map_corr',8) 
           caxis([-1 1])
           colormap(rwb)
        elseif strcmp(varib,'map_rmsd_ssh')
           title([replace([expt_name,' - '],'_','-'),'rmsd=',num2str(nanmean(model(:)),'%.3f')]) 
           [cs,h]=contour(lon_aviso,lat_aviso,model','k');
           clabel(cs,h,'color',[0 0 0],'fontsize',10,'fontweight','bold','LabelSpacing',2000)
           caxis([0 .15])
           colormap(ax(exx),avhrr)
           %colormap(cmocean('ice'))
           %colormap(ax(exx),cmocean('matter'))
        elseif strcmp(varib,'map_rmsd_sst')
           title([replace([expt_name,' - '],'_','-'),'rmsd=',num2str(nanmean(model(:)),'%.3f')]) 
           [cs,h]=contour(lon_aviso,lat_aviso,model',[.3 .4 .5 .6:.2:3],'w');
           clabel(cs,h,'color',[1 1 1],'fontsize',10,'fontweight','bold','LabelSpacing',2000)
           caxis([0 0.5])
           colormap(ax(exx),cmocean('matter'))
           %caxis([0.2 2])
           %colormap('default')
        elseif strcmp(varib,'map_mod_sst_bias')
           title([replace([expt_name,' - '],'_','-'),'mean=',num2str(nanmean(model(:)),'%.3f')]) 
           %[cs,h]=contour(lon_aviso,lat_aviso,model',[.3 .4 .5 .6:.2:3],'w');
           %clabel(cs,h,'color',[1 1 1],'fontsize',10,'fontweight','bold','LabelSpacing',2000)
           caxis([-1 1])
           colormap(ax(exx),rwb)
           %caxis([0.2 2])
           %colormap('default')
        else
           %colormap(jet)
        end
      %end
      axis('equal')

    end % for ex=1:length(expts)


    fname=['series-forc-inc-',datestr(time_lima(1),'yyyymmdd'),'-',datestr(time_lima(end),'yyyymmdd'),'.mat'];
    fname=[path_dm,fname];
    %print('-dpng','-r300',figname)
    %saveas(gcf,figname,'fig')
    path_fig=['/scale_wlg_nobackup/filesets/nobackup/niwa00020/santanarc/figures/hikurangi/paper_2/'];
    figname=[path_fig,'','ch3_fig10_map_heat_inc','.png'];

    save_fig=1
    if save_fig==1

      display(['Saving: ',figname]);
      export_fig(gcf,figname,'-png','-r150' );
      %print('-dpng','-r300',figname)
      %saveas(gcf,figname,'fig')
      %clf('reset')
      %set(gcf,'color',[1 1 1])
    end



  end % for vari=1:length(variables)

  



end % if plot_map


