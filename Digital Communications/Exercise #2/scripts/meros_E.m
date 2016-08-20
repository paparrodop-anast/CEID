function [  ] = meros_E(  )
%meros_E :: COMPARISON OF PERFOMANCES

%script for excercise 2.E:
%~~~~~~~~~~~~~~~~~~~~~~~ COMPARISON OF PERFOMANCES ~~~~~~~~~~~~~~~~~~~~~~~~
SNR = (0:2:30);
[ PAM2_ideal_BER , PAM2_nonideal_BER ] = meros_B;
[ PAM4_ideal_BER , PAM4_nonideal_BER ] = meros_C;
[ QAM4_ideal_BER , QAM4_nonideal_BER ] = meros_D;

figure;
semilogy(SNR, PAM2_ideal_BER , 'b.-');
hold on;
semilogy(SNR, PAM2_nonideal_BER, 'k.-');
hold on;
semilogy(SNR, PAM4_ideal_BER , 'gx-');
hold on;
semilogy(SNR, PAM4_nonideal_BER, 'cx-');
hold on;
semilogy(SNR, QAM4_ideal_BER , 'ro-');
hold on;
semilogy(SNR, QAM4_nonideal_BER, 'yo-');
title('Bit Error Rate for SNR 0:2:30');
legend('2PAM,ideal' , '2PAM,nonideal' , '4PAM,ideal' , '4PAM,nonideal', ...
       '4QAM,ideal' , '4QAM,nonideal' , 'Location', 'SouthEast');
hold off;

end

