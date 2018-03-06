#############################################################
### Construct visual features for training/testing images ###
#############################################################

### Authors: Yuting Ma/Tian Zheng
### Project 3
### ADS Spring 2017

NN_feature <- function(img_dir, n_files){
  
  ### Construct process features for training/testing images
  ### Sample simple feature: Extract row average raw pixel values as features
  
  ### Input: a directory that contains images ready for processing
  ### Output: an .RData file contains processed features for the images
  
  ### load libraries
  library(reticulate)
  # If you are using anaconda, point reticulate to the correct conda environment
  #use_condaenv('/anaconda3/bin/python')
  use_python('/bin/local/python')
  cv2 <- reticulate::import('cv2')  
  library(tensorflow)
  tf$reset_default_graph()
  model_path <- '../lib/mobilenet_v1_0.50_224/quantized_graph.pb'
  
  data <- with(tf$gfile$FastGFile(model_path, 'rb') %as% f, {
    f$read()
  })
  
  graph_def <- tf$GraphDef()
  graph_def$ParseFromString(data)
  
  graph_elems <- tf$import_graph_def(
    graph_def,
    name='',
    return_elements=c('input:0',
                      'MobilenetV1/Predictions/Reshape:0'))
  
  graph_input <- graph_elems[[1]]
  graph_output <- graph_elems[[2]]
  
  sess <- tf$Session()
  
  # n_files <- length(list.files(img_dir))
  imgs <- vector("list", n_files)
  img_resized<- vector("list", n_files)
  input_img<- vector("list", n_files)
  NN_values <- matrix(NA,n_files,1001 ) 
  dat <- matrix(NA, nrow = n_files, ncol = 3) 
  #load for the bw image this is img_nnet
  load("/Users/mac/Documents/GitHub/project-2-predictive-modelling-group-1/output/subsititue_forbw.RData")
  
  for(i in 1:n_files){
    img <- readImage(paste0(img_dir,  "pet", i, ".jpg"))
    imgs[[i]] <- img
    dat[i, 1:length(dim(imgs[[i]]))] <- dim(imgs[[i]])

   if (is.na(dat[i,3])){
      
      #img_nnet is a normal image's result(more in image analysis advanced) 
      img_resized[[i]]<-img_nnet
    }else{
      img_resized[[i]] <- cv2$resize(imgs[[i]], dsize=tuple(224L, 224L))
      img_resized[[i]] <- (img_resized[[i]] - 0.5) * 2
    }
    input_img[[i]] <- np_array(img_resized[[i]], dtype='float32')$reshape(1L, 224L, 224L, 3L)
    
    
    NN_values[i,] <- sess$run(
      graph_output,
      feed_dict=dict(graph_input=input_img[[i]]))
    
    NN_values[i,] <- as.vector(NN_values[i,])
  }
  
  ### output constructed features
  # if(export){
  #  save(NN_values, file = paste0("../output/feature_",  "NN", ".RData"))
  # }
  return(NN_values)
}

hog_feature <- function(img_dir, export=T){
  
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
  return(hog_value)
}

