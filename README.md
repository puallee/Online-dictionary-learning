# Online-dictionary-learning
This is the official Matlab implementation of online sparse dictionary learning and time pyramid matching 
["ECG beats classification via online sparse dictionary and time pyramid matching"，In the IEEE 17th International Conference on Communication Technology (ICCT) ]
which can download from https://ieeexplore.ieee.org/abstract/document/8359889，https://arxiv.org/abs/2008.06672
## Compatibility
* The code is tested using Window 10, with matlab 2012.
## Abstract
Recently, the Bag-Of-Word (BOW) algorithm provides efficient features and promotes the accuracy of the ECG classification system. However, BOW algorithm has two shortcomings: (1). it has large quantization errors and poor reconstruction performance; (2). it loses heart beat's time information, and may provide confusing features for different kinds of heart beats. Furthermore, ECG classification system can be used for long time monitoring and analysis of cardiovascular patients, while a huge amount of data will be produced, so we urgently need an efficient compression algorithm. In view of the above problems, we use the wavelet feature to construct the sparse dictionary, which lower the quantization error to a minimum. In order to reduce the complexity of our algorithm and adapt to large-scale heart beats operation, we combine the Online Dictionary Learning with Feature-sign algorithm to update the dictionary and coefficients. Coefficients matrix is used to represent ECG beats, which greatly reduces the memory consumption, and solve the problem of quantitative error simultaneously. Finally, we construct the pyramid to match coefficients of each ECG beat. Thus, we obtain the features that contain the beat time information by time stochastic pooling. It is efficient to solve the problem of losing time information. The experimental results show that: on the one hand, the proposed algorithm has advantages of high reconstruction performance for BOW, this storage method is high fidelity and low memory consumption; on the other hand, our algorithm yields highest accuracy in ECG beats classification; so this method is more suitable for large-scale heart beats data storage and classification. 
## Content
  <BR/>The code includes 
  <BR/>dataset is from MIT-BIH http://ecg.mit.edu/
 <BR/> 1.dictionary learning:
                <BR/>  KSVD+OMP
               <BR/>   DualNewton+Feature-sign
               <BR/>   Online dictionary learning+ LARS
                <BR/>  Online dictionary learnin+Feature-sign
 <BR/> 2.pyramid mathcing:
               <BR/>   time pyramid matching
<BR/>  3.Classifier：
             <BR/>     SVM
             <BR/>     ELM
## Contact
Email: nanyuli1994@gmail.com
## relate journal 
Nanyu Li, Yujuan Si, Di Wang, Tong Liu, Jinrun Yu,ECG Beats Fast Classification Base on Sparse Dictionaries. which can download from https://arxiv.org/abs/2009.03792

## License
MIT


