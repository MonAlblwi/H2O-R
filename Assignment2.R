library(h2o)     
h2o.init(nthreads = -1)

#STEP 1: Load data and split it into TRAIN,TEST and VALID

cacaoData= h2o.importFile("http://coursera.h2o.ai/cacao.882.csv")

summary(cacaoData,exact_quantiles= TRUE)

parts <- h2o.splitFrame(cacaoData, c(0.8,0.1), seed = 69)
sapply(parts,nrow)

train <-parts[[1]]
valid<- parts[[2]]
test<- parts[[3]]


#STEP 2: Create  Clasifcation Model

y= "Maker"
