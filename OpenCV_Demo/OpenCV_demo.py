# Importing packages
import numpy as np                # Numerical package (mainly multi-dimensional arrays and linear algebra)
import pandas as pd               # A package for working with data frames
import matplotlib.pyplot as plt   # A plotting package
import cv2
import cv2.cv2 as cv
import os # pathlib.Path().absolute() <-- current pwd()
import pdb, time

# import sys
# sys.path.append("/home/daniboy/PycharmProjects/Project_0/Files")
def region_of_interest(img, vertices):
    mask = np.zeros_like(img)
    match_mask_color = 255
    cv.fillPoly(mask, vertices, match_mask_color)
    masked_image = cv.bitwise_and(img, mask)
    return masked_image

def draw_the_lines(img, lines):
    img = np.copy(img)
    blank_image = np.zeros((img.shape[0], img.shape[1], 3), dtype=np.uint8)

    for line in lines:
        for x1, y1, x2, y2 in line:
            cv.line(blank_image, (x1,y1), (x2,y2), (255, 0, 0), thickness=5)

    img = cv.addWeighted(img, 0.8, blank_image, 1, 0.0)
    return img

def process(image):
    height = image.shape[0]
    width = image.shape[1]
    region_of_interest_vertices = [(0, height), (width/2, height/2), (width, height)]
    gray_image = cv.cvtColor(image, cv.COLOR_RGB2GRAY)
    canny_image = cv.Canny(gray_image, 100, 120)
    cropped_image = region_of_interest(canny_image,
                                       np.array([region_of_interest_vertices], np.int32))
    lines = cv.HoughLinesP(cropped_image, rho=2, theta=np.pi/180, threshold=50,
                           lines=np.array([]), minLineLength=40, maxLineGap=100)
    image_with_lines = draw_the_lines(image, lines)
    return image_with_lines

# ---------------------- Main ---------------------- #
# def main():
cap = cv.VideoCapture('Tel_Aviv_Beach.mp4')
fourcc = cv.VideoWriter_fourcc(*'XVID')
vid_out = cv.VideoWriter('Output.avi', fourcc, 20.0, (int(cap.get(3)), int(cap.get(4))))

# ----------------- Initialization ----------------- #
_, img_org = cap.read()
frame1 = img_org; frame2 = frame1
# frame1 = cv.resize(img_org.shape, low_res)
# print ("Resolution : ", cap.get(3), 'x', cap.get(4))
# frame_tot = cap.get(cv.CAP_PROP_FRAME_COUNT) # <-- not working properly
frame_i, frame_tot = 0, 480

while cap.isOpened() & (frame_i < frame_tot):
    print(frame_i); frame_i = frame_i + 1 # frame_idx
    # ------- Hough Transform for alignment -------- #
    frame2 = process(frame2)
    cv.imshow('Github', frame2)

    # -------------- Object Detection -------------- #
    diff = cv.absdiff(frame1, frame2)
    gray = cv.cvtColor(diff, cv.COLOR_BGR2GRAY)
    blur = cv.GaussianBlur(gray, (29, 29), 0)
    _, thresh = cv.threshold(blur, 20, 255, cv.THRESH_BINARY)
    dilated = cv.dilate(thresh, None, iterations=3)
    contours, _ = cv.findContours(dilated, cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE)

    for contour in contours:
        (x, y, w, h) = cv.boundingRect(contour)

        if cv.contourArea(contour) < 500:
            continue
        cv.rectangle(frame1, (x, y), (x+w, y+h), (0, 255, 0), 2)

    cv.drawContours(frame1, contours, -1, (0, 0, 255), 1)
    vid_out.write(frame1)
    cv.imshow('Github', frame1)

    if cv.waitKey(1) & 0xFF == ord('q'):
        break

    # ------------- Towards next step ------------- #
    frame1 = frame2
    _, frame2 = cap.read()
    # frame2 = cv.resize(frame2, low_res)

cap.release()
vid_out.release()
cv.destroyAllWindows()

# ----------- Execution ----------- #
# if __name__ == '__main__':
#     main()

