import cv2
import os
import pydicom
from pydicom.pixel_data_handlers.util import apply_voi_lut
import numpy as np

inputdir='./dcmFiles/'
outdir='./pngFiles/'
if not os.path.exists(outdir):
    os.makedirs(outdir)

# loop through all the DICOM files
for f in os.listdir(inputdir):
    ds = pydicom.dcmread(os.path.join(inputdir, f))  # read the dcm file
    img = ds.pixel_array  # get the image array

    #Normalize the image and negate it
    img = apply_voi_lut(img, ds)  # apply the VOI LUT (if available)
    img = img - np.min(img)  # scale the image
    img = img / np.max(img)  # scale the image
    img = (img * 255).astype(np.uint8)  # convert the image to 8-bit unsigned int
    img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)  # convert the image to 3 channels
    img = cv2.bitwise_not(img)  # invert the image
    
    cv2.imwrite(os.path.join(outdir, f.replace('.dcm', '.png')), img)  # write png image