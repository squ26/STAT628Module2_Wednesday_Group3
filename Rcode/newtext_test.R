setwd("//wfs1/users$/shuyi/Desktop/628module2/data")
library("syuzhet")
# to make word cloud
library(wordcloud) 
library(scales)
library(text2vec)
library(dplyr)
library(tidytext)
library(tidyr)

punc_freq=function(t1){
  result=list()
  t1_s=t1$sentences
  t1_w=list()
  for(i in 1:length(t1_s)){
    stemp=t1_s[[i]]
    ls=length(stemp)
    wtemp=c()
    for(j in 1:ls){
      txt=stemp[j]
      swords=strsplit(txt,split=" ")[[1]]
      lenw=length(swords)
      pp=c()
      for(k in 1:lenw){
        ptemp=str_extract_all(swords[k], "\\W")[[1]]
      }
      wtemp=c(wtemp,pp)
    }
    if(length(wtemp)==0){
      t1_w[[i]]="NA"
    }
    else{
      t1_w[[i]]=wtemp
    }
  }
  return(t1_w)
}

for(s in 1:10){
  t1=readRDS(paste0('test_bs_1_',as.character(s),".rds"))
  result=punc_freq(t1)
  t1$punc=result
  saveRDS(t1,file=paste0('test_bsp_1_',as.character(s),".rds"))
}

########
for (t in 1:10){
  testdata=data.frame(read.csv(file=paste0('test',as.character(t),'.csv')))[1:20000,]
  testdata$text=as.character(testdata$text)
  bi=list()
  sentence=list()
  for(i in 1:length(testdata$text)){
    temp.df=data.frame(testdata[i,])
    bi[[i]]=unnest_tokens(temp.df, bigram,text, token = "ngrams", n = 2)$bigram
    sentence[[i]]=get_sentences(temp.df$text, as_vector = TRUE)
  }
  for(i in 1:length(bi)){
    b=bi[[i]]
    bnew=gsub(" ", "_", b, fixed=TRUE)
    bi[[i]]=bnew
  }
  testdata$biwords=bi
  testdata$sentences=sentence
  saveRDS(testdata,file=paste0('test_bs_5_',as.character(t),'.rds'))
}

########
for(s in 1:10){
  bsp=readRDS(paste0('test_bsp_1_',as.character(s),".rds"))
  bsp$words=readRDS(paste0("new_test",as.character(s),".rds"))$words[1:20000]
  bsp$newwords=lapply(bsp$words,paste0,collapse=" ")
  bsp$newbi=lapply(bsp$biwords,paste0,collapse=" ")
  bsp$newpunc=lapply(bsp$punc,paste0,collapse=" ")
  cols=c("newwords","newbi","newpunc")
  bsp$newtext=apply(bsp[ , cols], 1 , paste0, collapse = " " )
  bsp=bsp[ , !( names( bsp) %in% cols ) ]
  saveRDS(bsp,paste0('test_newtext_1_',as.character(s),".rds"))
}
