import cv2
import os
import pydicom
from pydicom.pixel_data_handlers.util import apply_voi_lut
import numpy as np
import re

# Process the output.txt file      
with open(r"outputDCMt.txt", "r") as file:      
    lines = file.readlines()      
  
processed_parts = []      
processed_paths = []       
for line in lines:      
    line = line.strip('\x00ÿþ\n').replace('\\', '\\\\')
            
    if line:      
        parts = line.split("=")      
        if len(parts) == 2:      
            path = parts[1]
            processed_parts.append(parts[0])      
            processed_paths.append(path[5:])      

            
        else:      
            print("Invalid line format:", line)   
#Create a folder to save the images
if not os.path.exists('dcmImgsFolder'):
    os.makedirs('dcmImgsFolder')

# Convert the dcm files to png
for i in range(len(processed_paths)):
    path = str(processed_paths[i]).strip('\x00') 
    path = re.sub(r'(?<=.)\x00(?=.)', '', path)

    # if path ends with .dcm, then convert to .png
    if path.endswith('.dcm'):
        # Read the dcm file
        ds = pydicom.dcmread(path)
        # Apply the VOI LUT transformation
        img = ds.pixel_array  # get the image array
        img = apply_voi_lut(img, ds)  # apply the VOI LUT (if available)
        img = img - np.min(img)  # scale the image
        img = img / np.max(img)  # scale the image
        img = (img * 255).astype(np.uint8)  # convert the image to 8-bit unsigned int
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)  # convert the image to 3 channels
        img = cv2.bitwise_not(img)  # invert the image

        # Save the image as .png in dcmImgsFolder in current directory with same original name
        cv2.imwrite('dcmImgsFolder/' + os.path.basename(path) + '.png', img)

        print("saved in dcmImgsFolder: ", os.path.basename(path) + ".png")


# lf line ends with .dcm, then store the orignial name of the file that comes after the last backslash add .png, then remove everying that comes after the equal      
with open(r"outputDCMt.txt", "r") as file:      
    lines = file.readlines()      

#create outPDF.txt file
if os.path.exists('outPDF.txt'):
    os.remove('outPDF.txt')
    print("outPDF.txt removed")


processed_parts = []      
processed_paths = []  

for line in lines:      
    line = line.strip('\x00ÿþ\n').replace('\\', '\\\\')
            
    if line:      
        parts = line.split("=")      
        if len(parts) == 2:      
            path = parts[1]
            processed_parts.append(parts[0].strip('\x00').replace('\00', ''))
            processed_paths.append(path[5:])      

            
        else:      
            print("Invalid line format:", line)
    #take the text after the last backslash and add .png to itv the add it to outPDF.txt
    
# Store only the name of the file that comes after the last backslash
for i in range(len(processed_paths)):
    path = str(processed_paths[i]).strip('\x00') 
    path = re.sub(r'(?<=.)\x00(?=.)', '', path) 

    if path.endswith('.dcm'):
        # Store the name of the file that comes after the last backslash
        name = os.path.basename(path)
        name = name+ ".png"
        dir_path = os.path.dirname(os.path.realpath(__file__))

        # go into the dcmimgs folder and get the path of the file
        path = dir_path + "\\dcmImgsFolder\\" + name
        with open("output.txt", "a") as f:
            print(processed_parts[i] + "= " + path, file=f)
    else:
        with open("output.txt", "a") as f:
            print(processed_parts[i] + "= " + '''\\\\ad101.siemens-energy.net\\dfs\EnergyFS\\NAM\\GST_Application Data\\NDT\\DR\\WAX PNG\\NotFound.jpg''',file=f)
    
            
            



    
