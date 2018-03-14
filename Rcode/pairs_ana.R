library(dplyr)
library(tidytext)
library(tidyr)

setwd("//wfs1/users$/shuyi/Desktop/628module2/data")
files=c()
for(i in 1:50){
  files=c(files,paste0('train',as.character(i)))
}
#install.packages("syuzhet")
#install.packages("qdap")
library("syuzhet")
# to make word cloud
library(scales)
library(text2vec)
#this version of data using sentimentr package 
traindata=read.csv(file=paste0(files[1],".csv"),header=T)
traindata=data.frame(traindata)
for(i in c(5,20,35,50)){
  traini=read.csv(file=paste0(files[i],".csv"),header=T)
  traini=data.frame(traini)
  traindata=rbind(traindata,traini)
}
saveRDS(traindata,file=paste0('W15','.rds'))
traindata$text=as.character(traindata$text)

traindata=readRDS(file=paste0('W15','.rds'))
traindata$text=as.character(traindata$text)
bi=list()
#tri=list()
skip=list()

for(i in 1:dim(traindata)[1]){
  bi[[i]]=unnest_tokens(data.frame(traindata[i,]), bigram,text, token = "ngrams", n = 2)$bigram
#  tri[[i]]=unnest_tokens(data.frame(traindata[i,]),trigram, text, token = "ngrams", n = 3)$trigram
#  skip[[i]]=unnest_tokens(data.frame(traindata[i,]),ngram, text, token = "skip_ngrams", n = 2, k = 2)$ngram
}
#skip 42096

traindata$skipwords=skip
saveRDS(traindata,file=paste0('W15_skip','.rds'))

traindata$triwords=tri
traindata$skipwords=skipi

traintext=data.frame(txt=as.character(traindata$text))
biwords=traintext %>%
  unnest_tokens(bigram, txt, token = "ngrams", n = 2)
bi1=separate(biwords,bigram, c("word1", "word2", "word3"),to_lower=TRUE, sep = " ") %>%
  count(word1, word2, sort = TRUE)
saveRDS(bi1,file=paste0('biwords','.rds'))
write.csv(bi1,"bitrain.csv")

# triwords=traintext %>%
#   unnest_tokens(trigram, txt, token = "ngrams", n = 3)
# tri1=separate(triwords,trigram, c("word1", "word2", "word3"), sep = " ") %>%
#   count(word1, word2, word3, sort = TRUE)
# saveRDS(tri1,file=paste0('triwords','.rds'))
# write.csv(tri1,"tritrain.csv")
# skipwords=traintext %>%
#   unnest_tokens(ngram, txt, token = "skip_ngrams", n = 2, k = 3)
# skipwords=sample_frac(skipwords,0.2)
# skip1=separate(skipwords, ngram ,c("word1", "word2", "word3"), sep = " ") %>%
#   count(word1, word2, sort = TRUE)
# saveRDS(skip1,file=paste0('skipwords','.rds'))
# write.csv(skip1,"skiptrain.csv")
