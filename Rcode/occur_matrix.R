setwd("//wfs1/users$/shuyi/Desktop/628module2/data")
key_occur=c()
key_occur_bi=as.character(read.csv("bi_occur_feature.csv",header = T)$x)
key_occur_words=as.character(read.csv("words_occur_feature_649.csv",header = T)$x)
key_occur_punc=c("$","*","!","?")
key_occur=c(key_occur_bi,key_occur_words,key_occur_punc)

key=key_occur

xmatrix=function(train,key){
  n1=dim(train)[1]
  n2=length(key)
  xmat=matrix(0,nrow=n1,ncol = n2,dimnames = list(NULL,key))
  for(i in 1:n1){
    x=strsplit(train$newtext[i],split=" ")[[1]]
    xrow=c()
    for(j in 1:(n2-4)){
      for(k in 1:length(x)) {
        if(paste0(tolower(substr(x[k],1,1)), 
                  substr(x[k],2,nchar(x[k]))) == key[j]) {
          s = 1
          break
        }else{
          s = 0
        } 
      }
      #s = s + sum(train[[i]]==key[j])
      xrow=c(xrow, s)
    }
    for(j in (n2-3):n2){
      s=sum(x==key[j])   
      #s = s + sum(train[[i]]==key[j])
      xrow=c(xrow, s)
    }
    xmat[i,]=xrow
  }
  return(xmat)
}
t7=readRDS("t7.rds")
train=t7
X_o = xmatrix(train, key)
saveRDS(X_o,"test_matrix_7.rds")

t8=readRDS("t8.rds")
train=t8
X_o = xmatrix(train, key)
saveRDS(X_o,"test_matrix_8.rds")