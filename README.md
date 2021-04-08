# Medical Imaging &amp; Big Data
Data Science | Università di Milano-Bicocca
<br>
[Overview](https://github.com/christiansalvatore/medicalimaging-bigdata/blob/master/overview.pdf) of the program of the course
<br>
Contact: christian.salvatore@unimib.it


## Syllabus
* Segmentation of Medical Images
* Feature Extraction and Selection Techniques
* Predictive Models
* From Medical Images to Disease Biomarkers
* Texture Analysis
* Radiomics / Radiogenomics
* Statistical Parametric Mapping  


## Program
* __Lesson #1 (February 28, 2019 | 15:30-18:30 | U24-C2)__ <br>
_Introduction to the topics of the course and focus on medical-imaging techniques_
* __Practical session #1 (March 1, 2019 | 15:30-17:30 | U14-T024)__ <!--[[code](https://github.com/christiansalvatore/medicalimaging-bigdata/tree/master/practicalsession__1)] [[data](https://www.dropbox.com/s/6r8et6x0ps9uc14/data.zip?dl=0)]--> <br>
_Introduction to Matlab: (basic commands; scripts; functions)_ <br>
_Working with medical images (the dicom format; extracting information from the header file; loading and visualizing images; colormaps; working with ROIs)_ <br><br>
Some useful sources about medical-image file formats: <br>
[1] [Larobina et al., 2013](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3948928/pdf/10278_2013_Article_9657.pdf) (a review on medical-image file formats) <br>
[2] [dicomstandard.org](https://www.dicomstandard.org/) <br>
[3] [Neuroimaging Informatics Technology Initiative](https://nifti.nimh.nih.gov/)

<br>

* __Lesson #2 (March 14, 2019 | 15:30-18:30 | U24-C2)__ <!--[[slides](https://github.com/christiansalvatore/medicalimaging-bigdata/blob/master/slides/L2-imagesegmentation.pdf)]--> <br>
_Segmentation of Medical Images_
* __Practical session #2 (March 15, 2019 | 15:30-17:30 | U14-T024)__ <!--[[code](https://github.com/christiansalvatore/medicalimaging-bigdata/tree/master/practicalsession__2)]--> <br>
_Working with medical images_ <br>
_Automatic and semi-automatic segmentation_ <br>
_Graphical User Interfaces_

<br>

* __Lesson #3 (March 21, 2019 | 15:30-18:30 | U24-C2)__ <!--[[slides](https://github.com/christiansalvatore/medicalimaging-bigdata/blob/master/slides/L3-predictivemodels.pdf)]--> <br>
_Feature Extraction and Selection Techniques_ <br>
_Predictive Models_
* __Practical session #3 (March 22, 2019 | 15:30-17:30 | U14-T024)__ <!--[[code](https://github.com/christiansalvatore/medicalimaging-bigdata/tree/master/practicalsession__3)] [[data](https://www.dropbox.com/s/66ecrpc68uavdpb/lesions.zip?dl=0)]--> <br>
_Working with PET-CT scans of phantoms with homogeneous and heterogeneous/irregular synthetic lesions_ <br>
_Extracting and selecting morphological features of synthetic lesions_ <br>
_Implementing (unsupervised and supervised) predictive models for automatic lesion classification and discrimination_ <br><br>
References: <br>
[1] [Gallivanone et al., 2018](https://www.hindawi.com/journals/cmmi/2018/5324517/)

<br>

* __Lesson #4 (March 28, 2019 | 15:30-18:30 | U24-C2)__ <!--[[slides a](https://github.com/christiansalvatore/medicalimaging-bigdata/blob/master/slides/L4a-SPM.pdf) | [slides b](https://github.com/christiansalvatore/medicalimaging-bigdata/blob/master/slides/L4b-radiomics-radiogenomics.pdf)]--> <br>
_From Medical Images to Disease Biomarkers_ <br>
_Texture Analysis_ <br>
_Radiomics / Radiogenomics_ <br>
_Statistical Parametric Mapping_
* __Practical session #4 (March 29, 2019 | 15:30-17:30 | U14-T024)__ <!--[[code](https://github.com/christiansalvatore/medicalimaging-bigdata/tree/master/practicalsession__4)]--> <br>
_Working with PET-CT scans of phantoms with homogeneous and heterogeneous/irregular synthetic lesions_ <br>
_Extracting and selecting radiomics features of synthetic lesions_ <br>
_Implementing (unsupervised and supervised) predictive models for automatic lesion classification and discrimination_ <br><br>
Some useful sources about radiomic features: <br>
[1] [Radiomic features in Matlab](https://it.mathworks.com/matlabcentral/fileexchange/51948-radiomics) <br>
[1] [Radiomic features in Python](https://pyradiomics.readthedocs.io/en/latest/index.html) (with definition of all features) <br>

<br>

* __Practical session #5 (April 4, 2019 | 15:30-18:30 | U24-C2)__ <!--[[data](https://www.dropbox.com/s/su9iac10m2xdrer/data__spm.zip?dl=0)]--> <br> 
_Statistical Parametric Mapping (SPM)_ <br>
_Implementing (unsupervised and supervised) predictive models for automatic lesion classification and discrimination_

<br>

* __Final practical session (April 11, 2019 | 15:30-18:30 | U24-C2)__ <br>
_Project presentation and evaluation_

## Prerequisites | Software | Tools
During the course (practical sessions) and the implementation of the final projects, we will make use of [Matlab](https://it.mathworks.com/) (The MathWorks). Because of this, students are required to download and install Matlab on their laptops.

Another required software package is Statistical Parametric Mapping, which is freely available for download on the [dedicated webpage](https://www.fil.ion.ucl.ac.uk/spm/) of the Wellcome Centre for Human Neuroimaging. Optional tool: [VBM](http://www.neuro.uni-jena.de/vbm/).

A useful tool for neuroimage visualization is MRIcron, which is freely available for download on this [webpage](https://www.nitrc.org/projects/mricron).

Details (data, tools etc.) for each practical session will be available in the corresponding folders of this [repository](https://github.com/christiansalvatore/medicalimaging-bigdata) on Github (e.g. _/medicalimaging-bigdata/practicalsession__1/_ for the first practical session).

## Exam modality
The exam is composed of a practical session and a theoretical session.

The practical session consists in completing and presenting a project. For this task, students will be divided into groups, which will be evaluated based on the project development and implementation and on the final presentation. A qualitative score will be assigned to each group (not to each student individually).

The theoretical session consists in an oral examination with questions regarding the theoretical lessons of the course and a scientific paper. The evaluation of this session will be individual.

A final score will be assigned to each student individually, considering both the evaluation of the practical session and the oral examination.

## Final projects
[Overview](https://github.com/christiansalvatore/medicalimaging-bigdata/blob/master/slides/final-projects.pdf) | Description: Implementation of an (un)supervised machine-learning model for the automatic classification of tumor aggressiveness

## Comments and suggestions
Please, leave any comment/suggestion about the course [here](https://docs.google.com/forms/d/e/1FAIpQLSdUlSSaCsfvgodO93Qq2IslxJEoJoA2M8gSOsHp864QyrSh9g/viewform?usp=sf_link).
