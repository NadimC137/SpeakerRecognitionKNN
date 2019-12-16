clc;
clear all;
close all;

%% Taking User ID and voice data for training
prompt = 'User No?:'; %dhrubo=1, nadim=2, rafee=3
user = input(prompt)

file = input('What file would you like to open?:', 's');
[audioIn,fs] = audioread(file);


%% defining framesize of samples  to extract features
windowlength = round(0.03*fs); % 30ms
overlaplength = round(0.02*fs);
hoplength = windowlength - overlaplength;

%% extracting first feature pitch
[f0,loc0] = pitch(audioIn,fs, ...
    'WindowLength',windowlength, ...
    'OverlapLength',overlaplength, ...
    'Range',[50 400], ...
    'MedianFilterLength',3);

subplot(4,1,1)
plot(audioIn)
ylabel('Amplitude')

subplot(4,1,2)
plot(loc0,f0)
ylabel('Pitch (Hz)')
xlabel('Sample Number')

%% extracting speech data from whole audio data (noise cancellation)
totalframe=floor(length(audioIn)/windowlength);
avgpow=zeros(totalframe,1);
frame=zeros(windowlength,1);
audioIn2= zeros(length(audioIn),1);

for j=1:totalframe
   a=((j-1)*windowlength)+1;
   b=j*windowlength;
   frame=audioIn(a:b,1);
   framesq=frame.^2;
   avgpow(j,1)=sum(framesq)/windowlength;
   if avgpow(j,1)> 1e-4
    audioIn2(a:b,1)=frame;
   end
end

audioIn3=[];
c=0;

for j=1:length(audioIn2)
if audioIn2(j,1)==0
    c=c+1;
    if c>50
        continue;
    end
end

audioIn3 = [audioIn3; audioIn2(j,1)];
if audioIn2(j,1) ~=0
    c=0;
end
end


%% ploting audio after removing nonspeech data 
subplot(4,1,3)
plot(audioIn3);

%% finding pitch for modified audiodata 
[f1,loc1] = pitch(audioIn3,fs, ...
    'WindowLength',windowlength, ...
    'OverlapLength',overlaplength, ...
    'Range',[50 400], ...
    'MedianFilterLength',3);

subplot(4,1,4)
plot(loc1,f1)
ylabel('Pitch (Hz)')
xlabel('Sample Number')

%% finding Mel-frequency cepstral coefficients (MFCC) for each frame (13 coefficient)

coeffs = mfcc(audioIn3,fs,'LogEnergy','Replace');

[m,n] = size(coeffs)
coeffs2=[coeffs f1 ones(m,1)*user]; %appending pitch with MFCC, to get 14 features together

filename = 'traindata.xlsx'; %import traing excel file to append new samples   
past=xlsread(filename);
new=[past; coeffs2];
xlswrite(filename,new);

