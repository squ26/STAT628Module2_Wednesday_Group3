library(tidyr)
setwd("//wfs1/users$/shuyi/Desktop/628module2/data")
train=read.csv("testval_data.csv",header = T)
#names(train)
#[1] "stars"      "name"       "text"       "date"       "city"       "longitude"  "latitude"   "categories"
datasplit=function(n1){
  ind=c()
  for(i in 1:(n1-1)){
    tempsize=round(dim(train)[1]/n1)
    l=1+tempsize*(i-1)
    u=tempsize*i
    for(j in l:u){
      ind=c(ind,i)
    }
  }
  l=1+tempsize*(n1-1)
  u=dim(train)[1]
  for(k in l:u){
    ind=c(ind,n1)
  }
  return(ind)
}
n1=10
indsplit=datasplit(n1)
for(s in 1:n1){
  traintemp=train[which(indsplit==s),]
  write.csv(traintemp, file = paste0('test',as.character(s),'.csv'),row.names=FALSE)
}

files=c()
for(i in 1:10){
  files=c(files,paste0('test',as.character(i)))
}
testdata=read.csv(file=paste0(files[5],".csv"),header=T)
testdata=data.frame(testdata)
# testi=read.csv(file=paste0(files[i],".csv"),header=T)
# testi=data.frame(testi)
# testdata=rbind(testdata,testi)

testtext=data.frame(txt=as.character(testdata$text))

biwords=testtext %>%
  unnest_tokens(bigram, txt, token = "ngrams", n = 2)
bi1=separate(biwords,bigram, c("word1", "word2", "word3"),to_lower=TRUE, sep = " ") %>%
  count(word1, word2, sort = TRUE)
saveRDS(bi1,"bitest.rds")
write.csv(bi1,"bitest.csv")
triwords=testtext %>%
  unnest_tokens(trigram, txt, token = "ngrams", n = 3)
tri1=separate(triwords,trigram, c("word1", "word2", "word3"), sep = " ") %>%
  count(word1, word2, word3, sort = TRUE)
saveRDS(tri1,"tritest.rds")
write.csv(tri1,"triptest.csv")
skipwords=testtext %>%
  unnest_tokens(ngram, txt, token = "skip_ngrams", n = 3, k = 2)
skip1=separate(skipwords, ngram ,c("word1", "word2", "word3"), sep = " ") %>%
  count(word1, word2, word3, sort = TRUE)
saveRDS(skip1,"skiptest.rds")
write.csv(skip1,"skiptest.csv")