
%--- Initiate channel for read and write ----
% communication with the DAQ card / hardware communication is established
% in this section
%-------------------------------------------------------------------------
ai=analoginput('nidaq','dev1');
addchannel(ai,2:3);
ao=analogoutput('nidaq','dev1');  
addchannel(ao,0);
%-------------------------------------------------------------------------
set(ai,'Samplerate',1000)         %defines 'length' of each measurement
set(ai,'SamplesPerTrigger',500)   %number of measuremnets that go in a 
                                  %single measuring point after averaging


set(ai.Channel(1), 'InputRange', [-0.05 0.05] )
set(ai.Channel(2), 'InputRange', [-10 10] )
%-------------------------------------------------------------------------


% --- Set system parameters ----
% this is a part to be modified once Ho, T1 and T2 are found
% from previous Troom/sample, step and pulse measurements

%T1=1.076;
%T2=395;
%H0=11.629;

% --- Calculate closed-loop parameters ---
%P=(1/3)*((T1+T2)^2)/(T1*T2)-1;
%I=(1/27)*((T1+T2)^3)/((T1*T2)^2);
%Kp=P/H0
%Ki=I/H0
Kp=1;
Ki=0.02;

%-------------------------------------------------------------------------
% --- Set reference temperature ---
Treference=25;


% --- iniialize variables ---
samples=2400*6;   %takes approx 0.5sec per measurement


%zero inititation can be removed but then all data in workspace 
%has to be cleared on consecutive runs 
%otherwise the length of the vector conforms to the longest of the runs
Tref=zeros(1,samples);
T=zeros(1,samples);
V=zeros(1,samples);
cm=zeros(1,samples);
TI=0;

reftime=clock;
sfigure(60); %Silent version of figure
hold on;

%measurements start here
for i=1:samples   % samples=# of measurements-defines length of experiments

    
  %--- Start sampling ---
   start(ai)                    %starts sampling
   v_in=getdata(ai);
   v_in_ave=mean(v_in);
   temp=clock;
   c=etime(temp,reftime);
    
   %--- Calculate resitance in both thermistors t1 and t2 ----
   R1=1598400;
   
   V=v_in_ave(2);
   r_T=v_in_ave(1).*R1./(V-v_in_ave(1));
  
   
   %--- Calculate temperature ----
   A0=0.00128285;
   A1=0.000236664;
   A2=8.99037e-8;
   
   T1=1./(A0+log(r_T).*(A1+A2.*(log(r_T)).^2));

  
   %--- Store Temperature and time ---
   
   T(i)=T1';
   cm(i)=c';
   
   Tref(i)=Treference+273.15;
%-------------------------------------------------------------------------

   %--- Calculate the excitation ---
%    if i>1
%       Terr=Tref(i)-T(i);
%       TI=TI+Terr*(cm(i)-cm(i-1));
%    else
%       TI=0;
%    end    
%    E=Kp*(Tref(i)-T1)+Ki*TI;
%    Em(i)=E;

E=0;
  
   %limiter: power supply gives off I proportional to V fed to it
   % the power supply is calibrated and in the range [-4,4] I=const.*V
   
%    if E<-4 E=-4;
%    end
%    if E>4 E=4;
%    end
%-------------------------------------------------------------------------   
   %--- Write data to Peltier element ---
   putdata(ao,[E])
   
   start(ao) 
%-------------------------------------------------------------------------   
   %--- Show data in window ---
   [i,c,Tref(i)-273.15,T(i)-273.15,E]
%-------------------------------------------------------------------------   
   %--- Reset read and write processes ---
   stop([ai ao])  
   plot(c,T1,'.r')
   drawnow;
   hold on;
   save temp_check_after_step_task4.mat cm T V Tref
end    
%-------------------------------------------------------------------------
%--- Reset daq-card ---
%if aborted during measurements this piece of code does not get executed
%in case the code is aborted always run reset_pid command from 
%command window

putdata(ao,[0])
start(ao)
stop(ao)
daqreset