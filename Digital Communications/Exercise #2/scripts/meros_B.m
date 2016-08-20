function [ ideal_BER , nonideal_BER ] = meros_B(  )
%meros_B :: SIMULATION OF 2-PAM

%script for excercise 2.B: 
%~~~~~~~~~~~~~~~~~~~~~~~~~~ SIMULATION OF 2-PAM ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Given parameters:
a = 0.3;           %roll-off factor
T = 6;             %sampling period width centralized around 0 (T=6Ts=6)
rate = 4;          %over-sampling rate
SNR = (0:2:30);    %SNR values for which calculations will be made
numval = 10^5;     %number of input values
s = [-1 ; 1];      %alphabet of 2-PAM (source symbols)

%1-D random input source of equal probable symbols (-1 , +1) for 2-PAM:
src = randsrc(numval,1,s');

%Initialization of system ouputs; each column contains a vector of the
%output values for different given input SNRs.
%Each matrix is simulation of ideal and non-ideal channels:
ideal_output = zeros(length(src),length(SNR));
nonideal_output = zeros(length(src),length(SNR));
ideal_BER = zeros(length(SNR),1);
nonideal_BER = zeros(length(SNR),1);

%Source signal transmitted through the system for different values of SNR:
for i = 1 : 1 : length(SNR)
    ideal_output(:,i) = modulation(src, rate, a, T, 'y', SNR(1,i), s);
    nonideal_output(:,i) = modulation(src, rate, a, T, 'n', SNR(1,i), s);
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~ CONVERSION TO BINARY ~~~~~~~~~~~~~~~~~~~~~~~~~~
%for each element in source input and channel's outputs convert symbols to
%binary digits as follows:
% -1 --> 0
% +1 --> 1
for i = 1 : 1 : length(src)
    %source's conversion to 1s and 0s:
    if(src(i,1) == -1)
        src(i,1) = 0;
    elseif(src(i,1) ~= 1)
        error('ERROR: value out of permitted for source!');
    end
    %channels' concersions to 1s and 0s:
    for j = 1 : 1 : length(SNR)
        if(ideal_output(i,j) == -1)
            ideal_output(i,j) = 0;
        elseif(ideal_output(i,j) ~= 1)
            error('ERROR: value out of permitted for ideal output!');
        end
        if(nonideal_output(i,j) == -1)
            nonideal_output(i,j) = 0;
        elseif(nonideal_output(i,j) ~= 1)
            error('ERROR: value out of permitted for nonideal output!');
        end
    end
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BIT ERROR RATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Calculation of BER:
for i = 1 : 1 : length(SNR)
    ideal_BER(i,1) = sum(xor(ideal_output(:,i),src)) / length(src);
    nonideal_BER(i,1) = sum(xor(nonideal_output(:,i),src)) / length(src);
end
%Graphical representation of BER:
figure;
semilogy(SNR , ideal_BER , 'b');
hold on;
semilogy(SNR , nonideal_BER , 'k');
title('Bit Error Rate for 2-PAM in SNR 0:2:30');
legend('ideal channel' , 'nonideal channel' , 'Location' , 'SouthEast');
hold off;

end