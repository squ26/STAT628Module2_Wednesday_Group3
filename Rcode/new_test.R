for (t in 1:10){
  testdata=data.frame(read.csv(file=paste0('test',as.character(t),'.csv')))
  testdata=testdata[80001:dim(testdata)[1],]
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

