clc
clear 
close all
 
%% load
 
% accel
load 'acel_r.txt'
 
accel_t0 = 1e-6 * acel_r(1,1); % in [s]
accel_N = length(acel_r(:,1)); 
accel_tf =1e-6 * acel_r(accel_N,1); % in [s]
 
accel_Ts = (accel_tf - accel_t0) / accel_N; % in [s]
accel_fs = 1/accel_Ts;
accel_t = (accel_t0+accel_Ts:accel_Ts:accel_tf);
 
accel_x_bits = acel_r(:,2); 
accel_y_bits = acel_r(:,3);
accel_z_bits = acel_r(:,4);
 
% stim_r
load 'stim_r.txt'
 
stim_r_t0 = 1e-6 * stim_r(1,3);
stim_r_lastLine = length(stim_r(:,3));
stim_r_tf = 1e-6 * stim_r(stim_r_lastLine,3);
 
stim_r_t = (stim_r_t0+accel_Ts:accel_Ts:stim_r_tf);
stim_r_N = length(stim_r_t);
 
accelstim_r_delay = stim_r_N - accel_N;
stim_r_t = stim_r_t(accelstim_r_delay+1:stim_r_N);
stim_r_N = length(stim_r_t);
 
accelstim_r_startdelay = stim_r_t(1) - accel_t(1);
 
stim_r_i = acel_r(:,5);
 
%% convert accel
 
 
%% build stim_r
 
stim_r_pulse_counter = 1;
thisstim_r = 0;
thisvalue = 0;
 
for k = 1:accel_N
     
    if (acel_r(k,5) - thisstim_r) > .5
        % new pulse found!
        thisvalue = mean( stim_r((6*stim_r_pulse_counter) - 6 + 2:(6*stim_r_pulse_counter) + 1 , 2));
        thisstim_r = 1;
        stim_r_pulse_counter = stim_r_pulse_counter + 1;
    elseif (thisstim_r - acel_r(k,5)) > .5
        thisstim_r = 0;
    end
     
    stim_r_i (k) = stim_r_i (k) *  thisvalue;
     
end
 
%% plot
 
figure;
subplot(211); 
plot(accel_t,accel_x_bits,'r'); 
hold on; plot(accel_t,accel_y_bits,'b'); 
plot(accel_t,accel_z_bits,'g'); 
axis([accel_t0 accel_tf -20000 20000])

subplot(212); plot(accel_t,stim_r_i);
axis([accel_t0 accel_tf 0 5])