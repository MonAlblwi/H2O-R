library(h2o)
h2o.init()
set.seed(123)
#set N to be how many random records I'm going to create
N <- 1000

#Define the four blood types.
bloodTypes <- c('A','O','AB','B')

# Create date frame has an ID taht run from 1 to N=1000
d<- data.frame(id= 1:N)
d$bloodType<- bloodTypes[(d$id %% length(bloodTypes))
+1
]
head(d)

#another way of filling the bllodtype
bloodTypes <- c('A','A','A','O','O','O','AB','B')
d$bloodType <- as.factor(bloodTypes[(d$id %% length(bloodTypes))+1])
head(d)


## creat an age from scla 18-65
#runif(n, min = , max = ) 
#is used to generate n uniform random numbers
#lie in the interval (min, max).
d$age = runif(N,min=18,max=65)

# randomally assigne how healthy the are 
v=round(rnorm(N,mean=5,sd=2))
v=v+ifelse(d$age<30,1,0) # kids more active
v= pmax(v,0)
v= pmin(v,9)
table(v)
d$activeLifestyle =v
#rnorm(n, mean = , sd = )
#is used to generate n normal random numbers
#with arguments mean and sd;
v=round(rnorm(N,mean=5,sd=2))
v= pmax(v,0)
v= pmin(v,9)
table(v)
d$healthyEating=v
head(d)
#Creat an income 
v= 20000 +((d$age*3) ^2) # base salary of 20,000
#plus their age times three squared, which goes from 22,000 to 58, 000. 
#Based slaray based on age
v= v+ (d$healthyEating *500) # ppl who have healthy eating get bouns
v= v+ (d$activeLifestyle *300)# ppl get bouns if they have active lif
v= v+ runif(N,0,5000) # type of nois date where everboday  get 0 to $5,000 bonus on their salary. 
#Completely independent of everything else
d$income =round(v,2)#another type of introducing nois date rounding the salary to $100


# import it but I don't want to call it d, I want to call it people
# by specifying a destination frame explicitly.
as.h2o(d,destination_frame="people")