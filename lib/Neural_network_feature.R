#############################################################
### Construct visual features for training/testing images ###
#############################################################

### Authors: Yujie Hu
### Project 2
### ADS Spring 2017

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
  cv2 <- reticulate::import('cv2')  
  library(tensorflow)
  tf$reset_default_graph()
  model_path <- 'mobilenet_v1_0.50_224/quantized_graph.pb'
  
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
  
  n_files <- length(list.files(img_dir))
  imgs <- vector("list", n_files)
  img_resized<- vector("list", n_files)
  input_img<- vector("list", n_files)
  NN_values <- matrix(NA,n_files,1001 ) 
  
  for(i in 1:n_files){
    img <- readImage(paste0(img_dir,  "wanying", i, ".jpg"))
    imgs[[i]] <- img
    img_resized[[i]] <- cv2$resize(imgs[[i]], dsize=tuple(224L, 224L))
    img_resized[[i]] <- (img_resized[[i]] - 0.5) * 2
    input_img[[i]] <- np_array(img_resized[[i]], dtype='float32')$reshape(1L, 224L, 224L, 3L)
    
    NN_values[i,] <- sess$run(
      graph_output,
      feed_dict=dict(graph_input=input_img[[i]]))
    
    NN_values[i,] <- as.vector(NN_values[i,])
  }
  
  ### output constructed features
  if(export){
    save(NN_values, file = paste0("../output/feature_",  "NNwanying", ".RData"))
  }
  return(NN_values)
}

  
  
  



