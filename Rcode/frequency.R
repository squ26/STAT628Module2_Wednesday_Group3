#train1 <- readRDS("new_train1.rds")

freq1=data.frame(read.csv("allfreq1.csv",header=T))
freq2=data.frame(read.csv("allfreq2.csv",header=T))
freq3=data.frame(read.csv("allfreq3.csv",header=T))
freq4=data.frame(read.csv("allfreq4.csv",header=T))
freq5=data.frame(read.csv("allfreq5.csv",header=T))

data = train1
occurrence <- list(freq1, freq2, freq3, freq4, freq5)
alloccur=occurrence
for(k in 1:5){
  occurrence[[k]]=occurrence[[k]][1:20000,]
}

unique_oname = c()
for(k in 1:5) {
  occurrence[[k]]$name = as.character(occurrence[[k]]$name)
  for(i in 1:length(occurrence[[k]]$name)) {
    if(!occurrence[[k]]$name[i] %in% unique_oname) {
      unique_oname = c(unique_oname, occurrence[[k]]$name[i])
    }
  }
}
cmb_oname = data.frame(name = unique_oname, 
                       star1 = rep(0, length(unique_oname)),
                       star2 = rep(0, length(unique_oname)),
                       star3 = rep(0, length(unique_oname)),
                       star4 = rep(0, length(unique_oname)),
                       star5 = rep(0, length(unique_oname)))
for(k in 1:5) {
  for(i in 1:length(unique_oname)) { 
    if(unique_oname[i] %in% occurrence[[k]]$name) {
      cmb_oname[i,k+1] = occurrence[[k]]$freq[which(occurrence[[k]]$name == unique_oname[i])]
    } else {
      if(unique_oname[i] %in% alloccur[[k]]$name) {
        cmb_oname[i,k+1] = alloccur[[k]]$freq[which(alloccur[[k]]$name == unique_oname[i])]
      } else {
        cmb_oname[i,k+1] = 0
      }
    }
  }
}

cmb_oname$name = as.character(cmb_oname$name)
cmb_oname$star1 <- cmb_oname$star1 / sum(data$stars == 1)
cmb_oname$star2 <- cmb_oname$star2 / sum(data$stars == 2)
cmb_oname$star3 <- cmb_oname$star3 / sum(data$stars == 3)
cmb_oname$star4 <- cmb_oname$star4 / sum(data$stars == 4)
cmb_oname$star5 <- cmb_oname$star5 / sum(data$stars == 5)

write.csv(cmb_oname,"15w_cmb_f_all15.csv")

differences <- rep(0, dim(cmb_oname)[1])
for(i in 1:length(differences)) {
  differences[i] =(abs(cmb_oname[i,2]-cmb_oname[i,3]) + abs(cmb_oname[i,2]-cmb_oname[i,4]) + abs(cmb_oname[i,2]-cmb_oname[i,5]) + abs(cmb_oname[i,2]-cmb_oname[i,6]) + 
                      abs(cmb_oname[i,3]-cmb_oname[i,4]) + abs(cmb_oname[i,3]-cmb_oname[i,5]) + abs(cmb_oname[i,3]-cmb_oname[i,6]) +
                      abs(cmb_oname[i,4]-cmb_oname[i,5]) + abs(cmb_oname[i,4]-cmb_oname[i,6]) + abs(cmb_oname[i,5]-cmb_oname[i,6])) / sum(cmb_oname[i,2:6])
}


#### difference: average
cmb_oname$name[order(differences, decreasing = T)][1:200]

sum_occur = rep(0, dim(cmb_oname)[1])
for(i in 1:length(sum_occur)) {
  sum_occur[i] = sum(cmb_oname[i, 2:6])
}
names(sum_occur) = cmb_oname$name
sum_occur[order(sum_occur, decreasing = T)][1:200]

com_order=c()
for(i in 1:dim(cmb_oname)[1]){
  if(i %in% order(differences,decreasing=T)[1:16000] & i %in% order(sum_occur,decreasing=T)[1:16000]){
    com_order=c(com_order,i)
  }
}
name4000 <- cmb_oname$name[com_order]    # 700
write.csv(name4000, file = "words_freq_feature_4000.csv")

##########################
stop=read.table("stoplist.txt",header=T)$x
stop=as.character(stop)
bi_f=as.character(cmb_oname$name[com_order])
bi_f_s=strsplit(bi_f," ")
del=c()
for(i in 1:length(bi_f_s)){
  if(all(bi_f_s[[i]] %in% stop)){
    del=c(del,i)
  }
}
bi_f=bi_f[-del]
bi_f=gsub(" ", "_", bi_f, fixed=TRUE)
write.csv(as.character(bi_f),"bi_freq2_feature.csv")