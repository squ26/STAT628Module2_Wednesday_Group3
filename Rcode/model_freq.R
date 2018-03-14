library(e1071)
library(tm)


key_freq=c()
key_freq_bi=as.character(read.csv("bi_freq_feature.csv",header = T)$x)
key_freq_words=as.character(read.csv("words_freq_feature_640.csv",header = T)$x)
key_freq_punc=c("$","*","!","?")
key_freq=c(key_freq_bi,key_freq_words,key_freq_punc)

key=key_freq

train=readRDS('train.rds')

for(i in 1:10) {
  
  
}
text <- train$newwords
corpus <- Corpus(VectorSource(text))
dtm <- DocumentTermMatrix(
  corpus, 
  control = list(
    dictionary = key, 
    wordLengths=c(-Inf,Inf), 
    tolower=FALSE
  )
)
set.seed(310)
tr_index = sample(dim(train)[1], 100000)
te_index = (1:dim(train)[1])[-tr_index]

trmat <- as.data.frame(as.matrix(dtm[tr_index,]))
temat <- as.data.frame(as.matrix(dtm[te_index,]))
y_tr <- (train$stars[tr_index])
y_te <- (train$stars[te_index])

#trmat$rate = y_tr
#temat$rate = y_te
#write.csv(trmat, file = "trmat_640.csv")
#write.csv(temat, file = "temat_640.csv")

num <- c()
for(i in 1:5) {
  num = c(num, sum(y_tr == i))
}
wts = c(10,11,7,4,3)


trained_model<-svm(trmat, y_tr, type="C-classification", kernel="linear")  #, class.weights = wts)

y_pe = predict(trained_model, temat)
sum((y_te-as.integer(y_pe))^2) / length(y_te)
