setwd("//wfs1/users$/shuyi/Desktop/628module2/data")

#merge 1,5 20,35,50  training
#merge 15,30,40 test

library("glmnet")
library("LiblineaR")
library("xgboost")

# wfreq1=data.frame(read.csv("newfreq1",header=T))
# wfreq2=data.frame(read.csv("newfreq2",header=T))
# wfreq3=data.frame(read.csv("newfreq3",header=T))
# wfreq4=data.frame(read.csv("newfreq4",header=T))
# wfreq5=data.frame(read.csv("newfreq5",header=T))
# 
# key=c()
# for(r in 1:5){
#   wfreq=data.frame(read.csv(paste0("newfreq",as.character(r)),header=T))
#   key=c(key,as.character(wfreq$name))
# }
# key=unique(key)

xmatrix=function(train,key){
  n1=length(train)
  n2=length(key)
  xmat=matrix(0,nrow=n1,ncol = n2,dimnames = list(NULL,key))
  for(i in 1:n1){
    x=train[[i]]
    xrow=c()
    for(j in 1:n2){
      xrow=c(xrow,sum(train[[i]]==key[j]))
    }
    xmat[i,]=xrow
  }
  return(xmat)
}


# data=readRDS("new_train1.rds")
# train=data$words[1:20000]
# test=data$words[-(1:20000)]
# xtrain=xmatrix(train,key)
# ytrain=as.character(data$stars)[1:20000]
# ytest=as.character(data$stars)[-(1:20000)]
# xtest=xmatrix(test,key)
xtrain=as.data.frame(read.csv("X_freq.csv",header=F))
xtrain=as.matrix(xtrain)
ytrain=readRDS("W15.rds")$stars
set.seed(1011)
cvob1=cv.glmnet(xtrain,ytrain,family="multinomial",type.measure="class")
plot(cvob1)
coef(cvob1)
pred1=predict(cvob1,xtest,type="class")
sum((as.integer(pred1)-as.integer(ytest))^2)/length(ytest)


detect=test[which(abs((as.integer(pred1)-as.integer(ytest)))>1),]
write.csv(data.frame(cbind(stars=detect$stars,text=as.character(detect$text),category=detect$categories,predict=as.integer(pred1[which(abs((as.integer(pred1)-ytest))>1)]
))),"detect.csv")



