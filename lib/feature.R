#############################################################
### Construct visual features for training/testing images ###
#############################################################

### Authors: Yuting Ma/Tian Zheng
### Project 3
### ADS Spring 2017

feature <- function(img_dir, set_name, data_name="data", export=T){
  
  ### Construct process features for training/testing images
  ### Sample simple feature: Extract row average raw pixel values as features
  
  ### Input: a directory that contains images ready for processing
  ### Output: an .RData file contains processed features for the images
  
  ### load libraries
  library("EBImage")
  
  n_files <- length(list.files(img_dir))
  
  ### determine img dimensions
  img0 <-  readImage(paste0(img_dir, "img", "_", data_name, "_", set_name, "_", 1, ".jpg"))
  mat1 <- as.matrix(img0)
  n_r  <- nrow(img0)
  
  ### store vectorized pixel values of images
  dat <- matrix(NA, n_files, n_r) 
  for(i in 1:n_files){
    img     <- readImage(paste0(img_dir,  "img", "_", data_name, "_", set_name, "_", i, ".jpg"))
    dat[i,] <- rowMeans(img)
  }
  
  ### output constructed features
  if(export){
    save(dat, file = paste0("../output/feature_", data_name, "_", set_name, ".RData"))
  }
  return(dat)
}

## HOG (Histogram of oriented gradients)

# We create a HOG object
# The only parameter of real importance here is winSize,
# but we are required to pass in at least this many parameters
# so that OpenCV can figure out which function we want to call.

winSize <- tuple(64L,64L)
blockSize <- tuple(16L,16L)
blockStride <- tuple(8L,8L)
cellSize <- tuple(8L,8L)
nbins = 9L

hog = cv2$HOGDescriptor(winSize,blockSize,blockStride,cellSize,nbins)

#Most algorithms only work over images of fixed sizes. Let us resize the image
#and compute the hog descriptor on the image. We note that the HOG descriptor
#only accepts inputs in the 0-255 uint8 format, and so we need to specify
#this as our input type.
img_resized <- cv2$resize(img, dsize=tuple(64L, 64L))
hog_values <- hog$compute(np_array(img_resized * 255, dtype='uint8'))

#We thus compute a feature vector of length 1764 (in this case) which corresponds
#to the HOG features of our image.