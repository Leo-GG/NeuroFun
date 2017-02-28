# NeuroFun

A collection of tools for the functional characterization of neuronal cultures from MEA recordings.  
Leonardo D. Garma, 2017. 

## Introduction

These tools extract a number of different features from extracellular recordings from neuronal cultures. 
In principle the recordings are obtained from Multi Electrode Arrays, although they can be useful for any similar data.  
The information is extracted based on detected neuronal spikes, coming either from raw or spike-sorted data. 
If the spikes are not provided, a function is provided to load raw recordings and perform a simple threshold-based detection (see input/getSpikesFromRaw.m).  
If the spikes are obtained from a non-sorted recording, the results are on a per-electrode/per-channel base. 
If the spikes come from sorted data, the results are given in a per-unit base.  
The spike information needs to be added to a struct containing the fields C (for channel/unit), T (for time in seconds) and A (for amplitude). 
The struct with the Spikes information can be used to run the full analysis with the NeuroFun function.  
A demo script is provided to illustrate how to i)gather the spike data ii)run the analysis iii)plot results.   

## Methods

The analysis tools are divided in the following categories: basic, bursts-related, correlation and network.  

### Basic tools

Basic functions are provided to compute distributions of firing rates, amplitudes and amplitude standard deviation.  

### Bursts-related

#### Burst detection
Four different methods for burst detection are given:  
1. 'Hist': uses the histogram-based detection method described in Bakkum et al. (2014, doi: 10.3389/fncom.2013.00193)  
2. 'MaxInt': uses the MaxInterval method as described in the NeuroExplorer package  
3. 'KS': uses a kernel to smooth binned spike frequencies. Bursts are detected as the peaks on the smoothed frequencies and assigned fixed length. Originally implemented by M Fiscella  
4. 'GM': uses a Gaussian Mixture Model to describe the distribution of spike frequencies assuming two distribution (burst/non-burst). The mean of the second distribution minus one standard deviation is taken as threshold to detect bursts  
Each method returns a struct containing basic information about the detected bursts (length in seconds, start and end times) and a list which assigns each spike to a burst or to none (-1).  

#### Burst characteristics  
The following features described in Cotterill et al. (2016, doi:10.1177/1087057116640520) are included, giving values for EACH electrode/unit:  
* Burst rate: bursts per minute on each electrode  
* Burst duration: duration of each burst on each electrode  
* Fraction of bursting electrodes: number of electrodes with bursting rate>1  
* Within-burst firing rate: mean firing rate within all bursts for each electrode  
* Percentage of spikes in bursts: spikes in bursts/spikes outside for each electrode  
* CV of IBI: std/mean of length of IBIs for each electrode  
* CV of within burst ISIs: std/mean of length of ISIs within bursts for each electrodes  
  
Additionally, "global" burst features are computed taking into account the combined information from all channels and detected bursts:  
* Burstiness Index (BI): as described in Wagenaar et al. (2005, Journal of Neuroscience, 25(3):680-688)  
* IBIs: list of all IBIs considering all electrodes/units  
* Bursts sizes in number of spikes  
* Bursts sizes in number of electrode/units involved  

### Correlation  
Two different measures are implemented to compute the correlation between each pair of spike trains present in the data:  
1. Cross-correlogram method from Dayan, P & Abbott, L. F. (2001)  
2. Spike Time Tiling Coefficient from Cutts & Eglen (2014)  
These methods are implemented in parallel, expect some overhead time when running them. 
Although both methods are implemented in matrix form, they are demanding on the CPU and might take long to run using all the spikes.
By default, the NeuroFun function runs these methods using only the non-bursting spikes, which might still take ~1.5 hours for a 30 min recording on 1024 electrodes.  

### Network  
Functions for computing a few network properties are provided: in-degree, out-degree and modularity. 
These computations are based on the correlation between channels, making the assumption that the correlation is a good representation for the connectivity. 
Only correlation values above 0 can be used, thus STTC is not suitable for this unless it is renormalized (which might turn it into an incorrect representation of the network connectivity).  
All the features are computed for a ranged of thresholded networks, so a different percentage of connections is considered at a time, 
i.e. at first only the 1% stronges connections are considered and this percentage is increased until all connections are used. Therefore, 100 values are provided for each measure.  









