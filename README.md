# Speaker Recognition using Pitch, MFCC and KNN classifier
This project uses machine learning approach to recognise speaker based on features extracted from recorded speech. Initial idea was taken from an [MathWorks article](https://www.mathworks.com/help/audio/examples/speaker-identification-using-pitch-and-mfcc.html) where they demonstrated the method using different MATLAB toolboxes, I avoided using those toolbox and tried to implement most of the algorithms from scratch.  


### Brief Introduction of the Algorithm:
I extracted features from voice which is fundamental to every speaker. Some of these features are pitch and MFCC (Mel-frequency cepstral coefficients). I extracted these features from voice data and stored them to use later for training in machine learning algorithm. The algorithm that was used in order to classify speaker is K nearest neighbor(KNN). This is a supervised classifier algorithm. Features extracted are used in KNN to make the training data. Then when new user input (speech) is given, KNN algorithm identifies the speaker based on the training data. 

<img src="https://www.mathworks.com/help/examples/audio_wavelet/win64/xxSpeakerID01.png" width="600">
