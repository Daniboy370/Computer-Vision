# Computer-Vision

046195 - [Computer Vision](https://webcourse.cs.technion.ac.il/236873/Winter2019-2020/).

**Syllabus** :
Image Formation, Geometry and Projections, Photometry, Color Space, Edge Detection, Scale Space, Image Features, Dimensionality Reduction, Classification, Segmentation, Recognition, Motion Analysis. Deoms :

## 
**OpenCV**  ::  a classic implementation of lane and objects detection, using simple DoG, dilation and *Hough Transform* :

 &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; ![alt text](https://github.com/Daniboy370/Computer-Vision/blob/master/OpenCV_Demo/Upload/Github_GIF.gif)
  
##
A calibrated camera projects 3D points onto the image plane due to their linear constraint by 2 planes :

![alt text](https://github.com/Daniboy370/Computer-Vision/blob/master/Homeworks/Hw_1/images/3D_projection_to_pixels.png)

## 
Dimensionality reduction using PCA concept, we can extract its eigenvectors, namely == EigenFaces :

![alt text](https://github.com/Daniboy370/Computer-Vision/blob/master/Homeworks/Hw_1/images/PCA.png)

## 
Edge detection using Hough-Transform (upper) and Laplacian Pyramid as an image blender (lower) :

![alt text](https://github.com/Daniboy370/Computer-Vision/blob/master/Homeworks/Hw_1/images/Hough_Blend.png)

# Course homeworks
Along the course I have implementesd several small-size projects in different CV topis, available [here](https://github.com/Daniboy370/Computer-Vision/tree/master/Homeworks)

## Requirements
Python 3.4, TensorFlow 1.3, Keras 2.0.8 and other common packages listed in `requirements.txt`.

## Installation
1. Clone this repository
2. Install dependencies
   ```bash
   pip3 install -r requirements.txt
   ```
3. Run setup from the repository root directory
    ```bash
    python3 setup.py install
    ``` 
3. Download pre-trained COCO weights (mask_rcnn_coco.h5) from the [releases page](https://github.com/matterport/Mask_RCNN/releases).
4. (Optional) To train or test on MS COCO install `pycocotools` from one of these repos. They are forks of the original pycocotools with fixes for Python3 and Windows (the official repo doesn't seem to be active anymore).

    * Linux: https://github.com/waleedka/coco
    * Windows: https://github.com/philferriere/cocoapi.
    You must have the Visual C++ 2015 build tools on your path (see the repo for additional details)
