clc;
clear all;
close all;

% taking voice data for testing
file = input('What file would you like to open?:', 's');
[audioIn,fs] = audioread(file);

%% defining framesize of samples  to extract features
windowlength = round(0.03*fs);
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
windowlength=fs*0.03;
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

subplot(4,1,3)
plot(audioIn3);

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

%% combining pitch and MFCC for getting all feature data in same matrix
[m,n] = size(coeffs)
coeffs2=[coeffs f1 ones(m,1)];

%% loading training data to start machine learing algorithm (K nearest neighbour)
filename = 'traindata.xlsx';
train=xlsread(filename);
forscaling=[train; coeffs2];

%% performming feature scaling so that data converges
meanval= mean(forscaling);
stdval = std(forscaling,1);

[m,n] = size(train);

for j=1:n-1
    for i=1:m
        train(i,j)=(train(i,j)-meanval(j))/stdval(j);
    end
end

[p,q] = size(coeffs2);

for j=1:q-1
    for i=1:p
        coeffs2(i,j)=(coeffs2(i,j)-meanval(j))/stdval(j);
    end
end



%% k nearest neighbour algorithm to detect speaker

sqdist=zeros(m,n-1,p);

for k=1:p
   for j=1:n-1
       for i=1:m
           sqdist(i,j,k)=(coeffs2(k,j)-train(i,j))^2;
       end
   end
end

sumval=zeros(m,p);

for k=1:p
    for i=1:m
       sumval(i,k)=sum(sqdist(i,:,k));
    end
end



kval=10;           
[b,ind] = mink(sumval,kval);

[u,v]=size(ind);

result=zeros(1,v);
resultmtx=zeros(u,v);

for j=1:v
    
    dhrubo=0; %user1
    nadim=0; %user2
    rafee=0; %user3
    
    for i=1:u
        indx=ind(i,j);
        resultmtx(i,j)= train(indx,15);
        if train(indx,15)==1
            dhrubo=dhrubo+1;
        elseif train(indx,15)==2
                nadim=nadim+1;
        elseif train(indx,15)==3
                rafee=rafee+1;
                
        end
    end
    
    if dhrubo>nadim
        if dhrubo>rafee
            result(1,j)=1;
        else
            result(1,j)=3;
        end
        
    elseif nadim>rafee
        result(1,j)=2;
    else 
        result(1,j)=3;
    end
end
        
 final=mode(result);           
  
 if final==1
     disp('User: Dhrubo')
 elseif final==2
     disp('User: Nadim')
 elseif final==3
     disp('User: Rafee')
 end
     


