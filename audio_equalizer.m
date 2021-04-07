% PROGRAMA

clc;
close all;

%% Sinal de Entrada no Tempo

filename = 'resources/Blind_intro.wav';

[signal,Fs] = audioread(filename);
signalLength = length(signal);

fprintf('\nFrequência de amostragem do sinal (Fs): %i\n', Fs);

maxTime = length(signal)/Fs;
timeVector = 0: maxTime / signalLength: maxTime - maxTime / signalLength;

figure();
plot(timeVector,signal);
title('Sinal original');
xlabel('Tempo (s)');
ylabel('Amplitude');
axis([0, 8.5, -1.5, 1.5]);
print('-clipboard','-dbitmap');

%% Espectro de Frequências do Sinal de Áudio

Xw_signal = fftshift(fft(signal./signalLength));
freqVector = linspace(-Fs/2, Fs/2, signalLength);

figure();
subplot(2, 1, 1);
plot(freqVector, abs(Xw_signal(:,1)));
title('Espectro de frequência do sinal');
ylabel('Magnitude');
xlabel('Frequência [Hz]');
axis([-22.05E3, 22.05E3, 0, 15E-3]);
subplot(2, 1, 2);
plot(freqVector, unwrap(angle(Xw_signal(:,1))));
ylabel('Fase');
xlabel('Frequência [Hz]');
axis([-22.05E3, 22.05E3, -0.1E4, 3.1E4]);
print('-clipboard','-dbitmap');

%% Parâmetros do Banco de Filtros

Rp = 0.5;
Rs = 40;
delta_freq_low = 10;
delta_freq_high = 100;

%% Filtro de Subgraves [16~60]Hz

fp_16_60 = [16, 60]; % Frequências da banda passante em Hz
fs_16_60 = [fp_16_60(1) - delta_freq_low, fp_16_60(2) + delta_freq_low]; % Frequências da faixa de corte em Hz
gain_16_60 = 0; % Ganho em dB do Filtro (-40~6.02)dB;

bpFilt_16_60 = designfilt(...
                    'bandpassiir', 'DesignMethod', 'cheby1',...
                    'StopbandFrequency1', fs_16_60(1),...
                    'StopbandFrequency2', fs_16_60(2),...
                    'StopbandAttenuation1', Rs,...
                    'StopbandAttenuation2', Rs,...
                    'PassbandFrequency1', fp_16_60(1),...
                    'PassbandFrequency2', fp_16_60(2),...
                    'PassbandRipple', Rp,...
                    'SampleRate', Fs);

[num_16_60, den_16_60] = tf(bpFilt_16_60);
Hz_16_60 = tf(num_16_60, den_16_60, 1 / Fs);
display(Hz_16_60);

fvtool(bpFilt_16_60, 'FrequencyScale', 'log');

filtered_16_60 = filter(bpFilt_16_60, signal);

figure();
subplot(2, 1, 1);
plot(timeVector, filtered_16_60);
axis([0, 8.5, -1, 1]);
title('Filtro de Subgraves [16~60]Hz');
xlabel('Tempo (s)');
ylabel('Amplitude');
subplot(2, 1, 2);
title('Sinal original');
plot(timeVector,signal);
axis([0, 8.5, -1, 1]);
xlabel('Tempo (s)');
ylabel('Amplitude');
print('-clipboard','-dbitmap');

%sound(filtered_16_60, Fs);

%% Filtro de Graves [60~250]Hz

fp_60_250 = [60, 250]; % Frequências da banda passante em Hz
fs_60_250 = [fp_60_250(1) - delta_freq_low, fp_60_250(2) + delta_freq_high]; % Frequências da faixa de corte em Hz
gain_60_250 = 0; % Ganho em dB do Filtro (-40~6.02)dB;

bpFilt_60_250 = designfilt(...
                    'bandpassiir', 'DesignMethod', 'cheby1',...
                    'StopbandFrequency1', fs_60_250(1),...
                    'StopbandFrequency2', fs_60_250(2),...
                    'StopbandAttenuation1', Rs,...
                    'StopbandAttenuation2', Rs,...
                    'PassbandFrequency1', fp_60_250(1),...
                    'PassbandFrequency2', fp_60_250(2),...
                    'PassbandRipple', Rp,...
                    'SampleRate', Fs);
                
[num_60_250, den_60_250] = tf(bpFilt_60_250);
Hz_60_250 = tf(num_60_250, den_60_250, 1 / Fs);
display(Hz_60_250);

fvtool(bpFilt_60_250, 'FrequencyScale', 'log');

filtered_60_250 = filter(bpFilt_60_250, signal);

figure();
subplot(2, 1, 1);
plot(timeVector, filtered_60_250);
axis([0.5, 8.5, -1, 1]);
title('Filtro de Graves [60~250]Hz');
xlabel('Tempo (s)');
ylabel('Amplitude');
subplot(2, 1, 2);
title('Sinal original');
plot(timeVector,signal);
axis([0.5, 8.5, -1, 1]);
xlabel('Tempo (s)');
ylabel('Amplitude');
print('-clipboard','-dbitmap');

%sound(filtered_60_250, Fs);

%% Filtro de Médio-graves [250~2000Hz]

fp_250_2k = [250, 2000]; % Frequências da banda passante em Hz
fs_250_2k = [fp_250_2k(1) - delta_freq_high, fp_250_2k(2) + delta_freq_high]; % Frequências da faixa de corte em Hz
gain_250_2k = 0; % Ganho em dB do Filtro (-40~6.02)dB;

bpFilt_250_2k = designfilt(...
                    'bandpassiir', 'DesignMethod', 'cheby1',...
                    'StopbandFrequency1', fs_250_2k(1),...
                    'StopbandFrequency2', fs_250_2k(2),...
                    'StopbandAttenuation1', Rs,...
                    'StopbandAttenuation2', Rs,...
                    'PassbandFrequency1', fp_250_2k(1),...
                    'PassbandFrequency2', fp_250_2k(2),...
                    'PassbandRipple', Rp,...
                    'SampleRate', Fs);
                
[num_250_2k, den_250_2k] = tf(bpFilt_250_2k);
Hz_250_2k = tf(num_250_2k, den_250_2k, 1 / Fs);
display(Hz_250_2k);

fvtool(bpFilt_250_2k, 'FrequencyScale', 'log');

filtered_250_2k = filter(bpFilt_250_2k, signal);

figure();
subplot(2, 1, 1);
plot(timeVector, filtered_250_2k);
axis([0, 8.5, -1, 1]);
title('Filtro de Médio-graves [250~2000Hz]');
xlabel('Tempo (s)');
ylabel('Amplitude');
subplot(2, 1, 2);
title('Sinal original');
plot(timeVector,signal);
axis([0, 8.5, -1, 1]);
xlabel('Tempo (s)');
ylabel('Amplitude');
print('-clipboard','-dbitmap');

%sound(filtered_250_2k, Fs);

%% Filtro de Médio-agudos [2000~4000Hz]

fp_2k_4k = [2000, 4000]; % Frequências da banda passante em Hz
fs_2k_4k = [fp_2k_4k(1) - delta_freq_high, fp_2k_4k(2) + delta_freq_high]; % Frequências da faixa de corte em Hz
gain_2k_4k = 0; % Ganho em dB do Filtro (-40~6.02)dB;

bpFilt_2k_4k = designfilt(...
                    'bandpassiir', 'DesignMethod', 'cheby1',...
                    'StopbandFrequency1', fs_2k_4k(1),...
                    'StopbandFrequency2', fs_2k_4k(2),...
                    'StopbandAttenuation1', Rs,...
                    'StopbandAttenuation2', Rs,...
                    'PassbandFrequency1', fp_2k_4k(1),...
                    'PassbandFrequency2', fp_2k_4k(2),...
                    'PassbandRipple', Rp,...
                    'SampleRate', Fs);
                
[num_2k_4k, den_2k_4k] = tf(bpFilt_2k_4k);
Hz_2k_4k = tf(num_2k_4k, den_2k_4k, 1 / Fs);
display(Hz_2k_4k);

fvtool(bpFilt_2k_4k, 'FrequencyScale', 'log');

filtered_2k_4k = filter(bpFilt_2k_4k, signal);

figure();
subplot(2, 1, 1);
plot(timeVector, filtered_2k_4k);
axis([0, 8.5, -1, 1]);
title('Filtro de Médio-agudos [2000~4000Hz]');
xlabel('Tempo (s)');
ylabel('Amplitude');
subplot(2, 1, 2);
title('Sinal original');
plot(timeVector,signal);
axis([0, 8.5, -1, 1]);
xlabel('Tempo (s)');
ylabel('Amplitude');
print('-clipboard','-dbitmap');

%sound(filtered_2k_4k, Fs);

%% Filtro de Agudos [4000~6000Hz]

fp_4k_6k = [4000, 6000]; % Frequências da banda passante em Hz
fs_4k_6k = [fp_4k_6k(1) - delta_freq_high, fp_4k_6k(2) + delta_freq_high]; % Frequências da faixa de corte em Hz
gain_4k_6k = 0; % Ganho em dB do Filtro (-40~6.02)dB;

bpFilt_4k_6k = designfilt(...
                    'bandpassiir', 'DesignMethod', 'cheby1',...
                    'StopbandFrequency1', fs_4k_6k(1),...
                    'StopbandFrequency2', fs_4k_6k(2),...
                    'StopbandAttenuation1', Rs,...
                    'StopbandAttenuation2', Rs,...
                    'PassbandFrequency1', fp_4k_6k(1),...
                    'PassbandFrequency2', fp_4k_6k(2),...
                    'PassbandRipple', Rp,...
                    'SampleRate', Fs);
                
[num_4k_6k, den_4k_6k] = tf(bpFilt_4k_6k);
Hz_4k_6k = tf(num_4k_6k, den_4k_6k, 1 / Fs);
display(Hz_4k_6k);

fvtool(bpFilt_4k_6k, 'FrequencyScale', 'log');

filtered_4k_6k = filter(bpFilt_4k_6k, signal);

figure();
subplot(2, 1, 1);
plot(timeVector, filtered_4k_6k);
axis([0, 8.5, -1, 1]);
title('Filtro de Agudos [4000~6000Hz]');
xlabel('Tempo (s)');
ylabel('Amplitude');
subplot(2, 1, 2);
title('Sinal original');
plot(timeVector,signal);
axis([0, 8.5, -1, 1]);
xlabel('Tempo (s)');
ylabel('Amplitude');
print('-clipboard','-dbitmap');

%sound(filtered_4k_6k, Fs);

%% Filtro de Brilho [6000~16000Hz]

fp_6k_16k = [6000, 16000]; % Frequências da banda passante em Hz
fs_6k_16k = [fp_6k_16k(1) - delta_freq_high, fp_6k_16k(2) + delta_freq_high]; % Frequências da faixa de corte em Hz
gain_6k_16k = 0; % Ganho em dB do Filtro (-40~6.02)dB;

bpFilt_6k_16k = designfilt(...
                    'bandpassiir', 'DesignMethod', 'cheby1',...
                    'StopbandFrequency1', fs_6k_16k(1),...
                    'StopbandFrequency2', fs_6k_16k(2),...
                    'StopbandAttenuation1', Rs,...
                    'StopbandAttenuation2', Rs,...
                    'PassbandFrequency1', fp_6k_16k(1),...
                    'PassbandFrequency2', fp_6k_16k(2),...
                    'PassbandRipple', Rp,...
                    'SampleRate', Fs);
                
[num_6k_16k, den_6k_16k] = tf(bpFilt_6k_16k);
Hz_6k_16k = tf(num_6k_16k, den_6k_16k, 1 / Fs);
display(Hz_6k_16k);
                
fvtool(bpFilt_6k_16k, 'FrequencyScale', 'log');

filtered_6k_16k = filter(bpFilt_6k_16k, signal);

figure();
subplot(2, 1, 1);
plot(timeVector, filtered_6k_16k);
axis([0, 8.5, -1, 1]);
title('Filtro de Brilho [6000~16000Hz]');
xlabel('Tempo (s)');
ylabel('Amplitude');
subplot(2, 1, 2);
title('Sinal original');
plot(timeVector,signal);
axis([0, 8.5, -1, 1]);
xlabel('Tempo (s)');
ylabel('Amplitude');
print('-clipboard','-dbitmap');

%sound(filtered_6k_16k, Fs);

%% Reconstrução do Sinal Filtrado e Ajuste de Ganho

k_16_60 = 1; % Pode variar entre 0.1 (-40dB) até 2 (6.02dB). 1 representa um ganho de 0dB
k_60_250 = 1; % Pode variar entre 0.1 (-40dB) até 2 (6.02dB). 1 representa um ganho de 0dB
k_250_2k = 1; % Pode variar entre 0.1 (-40dB) até 2 (6.02dB). 1 representa um ganho de 0dB
k_2k_4k = 1; % Pode variar entre 0.1 (-40dB) até 2 (6.02dB). 1 representa um ganho de 0dB
k_4k_6k = 1; % Pode variar entre 0.1 (-40dB) até 2 (6.02dB). 1 representa um ganho de 0dB
k_6k_16k = 1; % Pode variar entre 0.1 (-40dB) até 2 (6.02dB). 1 representa um ganho de 0dB

filtered_signal = 0;
filtered_signal = filtered_signal + filtered_16_60 * k_16_60;
filtered_signal = filtered_signal + filtered_60_250 * k_60_250;
filtered_signal = filtered_signal + filtered_250_2k * k_250_2k;
filtered_signal = filtered_signal + filtered_2k_4k * k_2k_4k;
filtered_signal = filtered_signal + filtered_4k_6k * k_4k_6k;
filtered_signal = filtered_signal + filtered_6k_16k * k_6k_16k;

fvtool(bpFilt_16_60, bpFilt_60_250, bpFilt_250_2k, bpFilt_2k_4k, bpFilt_4k_6k, bpFilt_6k_16k, 'FrequencyScale', 'log');

figure();
subplot(2, 1, 1);
plot(timeVector, filtered_signal);
axis([0, 8.5, -1, 1]);
title('Sinal reconstruído');
xlabel('Tempo (s)');
ylabel('Amplitude');
subplot(2, 1, 2);
title('Sinal original');
plot(timeVector, signal);
axis([0, 8.5, -1, 1]);
xlabel('Tempo (s)');
ylabel('Amplitude');
print('-clipboard','-dbitmap');

%% Espectro de Frequências do Sinal de Áudio Filtrado

Xw_filtered = fftshift(fft(filtered_signal./signalLength));

figure();
subplot(2, 1, 1);
plot(freqVector, abs(Xw_filtered(:,1)));
title('Espectro de frequência do sinal reconstruído');
ylabel('Magnitude');
xlabel('Frequência [Hz]');
subplot(2, 1, 2);
plot(freqVector, unwrap(angle(Xw_filtered(:,1))));
ylabel('Fase');
xlabel('Frequência [Hz]');
print('-clipboard','-dbitmap');

%% Reprodução do Sinal Filtrado

%sound(signal, Fs); % Reprodução do sinal original no sitema de áudio 
sound(filtered_signal, Fs); % Reprodução do sinal no sistema de áudio do computador



