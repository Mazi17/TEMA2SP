%Numar de ordine = 15
%Semnal Dreptunghiular
%Perioada P = 40 s
%Durata semnalelor D (sec) = 15
%Numar de coeficienti N = 50

P = 40;
D = 15;
N = 50;
W = 2*pi / P;   %Pulsatia unghiulara a semnalului dreptunghiular

pas = P / 100;  
t = (-2 * P) : pas : (2 * P);     %Pasul de esantionare

coefSFC = zeros(1,N);   %Initializarea vectorului de coeficienti SFC
coefSFA = zeros(1,N);   %Initializarea vectorului de coeficienti SFA

x = square( W * t, D); %Semnalul initial
x_init = @(t,k) square( W * t, D).*exp( -1j * k * W * t); %Semnal descompus in SFC
x_reconstr = 0;    %Initializarea semnalului reconstruit
coefxk = (1 / P) * integral(@(t) x_init(t,0),0,P);   %Coeficientii Xk ai semnalului


for k = 1:50   %k - indicele termenilor 
    coefSFC(k) = (1 / P) * integral(@(t) x_init(t,k - 25 ),0,P);   %Coeficientii Xk ai semnalului
    x_reconstr = x_reconstr + coefSFC(k) * exp( 1j * (k - 25) * W * t);  %Alcatuirea semnalului cu ajutorul coeficientilor 
end                                                                               

figure(1);      %Reprezentarea semnalului dreptunghiular initial si reconstruit
subplot(2,1,1);
plot(t, x_reconstr, t, x,'r');
title('Semnalul dreptunghiular inital si reconstruit');
legend('semnal reconstruit','semnal initial');
hold on;

coefSFA(1) = abs(coefxk);   %Coeficientii SFA - amplitudiniile din spectru
for k = 1:N
      coefSFA(k+1) = 2 * abs(coefSFC(k)); 
end

subplot(2,1,2);
stem([0:N] * W, coefSFA,'b'); 
title('Spectrul semnalului dreptunghiular');

%Prin folosirea unui numar finit de termeni(N=50) semnalul reconstruit pe baza
%spectrului se apropie de cel initial avand insa o marja de eroare.