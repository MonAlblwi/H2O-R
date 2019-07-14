library(h2o)
h2o.init()
set.seed(123)

#STEP1 :  Create a data set
N <- 1000
d<- data.frame(id= 1:N)
bloodTypes <- c('A','A','A','O','O','O','AB','B')
d$bloodType <- as.factor(bloodTypes[(d$id %% length(bloodTypes))+1])
head(d)

d$age = runif(N,min=18,max=65)

v=round(rnorm(N,mean=5,sd=2))
v=v+ifelse(d$age<30,1,0) # kids more active
v= pmax(v,0)
v= pmin(v,9)
table(v)
d$activeLifestyle =v

v=round(rnorm(N,mean=5,sd=2))
v= pmax(v,0)
v= pmin(v,9)
table(v)
d$healthyEating=v
head(d)

v= 20000 +((d$age*3) ^2) 
v= v+ (d$healthyEating *500) 
v= v+ runif(N,0,5000) 
d$income =round(v,2)

as.h2o(d,destination_frame="Employees")

#STEP 2:Start h2o, and import your data.
employees<- h2o.getFrame("Employees")
head(employees)

#STEP 3: Split the data. create three splits fro train/valid/test independent dataset.
parts <- h2o.splitFrame(
         employees, c(0.6,0.2),
         destination_frames = c("employees_train","employees_valid","employees_test"),
         seed = 123
  
  )
sapply(parts,nrow)
train <- h2o.assign(parts[[1]],"train.hex")
valid<- h2o.assign(parts[[2]],"valid.hex")
test<- h2o.assign(parts[[3]],"test.hex")

#STEP 4: Creat Model "GBM"
y <- "income"
x<- setdiff(names(train),c("id",y))
m1<-h2o.gbm(x,y,train,
                     model_id ="gbmModel1_r",
                     validation_frame = valid
                     )

summary(m1)
h2o.performance(m1,train=TRUE)
h2o.performance(m1,valid=TRUE)
h2o.performance(m1,test)


#STEP 5: Creat 2nd Model with alternative parameters
y <- "income"
x<- setdiff(names(train),c("id",y))
m2<-h2o.gbm(x,y,train,
            model_id ="gbmModel2_r",
            validation_frame = valid,
            ntrees = 2000,          #increase the number of trees, mostly to allow for run time
            learn_rate = 0.2,     #increase the learning rate from(0.1)
            max_depth = 10,       #increase the max depth from(5)
)
summary(m2)
h2o.performance(m2,train=TRUE)
h2o.performance(m2,valid=TRUE)
h2o.performance(m2,test)

