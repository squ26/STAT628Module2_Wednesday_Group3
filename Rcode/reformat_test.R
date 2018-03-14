setwd("//wfs1/users$/shuyi/Desktop/628module2/data")
library("syuzhet")
# to make word cloud
library(wordcloud) 
library(scales)
library(text2vec)
library(dplyr)
library(tidytext)
library(tidyr)
# train2=readRDS("re_train2.rds")
# train3=readRDS("re_train3.rds")
neg=c("no","not","isn't","isnot","wasn't","wasnot","aren't","arenot","weren't","werenot","can't",
      "cannot","don't","doesn't","didn't","donot","doesnot","didnot","aviod","didin't","didnot",
      "haven't","hasn't","havenot","hasnot","lack","none","nothing","without","miss","missing","minus",
      "lost","couldn't","wouldn't","won't","willnot","only","couldnot","lose","if","should","would","could",
      "need","far","rather","used","neither","never","except","lacking","ain't","nor","isnt","aint","none")

too=c("overly","over","too","really","so","suck","fuck","fucking","quite","very","quite")

#so far from; rather than; would be; should be
# like=c("good","nice","right","fresh","delicious","like","love","want","best","great",
#       "finishing","finish","recommended","recommend","worth","worthy","worthwhile",
#       "proper","properly","cleaning","clean","wash","washing","taste","tasty","spectacular",
#       "special","creative","success","successful","deal","enjoy","enjoying","enjoyed",
#       "impressed","impressive","impress","impressing","ok","okay","cute","loyal","cool","replacement",
#       "back","come","coming","go","going","try","repeat","repeat","here","return","again","better",
#       "favorite","cheap","appreciate","appreciated","appreciating","acknowledging","fabulous","enough",
#       "spectacular","happy","friendly","visit","authentic","trying","fancy","pleasant","wow")
# 
# hate=c("bad","worst","expensive","disgusting","crappy","flavorless","salty","elsewhere","overpriced",
#        "low","poor","overcharged","bland","greasy","nasty","underwhelmed","disppoint","disappointed",
#        "disappointing","blame","hate","tired","forget","complaints","crowded","wrong","terrible","problems",
#        "regret","regreted","regreting","worries","complaining","overcooked","order")

fixexp=c("sure","that","longer","matter","quite","wait","but",
         "other","need","like","reason","doubt","thanks","wonder","joke","particularly",
         "problem","hesitate","often","necessary","know","expect","care","mind","anything",
         "realize","speak","help","control","worry","say","imagine","matter","tell","miss","missing","resist")

#back=c("back","come","coming","go","going","try","repeat","repeat","here")
stoplist=read.table("stoplist.txt",header = T)
stoplist=data.frame(stoplist)$x

words_freq=function(t1){
  result=list()
  t1_s=t1$sentences
  t1_w=list()
  for(i in 1:length(t1_s)){
    stemp=t1_s[[i]]
    ls=length(stemp)
    wtemp=c()
    for(j in 1:ls){
      swords=strsplit(txt,split=" ")[[1]]
      lenw=length(swords)
      pp=c()
      for(k in 1:lenw){
        nc= nchar(swords[k])
        ptemp=substr(swords[k],start=nc,stop=nc)
        if(ptemp %in% c("!","?")){
          pp=c(pp,ptemp) 
        }
      }
      wtemp=c(wtemp,pp)
    }
    t1_w[[i]]=wtemp
  }
  result$punc=t1_w
  result$stars=t1$stars
  return(result)
}

files=c()
for(i in c(1,5,20,35,50)){
  files=c(files,paste0('re_train',as.character(i)))
}

for(s in 1:5){
  t1=readRDS(paste0(files[s],".rds"))
  result=words_freq(t1)
  saveRDS(result,file=paste0('punc',s,'.rds'))
}

temp=readRDS("punc1.rds")
temp2=readRDS("punc2.rds")
temp3=readRDS("punc3.rds")
temp4=readRDS("punc4.rds")
temp5=readRDS("punc5.rds")

punc=c(temp$punc,temp2$punc,temp3$punc,temp4$punc,temp5$punc)
length(punc)
train=readRDS("training.rds")
train$punc=punc

for(i in 1:length(train$stars)){
  bi=train$biwords[[i]]
  binew=gsub(" ", "_", bi, fixed=TRUE)
  train$biwords[[i]]=binew
}
train$words=readRDS("W15.rds")$words
train$newwords=apply(train$words,1,paste,collapse=" ")
train$newbi=apply(train$biwords,1,paste,collapse=" ")
train$newpunc=apply(train$punc,1,paste,collapse=" ")
cols=c("newwords","newbi","newpunc")
train$newtext=apply(train[ , cols ], 1 , paste , collapse = " " )