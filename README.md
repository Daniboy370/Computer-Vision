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

## Requirements
Python 3.4, OpenCV (cv2) and other common packages listed in `requirements.txt` at the [OpenCV_demo](https://github.com/Daniboy370/Computer-Vision/blob/master/OpenCV_Demo/OpenCV_demo.py) directory.

## Course homeworks
Along the course I have implementesd several small-size projects in different CV topics, available [here](https://github.com/Daniboy370/Computer-Vision/tree/master/Homeworks)
