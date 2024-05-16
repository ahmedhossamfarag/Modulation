%% Load File
filename = 'speech.mp3';
[y,fs] = audioread(filename);
ts = 1/ fs;

fm = 3e3;

%% Compute t
t = length(y) * ts;
t = (0:ts:t-ts)';

%% Plot Sound
plotsignal('MSG', t, y, fs)
% sound(real(y), fs)

%% Carier
Ac = 1;
ka = 1;
fc = 6e3;
carier = cos(2 * pi * fc * t);

%% Conv AM
% modulateds = Ac * (1 + ka *y) .* carier;

%% DSB AM
% modulateds = y .* carier;

%% SSB AM
% modulateds = y .* carier + hilbert(y) .* sin(2 * pi * fc * t);

%% Modulated MSS Plot
% plotsignal('Modulated MSG', t, modulateds, fs)

%% Noise
snr = 20;
% snr = -10;
modulateds =  awgn(modulateds,snr,'measured');
plotsignal('Noisy Modulated MSG', t, modulateds, fs)

%% Conv AM Demodulation
% env = modulateds.^2;
% env = lowpass(env, fm, fs);
% env = env.^0.5;
% msg = env - Ac/sqrt(2);

%% DSB & SSB AM Demodulation
% msg = modulateds .* carier;
% msg = lowpass(msg, fm, fs);


%% Demodulated MSG Plot & Display
plotsignal('Demodulated MSG', t, msg, fs)
% sound(real(msg), fs)

%% Comments
% Conv Modulation has a huge power in the carrier as expected & the noise is high
% DSB  Modulation solves the problem of power of the carier but still consumes bandwidth
% SSB  Modulation solves the problem of bandwidth as expected

%% Plot Functions
function plotsignal(tl, t, sig, fs)
figure('Name',tl,'NumberTitle','off');
subplot(2, 1, 1)
plot(t, sig)
subplot(2, 1, 2)
pspectrum(sig, fs)
end

function pspectrum(sig, fs)
sf = fftshift(fft(sig));
L = length(sf);
plot(fs/L * (-L/2:L/2-1), abs(sf) / L)
end

