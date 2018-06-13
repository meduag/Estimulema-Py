clc
clear 
close all
 
%% load
 
% accel
load 'acel_c.txt'
 
accel_t0 = 1e-6 * acel_c(1,1); % in [s]
accel_N = length(acel_c(:,1)); 
accel_tf =1e-6 * acel_c(accel_N,1); % in [s]
 
accel_Ts = (accel_tf - accel_t0) / accel_N; % in [s]
accel_fs = 1/accel_Ts;
accel_t = (accel_t0+accel_Ts:accel_Ts:accel_tf);
 
accel_x_bits = acel_c(:,2); 
accel_y_bits = acel_c(:,3);
accel_z_bits = acel_c(:,4);
 
% stim_c
load 'stim_c.txt'
 
stim_c_t0 = 1e-6 * stim_c(1,3);
stim_c_lastLine = length(stim_c(:,3));
stim_c_tf = 1e-6 * stim_c(stim_c_lastLine,3);
 
stim_c_t = (stim_c_t0+accel_Ts:accel_Ts:stim_c_tf);
stim_c_N = length(stim_c_t);
 
accelstim_c_delay = stim_c_N - accel_N;
stim_c_t = stim_c_t(accelstim_c_delay+1:stim_c_N);
stim_c_N = length(stim_c_t);
 
accelstim_c_startdelay = stim_c_t(1) - accel_t(1);
 
stim_c_i = acel_c(:,5);
 
%% convert accel
 
 
%% build stim_c
 
stim_c_pulse_counter = 1;
thisstim_c = 0;
thisvalue = 0;
 
for k = 1:accel_N
     
    if (acel_c(k,5) - thisstim_c) > .5
        % new pulse found!
        thisvalue = mean( stim_c((6*stim_c_pulse_counter) - 6 + 2:(6*stim_c_pulse_counter) + 1 , 2));
        thisstim_c = 1;
        stim_c_pulse_counter = stim_c_pulse_counter + 1;
    elseif (thisstim_c - acel_c(k,5)) > .5
        thisstim_c = 0;
    end
     
    stim_c_i (k) = stim_c_i (k) *  thisvalue;
     
end
 
%% plot
 
figure;
subplot(211); 
plot(accel_t,accel_x_bits,'r'); 
hold on; plot(accel_t,accel_y_bits,'b'); 
plot(accel_t,accel_z_bits,'g'); 
axis([accel_t0 accel_tf -20000 20000])

subplot(212); plot(accel_t,stim_c_i);
axis([accel_t0 accel_tf 0 5])