# Added a new line here... Love lenny

#  8888888b.                          888 888          888                            888               
#  888   Y88b                         888 888          888                            888               
#  888    888                         888 888          888                            888               
#  888   d88P 8888b.  888d888 8888b.  888 888  .d88b.  888       .d8888b .d88b.   .d88888  .d88b.       
#  8888888P"     "88b 888P"      "88b 888 888 d8P  Y8b 888      d88P"   d88""88b d88" 888 d8P  Y8b      
#  888       .d888888 888    .d888888 888 888 88888888 888      888     888  888 888  888 88888888      
#  888       888  888 888    888  888 888 888 Y8b.     888      Y88b.   Y88..88P Y88b 888 Y8b.          
#  d8b       "Y888888 888    "Y888888 888 888  "Y8888  888       "Y8888P "Y88P"   "Y88888  "Y8888       
                                                                                                
#  8888888888                                          888                                              
#  888                                                 888                                              
#  888                                                 888                                              
#  8888888    888  888  8888b.  88888b.d88b.  88888b.  888  .d88b.                                      
#  888        `Y8bd8P'     "88b 888 "888 "88b 888 "88b 888 d8P  Y8b                                     
#  888          X88K   .d888888 888  888  888 888  888 888 88888888                                     
#  888        .d8""8b. 888  888 888  888  888 888 d88P 888 Y8b.                                         
#  8888888888 888  888 "Y888888 888  888  888 88888P"  888  "Y8888                                      
#                                             888                                                       
#                                             888                                                       
#                                             888                                                                                                                                                                                                        

cat("\014") #Clear the Console output (only in RStudio).
graphics.off() #Clear all graphs.
rm(list=ls()) #Clear the variables in the global environment.

########################################################################
#-------------------------------
#Using plain loops
#-------------------------------
start_time <- proc.time()
n <- 1000
set.seed(123)
X <- rnorm(n,0,1)
B <- 1000000
thhatstar <- numeric(B)
for(b in 1:B){
  Xstar <- sample(X,replace=TRUE)
  thhatstar[b] <- mean(Xstar^2)  
}
ans1 <- sd(thhatstar)
end_time <- proc.time()
time1 <- end_time - start_time



########################################################################
#-------------------------------
#Using lapply loops
#-------------------------------
start_time <- proc.time()
n <- 1000
set.seed(123)
X <- rnorm(n,0,1)
B <- 1000000
f <- function(b){ #Create a function that contains the contents of your original for loop. 
                  #The argument to the function is the "index" of the for loop.
  Xstar <- sample(X,replace=TRUE)
  mean(Xstar^2)   #Note that the contents of the function is nearly identical to the content of the original for loop.
}
tmp2 <- lapply(1:B,f) #Use "lapply" to run the loop via the function you created.
ans2 <- sd(unlist(tmp2))
end_time <- proc.time()
time2 <- end_time - start_time



########################################################################
#-------------------------------
#Using parallel processing lapply loops
#-------------------------------
start_time <- proc.time()
library(parallel) #This package is available in R by default, you just need to load it.
numCores <- detectCores() - 1 #Detect the number of cores your PC has and subtract "1". Subtract 1 so that there is at least one free core to do other stuff, like send emails or use AnyDesk/VNC!
cl <- makeCluster(numCores) #Create a virtual cluster on your PC named "cl" (or whatever name you want to use).
B <- 1000000
f <- function(b){ #Create a function that contains the contents of your original for loop. 
                  #The argument to the function is the "index" of the for loop.
  Xstar <- sample(X,replace=TRUE)
  mean(Xstar^2)  
}
n <- 1000
set.seed(123)

X <- rnorm(n,0,1)

#ClusterExport: Export all the variables you need that you created "outside the parallel" calculation onto each of the nodes of the cluster you created. 
#These variables will be avaiable on all the separate nodes of the virtual cluster.
#The must be specified in the list below (in this example, only the "n" and "X" variables are needed). 
#Note that the variable names are specified using QUOTE SYMBOLS.
invisible(clusterExport(cl,
                        list("n","X"),
                        envir=globalenv()))

#If you need to exectute something on each node before starting, use "clusterEvalQ".
#------------------------------------------
#For example,
#clusterEvalQ: Run the following code on all nodes and make the results available on all nodes.
#invisible(clusterEvalQ(cl, { 
#  (set.seed(123))
#  (X <- rnorm(n,0,1))
#}))
#------------------------------------------

tmp3 <- parLapply(cl,1:B,f) #Use the parallel version of "lapply" to run the loop.
ans3 <- sd(unlist(tmp3)) #Be careful with the output. I had to "unlist" the output from parLapply to get an answer here.
stopCluster(cl) #Destroy the virtual cluster you created. Good housekeeping!
end_time <- proc.time()
time3 <- end_time - start_time
#--------------------------------



########################################################################
cat("\014") #Clear the Console output (only in RStudio).
ans1
time1
ans2
time2
ans3
time3

