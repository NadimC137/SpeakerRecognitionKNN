# Speaker Recognition using Pitch, MFCC and KNN classifier
This project uses machine learning approach to recognise speaker based on features extracted from recorded speech. Initial idea was taken from an [MathWorks article](https://www.mathworks.com/help/audio/examples/speaker-identification-using-pitch-and-mfcc.html) where they demonstrated the method using different MATLAB toolboxes, I avoided using those toolbox and tried to implement most of the algorithms from scratch.  


### Brief Introduction of the Algorithm:
I extracted features from voice which is fundamental to every speaker. Some of these features are pitch and MFCC (Mel-frequency cepstral coefficients). I extracted these features from voice data and stored them to use later for training in machine learning algorithm. The algorithm that was used in order to classify speaker is K nearest neighbor(KNN). This is a supervised classifier algorithm. Features extracted are used in KNN to make the training data. Then when new user input (speech) is given, KNN algorithm identifies the speaker based on the training data. 

<img src="https://www.mathworks.com/help/examples/audio_wavelet/win64/xxSpeakerID01.png" width="600">

#### How KNN Algorithm Works:
Every supervised classifiers need some features for every sample data (training or testing). Let us say, a similar type of problem where whether a patient has cancer or not, has to be detected. Each patient data has two features by which we can decide whether he has cancer or not. Then we can plot every train data, where x and y axis represent two feature values. If the red samples are positive and green are negative then it should look something like below.


<img src="https://github.com/NadimC137/SpeakerRecognitionKNN/blob/master/images/knn1.png" width="600">

Now we want to detect a patient’s condition, whose data has been plotted using star sign. We intend to find out the class of the star. It can be green or red. The “K” in KNN algorithm is the nearest neighbors we wish to take vote from. Let’s say K = 3. Hence, we will now make a circle with the star as center just as big as to enclose only three data points on the plane. Refer to following diagram for more details:
