#############################################################
### Construct visual features for training/testing images ###
#############################################################

### Authors: Yujie Hu
### Project 2
### ADS Spring 2018

feature <- function(img_dir, export=T){
  
  ### Construct process features for training/testing images
  ### Sample simple feature: Extract row average raw pixel values as features
  
  ### Input: a directory that contains images ready for processing
  ### Output: an .RData file contains processed features for the images
  
  ### load libraries
  library(reticulate)
  # If you are using anaconda, point reticulate to the correct conda environment
  #use_condaenv('/anaconda3/bin/python')
  use_python('/anaconda3/bin/python')
  # for some reason I need to import cv2 and tensorflow before EBImage
  # or everything breaks.
  cv2 <- reticulate::import('cv2')  
  library("EBImage")
  
  n_files <- length(list.files(img_dir))
  
  winSize <- tuple(64L,64L)
  blockSize <- tuple(16L,16L)
  blockStride <- tuple(8L,8L)
  cellSize <- tuple(8L,8L)
  nbins = 9L
  hog = cv2$HOGDescriptor(winSize,blockSize,blockStride,cellSize,nbins)
  
  imgs <- vector("list", n_files)
  img_resized<- vector("list", n_files)
  hog_values <- matrix(NA, 1764,n_files ) 
  
  for(i in 1:n_files){
    img <- readImage(paste0(img_dir,  "pet", i, ".jpg"))
    imgs[[i]] <- img
    img_resized[[i]] <- cv2$resize(imgs[[i]], dsize=tuple(64L, 64L))
    ### store vectorized pixel values of images
    hog_values[,i] <- as.vector(hog$compute(np_array(img_resized[[i]] * 255, dtype='uint8')))
  }
  
  ### output constructed features
  if(export){
    hog_value<-t(hog_values)
    save(hog_value, file = paste0("../output/feature_",  "HOG", ".RData"))
  }
  return(dat)
}

