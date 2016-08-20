function [ out ] = meros_A( in, rate, ro_factor, T, ideal, SNR_db, s )
%meros_A: Modulation of input signal through system containing a filter
%for transmission, a channel with additive white gaussian noise, a filter
%in receiver, a sampler and a decision device.
%   ~ Inputs:
%   in:        input signal
%   rate:      the rate in which the signal is upsampled
%   ro_factor: the roll-off factor for raised cosine function
%   T:         transmission period
%   ideal:     'y' for ideal channel, 'n' for nonideal channel
%   SNR_db:    SNR in decibels (can be given as vector)
%   s:         the alphabet of the source

%~~~~~~~~~~~~~~~~~~~~~~ INPUT | UPSAMPLING ~~~~~~~~~~~~~~~~~~~~~
%---upsample input according to rate:
signal_up = upsample(in,rate);
%remove last nonusable '0s'
signal_up = signal_up(1:length(signal_up)-rate+1);

%~~~~~~~~~~~~~~~~~~~~~~ TRANSMITTER | FILTER ~~~~~~~~~~~~~~~~~~~
%---transmitter's filter (Ts = 1sec)
f = rcosfir(ro_factor , [-T/2 , T/2] , rate , 1 , 'sqrt');
%normalization of filter so that norm(f) = 1
f = f./norm(f);
%---signal is passed through the filter (convolution):
TF_sig = conv(f , signal_up);

%~~~~~~~~~~~~~~~~~~~~~ CHANNEL | FILTER ~~~~~~~~~~~~~~~~~~~~~~~~
%---check if channel is ideal or not; 
%if it isn't, add the channel's upsampled response
if (ideal == 'n')
    %non-ideal channel's impulse response is given as:
    h = [0.01 , 0.04 , -0.05 , 0.06 , -0.22 , -0.5 , ...
         0.72 , 0.36 , 0 , 0.21 , 0.04 , 0.08 , 0.02];
    h_up = upsample(h,rate);
    %remove extra '0s'
    h_up = h_up(1:length(h_up)-rate+1);
    %convolution with signal
    C_sig = conv(TF_sig , h_up);
elseif (ideal == 'y')
    C_sig = TF_sig;
end

%~~~~~~~~~~~~~~~~~~~~~ CHANNEL | NOISE ~~~~~~~~~~~~~~~~~~~~~~~~~
%---additive AWGN noise:
%calculate average power of channeled signal:
absC_sig = abs(C_sig);
Ps = sum(absC_sig.^2) / length(C_sig);
%calculate average power of channel's noise based on given SNR|db:
Pn = Ps / (10^(SNR_db/10));
%calculate noise based on Pn which is the square of noise's deviation:
noiserand = randn(length(C_sig),1);
%if the constellation is complex, noise must be added in both imaginary and
%real parts:
if(isreal(C_sig) == 0)
    noiserand = (noiserand + 1j*randn(length(C_sig),1)) / sqrt(2);
end
noise = sqrt(Pn) * noiserand;
%---channel's output with added noise:
CAWGN_sig = C_sig + noise;

%~~~~~~~~~~~~~~~~~~~~~~ RECEIVER | FILTER ~~~~~~~~~~~~~~~~~~~~~~
%---receiver's filter is the same as transmitter's:
RF_sig = conv(f , CAWGN_sig);

%~~~~~~~~~~~~~~~~~~~ RECEIVER | DOWNSAMPLING ~~~~~~~~~~~~~~~~~~~~
%---calculate delay according to channel's type to be excluded from 
%incoming signal:
if (ideal == 'n')
    %displacement:
    delay = 2*floor(length(f)/2) + floor(length(h_up)/2);
elseif (ideal == 'y')
    delay = 2*floor(length(f)/2);
end
%downsample signal:
S_sig = RF_sig(delay+1 : rate : length(RF_sig) - delay);

%~~~~~~~~~~~~~~~~~~~~~ RECEIVER | DECISION ~~~~~~~~~~~~~~~~~~~~~
out = zeros(length(S_sig),1);
D = zeros(length(s),1);
%for each element of the signal vector, decide by minimum square distance
%to which value of the alphabet it is closer:
for i = 1 : 1 : length(S_sig)
    for j = 1 : 1 : length(s)
        D(j,1) = (S_sig(i,1) - s(j,1))^2;
    end
    for k = 1 : 1 : length(D)
        if(D(k,1) == min(D))
            out(i,1) = s(k,1);
        end
    end
end

end