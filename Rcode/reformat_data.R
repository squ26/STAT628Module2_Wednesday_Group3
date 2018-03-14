setwd("//wfs1/users$/shuyi/Desktop/628module2/data")
files=c()
for(i in 1:10){
  files=c(files,paste0('test',as.character(i)))
}
#install.packages("syuzhet")
#install.packages("qdap")
library("syuzhet")
# to make word cloud
library(wordcloud) 
library(scales)
library(text2vec)
#this version of data using sentimentr package 
for(i in 1:50){
  traindata=read.csv(file=paste0(files[i],".csv"),header=T)
  traindata=as.data.frame(traindata)
  sentences=list()
  words=list()
  sentiment_nrc=list()
  traindata$sentiment_afinn=c()
  
  for(t in 1:length(traindata$text)){
    x=as.character(traindata$text[t])
    sentences[[t]]=get_sentences(x)
    words[[t]]=word_tokenizer(x)[[1]]
  }
  
  traindata$sentences=sentences
  traindata$words=words
  
  saveRDS(traindata,file=paste0('re_',files[i],'.rds'))
}

