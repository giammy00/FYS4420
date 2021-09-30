%finding T1 and T2

%we have values for H0 , DeltaE (pulse) , epsilon , r_p, t_p

H_0 = 8.52;%kelvin per volt
DeltaE = 3.2; %volts
epsilon = 24.6810; %seconds
rp = 1.416 ;%kelvin
tp = 79; %seconds

%here we plot a the function f(T12) to have an idea about suitable intervals 
%containing the solutions of our equation
f = @(T12) DeltaE*H_0*exp(-tp./T12).*(exp(epsilon./T12) - 1 );
x = 0:0.001:800;
y = f(x);
figure();
fplot( f, [0, 800]);

%set up a reasonable interval containing T1
a = 0.1;
b = 60;
%numerical solution of f(T1) = rp
while abs(f(a)-f(b))>0.00001 %setting up a tolerance
    if f((a+b)/2)>rp
        b = (a+b)/2;
    else
        a = (a+b)/2;
    end
end
disp('T1')
disp([a,b]);
T1 = (a+b)/2;
%finding now T2, in the same way as above

a = 300;
b = 500;

while abs(f(a)-f(b))>0.00001
    if f((a+b)/2)<rp
        b = (a+b)/2;
    else
        a = (a+b)/2;
    end
end
disp('T2');
disp([a, b]);
T2 = (a+b)/2;

drdT = @(T12) H_0*DeltaE*exp(-tp/T12)*( (tp/T12^2)*(exp(epsilon/T12)-1)-(epsilon/T12^2)*exp(epsilon/T12));
drp = 0.006;
dT1 = (1/drdT(T1))*drp
dT2 =  (1/drdT(T2))*drp
