from reportlab.lib.pagesizes import letter  
from reportlab.platypus import SimpleDocTemplate, Image, Paragraph, Spacer, Table, TableStyle  
from reportlab.lib.styles import getSampleStyleSheet  
import math
import re
# Process the output.txt file      
with open(r"output.txt", "r") as file:      
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

# create the PDF file  
doc = SimpleDocTemplate("CompiledXrays.pdf", pagesize=letter)  
styles = getSampleStyleSheet()  
styleN = styles["Normal"]  
  
# compute the number of pages and images per page  
num_images = len(processed_parts)  
num_images_per_page = 4  
num_pages = math.ceil(num_images / num_images_per_page)  
  
# create a list of Table objects for each page  
tables = []  
for page in range(num_pages):  
    start = page * num_images_per_page  
    end = min(start + num_images_per_page, num_images)  
    num_images_on_page = end - start  
  
    # create a 2x2 grid of images and captions  
    data = []  
    for i in range(num_images_on_page):  
        name = processed_paths[i+start]
        
        if name[0] == 'U':
            additionalText = 'C:\\\\'
        else:
            additionalText = '\\\\' 
        path =  additionalText+ str(processed_paths[i + start]) 

        part = re.sub(r'(?<=.)\x00(?=.)', '', processed_parts[i + start])  # remove null character  
        part = part.strip('\x00')  

        print(path)
        img = Image(path, width=150, height=150)  
        caption = Paragraph(part, styleN)  
        data.append([img])  
        data.append([caption])
  
    # add empty cells to fill out the grid  
    while len(data) < num_images_per_page:  
        data.append([None, None])  
  
    table = Table(data, colWidths=[175])  
    table.setStyle(TableStyle([  
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),  
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),  
        ('BOTTOMPADDING', (0, 0), (-1, -1), 10),  
    ]))  
  
    tables.append(table)  
  
# build the PDF from the list of tables  
doc.build(tables)  
