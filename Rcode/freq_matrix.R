train = readRDS("t1.rds")
data = readRDS("t2.rds")
train = rbind(train, data)
data = readRDS("t3.rds")
train = rbind(train, data)
data = readRDS("t4.rds")
train = rbind(train, data)
data = readRDS("t5.rds")
train = rbind(train, data)
'
tempwords=readRDS("new_train1.rds")$words
for(i in c(5,20,35,50)){
  tempwords=c(tempwords,readRDS(paste0("new_train",as.character(i),".rds"))$words)
}
train$words=tempwords
train$newwords=lapply(train$words,paste0,collapse=" ")
train$newbi=lapply(train$biwords,paste0,collapse=" ")
train$newpunc=lapply(train$punc,paste0,collapse=" ")
cols=c("newwords","newbi","newpunc")
train$newtext=apply(train[ , cols ], 1 , paste0, collapse = " " )
saveRDS(train,file = "train.rds")
'



key_freq=c()
key_freq_bi=as.character(read.csv("bi_freq_feature.csv",header = T)$x)
key_freq_words=as.character(read.csv("words_freq_feature_141.csv",header = T)$x)
key_freq_punc=c("$","*","!","?")
key_freq=c(key_freq_bi,key_freq_words,key_freq_punc)

key=key_freq

xmatrix=function(train,key){
  n1=dim(train)[1]
  n2=length(key)
  xmat=matrix(0,nrow=n1,ncol = n2,dimnames = list(NULL,key))
  for(i in 1:n1){
    x=strsplit(train$newtext[i],split=" ")[[1]]
    xrow=c()
    for(j in 1:n2){
      s = 0
      for(k in 1:length(x)) {
        if(paste0(tolower(substr(x[k],1,1)), 
                  substr(x[k],2,nchar(x[k]))) == key[j]) {
          s = s + 1
        }
      }
      xrow=c(xrow, s)
    }
    xmat[i,]=xrow
  }
  return(xmat)
}

X_f = xmatrix(train, key)
saveRDS(X_f,file = "test1-5_SM.rds") 
