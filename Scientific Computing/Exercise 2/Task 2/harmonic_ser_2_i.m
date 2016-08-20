function [] = harmonic_ser_2_i

crit = true;
new_value = 0;
prev_value = 0; 
n = 1;

while crit 
    new_value = prev_value + 1/n;
    if abs(new_value - prev_value) == 0
        crit = false;
    end
    prev_value = new_value;
    n = n + 1;
end

