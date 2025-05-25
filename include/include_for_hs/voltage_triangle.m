function [waveform] = voltage_triangle(amp, period, polarity)
    step = 0.01;
    start_time = 0;
    stop_time = period;

    time = (start_time : step : stop_time);

    voltage_up = amp/(period / 2)*time;
    voltage_up = voltage_up(1:round(length(time)/2));
    voltage_down = -amp/(period / 2)*time + 2*amp;
    voltage_down = voltage_down(length(voltage_up)+1:length(time));
    voltage_array = [polarity*voltage_up polarity*voltage_down];

    waveform.voltage = [polarity*voltage_up polarity*voltage_down];
    waveform.time = time;

    




end
