function [ ideal_BER , nonideal_BER ] = meros_D(  )
%meros_D :: SIMULATION OF 4-QAM

%script for excercise 2.D: 
%~~~~~~~~~~~~~~~~~~~~~~~~~~ SIMULATION OF 4-QAM ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Given parameters:
a = 0.3;           %roll-off factor
T = 6;             %sampling period width centralized around 0 (T = 6Ts)
rate = 4;          %over-sampling rate
SNR = (0:2:30);    %SNR values for which calculations will be made
numval = 10^5;     %number of input values
%alphabet of 4-QAM:
s = [(-1-1j)/sqrt(2); (-1+1j)/sqrt(2); (1-1j)/sqrt(2); (1+1j)/sqrt(2)];

%1-D random input source of equal probable symbols ((-1-1j)/sqrt(2); 
% (-1+1j)/sqrt(2); (1-1j)/sqrt(2); (1+1j)/sqrt(2)) for 4-QAM:
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
% (-1-j)/sqrt(2) --> 00
% (-1+j)/sqrt(2) --> 01
%  (1-j)/sqrt(2) --> 10
%  (1+j)/sqrt(2) --> 11
source = zeros(length(src)*2,1);             %extra to store source's bits
ideal = zeros(length(src)*2,length(SNR));    %extra for ideal chan. bits
nonideal = zeros(length(src)*2,length(SNR)); %extra for nonideal chan. bits
for i = 1 : 1 : length(src)
    %source's conversion to 1s and 0s:
    if(src(i,1) == (-1-1j)/sqrt(2))
        source(i,1) = 0;
        source(i+1,1) = 0;
    elseif(src(i,1) == (-1+1j)/sqrt(2))
        source(i,1) = 0;
        source(i+1,1) = 1;
    elseif(src(i,1) == (1-1j)/sqrt(2))
        source(i,1) = 1;
        source(i+1,1) = 0;
    elseif(src(i,1) == (1+1j)/sqrt(2))
        source(i,1) = 1;
        source(i+1,1) = 1;
    else
        error('ERROR: value out of permitted for source!');
    end
    %channels' concersions to 1s and 0s:
    for j = 1 : 1 : length(SNR)
        if(ideal_output(i,j) == (-1-1j)/sqrt(2))
            ideal(i,j) = 0;
            ideal(i+1,j) = 0;
        elseif(ideal_output(i,j) == (-1+1j)/sqrt(2))
            ideal(i,j) = 0;
            ideal(i+1,j) = 1;
        elseif(ideal_output(i,j) == (1-1j)/sqrt(2))
            ideal(i,j) = 1;
            ideal(i+1,j) = 0;
        elseif(ideal_output(i,j) == (1+1j)/sqrt(2))
            ideal(i,j) = 1;
            ideal(i+1,j) = 1;
        else
            error('ERROR: value out of permitted for ideal output!');
        end
        
        if(nonideal_output(i,j) == (-1-1j)/sqrt(2))
            nonideal(i,j) = 0;
            nonideal(i+1,j) = 0;
        elseif(nonideal_output(i,j) == (-1+1j)/sqrt(2))
            nonideal(i,j) = 0;
            nonideal(i+1,j) = 1;
        elseif(nonideal_output(i,j) == (1-1j)/sqrt(2))
            nonideal(i,j) = 1;
            nonideal(i+1,j) = 0;
        elseif(nonideal_output(i,j) == (1+1j)/sqrt(2))
            nonideal(i,j) = 1;
            nonideal(i+1,j) = 1;
        else
            error('ERROR: value out of permitted for nonideal output!');
        end
    end
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BIT ERROR RATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Calculation of BER (Bit Error Rate):
for i = 1 : 1 : length(SNR)
    ideal_BER(i,1) = sum(xor(ideal(:,i),source)) / length(source);
    nonideal_BER(i,1) = sum(xor(nonideal(:,i),source)) / length(source);
end
%Graphical representation of BER:
figure;
semilogy(SNR , ideal_BER , 'r');
hold on;
semilogy(SNR , nonideal_BER , 'y');
title('Bit Error Rate for 4-QAM in SNR 0:2:30');
legend('ideal channel' , 'nonideal channel' , 'Location' , 'SouthEast');
hold off;

end

