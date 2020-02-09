import numpy as np # for matrix manipulation
import os # for filesystem manipulation
import pydicom # lib for reading dicom files
from PIL import Image # handles the jpg output format
import shutil

PIL=False
CV=True

src_folder = "/home/stefan/dicom_playground/db/ProstateDx-01-0072/12-14-2009-MRI PROSTATE WITH AND WITHOUT CONTRAST-74283/301-T2WTSECOR-67132/"
out_folder = "/home/stefan/dicom_playground/jpg/"

l1_src = src_folder[0:33] #patients
l2_src = src_folder[0:49] #studies
l3_src = src_folder[0:105] #sequences
pat_list = os.listdir(l1_src)



# relpicate src folder structure and ignore .dcm files
# shutil.copytree(l1_src, out_folder, ignore=shutil.ignore_patterns('*.dcm'))

def dicom2jpg(src_folder, out_folder): # example src: 301-T2WTSECOR-67132
    file_list = os.listdir(src_folder)
    for file in file_list:
        try:
            dcm = pydicom.filereader.dcmread(os.path.join(src_folder, file))
            file = file.replace('.dcm', '.jpg')
            if PIL==True:
                img_shape = dcm.pixel_array.shape # from pydicom, returns ndarray and shape of array
                # copy array from int to float
                img_float = dcm.pixel_array.astype(float)
                # dont allow negative values TODO: try to get rid of the artefacts produced by this
                img_uint = np.uint8(img_float)
                # write file to disk
                w = Image.fromarray(img_uint)
                w.save(os.path.join(out_folder, file), compression="jpeg", quality=100)
            if CV == True:
                pixel_array = dcm.pixel_array
                cv2.imwrite(os.path.join(out_folder, file), pixel_array)
            else:
                print("No image conversion libary activated!")
        except:
            print("Could not convert: ", os.path.join(src_folder, file))

# dicom2jpg(src_folder, out_folder)

