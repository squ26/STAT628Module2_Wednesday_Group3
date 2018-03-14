#train1 <- readRDS("new_train1.rds")

freq1=data.frame(read.csv("bi_freq1.csv",header=T))
freq2=data.frame(read.csv("bi_freq2.csv",header=T))
freq3=data.frame(read.csv("bi_freq3.csv",header=T))
freq4=data.frame(read.csv("bi_freq4.csv",header=T))
freq5=data.frame(read.csv("bi_freq5.csv",header=T))


occurrence <- list(freq1, freq2, freq3, freq4, freq5)
alloccur=occurrence
for(k in 1:5){
  occurrence[[k]]=occurrence[[k]][1:1500,]
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
      cmb_oname[i,k+1] = alloccur[[k]]$freq[which(alloccur[[k]]$name == unique_oname[i])]
    }
  }
}

cmb_oname$star1 <- cmb_oname$star1 / 16427
cmb_oname$star2 <- cmb_oname$star2 / 15458
cmb_oname$star3 <- cmb_oname$star3 / 22309
cmb_oname$star4 <- cmb_oname$star4 / 44142
cmb_oname$star5 <- cmb_oname$star5 / 56283

write.csv(cmb_oname,"combine_f_biwords.csv")

differences <- rep(0, dim(cmb_oname)[1])
for(i in 1:length(differences)) {
  differences[i] =(abs(cmb_oname[i,2]-cmb_oname[i,3]) + abs(cmb_oname[i,2]-cmb_oname[i,4]) + abs(cmb_oname[i,2]-cmb_oname[i,5]) + abs(cmb_oname[i,2]-cmb_oname[i,6]) + 
                      abs(cmb_oname[i,3]-cmb_oname[i,4]) + abs(cmb_oname[i,3]-cmb_oname[i,5]) + abs(cmb_oname[i,3]-cmb_oname[i,6]) +
                      abs(cmb_oname[i,4]-cmb_oname[i,5]) + abs(cmb_oname[i,4]-cmb_oname[i,6]) + abs(cmb_oname[i,5]-cmb_oname[i,6])) / sum(cmb_oname[i,2:6])
}
saveRDS(differences,"difference_f_biwords.rds")

#### difference: average
cmb_oname$name[order(differences, decreasing = T)]

sum_occur = rep(0, dim(cmb_oname)[1])
for(i in 1:length(sum_occur)) {
  sum_occur[i] = sum(cmb_oname[i, 2:6])
}
names(sum_occur) = cmb_oname$name
sum_occur[order(sum_occur, decreasing = T)]

com_order=c()
for(i in 1:dim(cmb_oname)[1]){
  if(i %in% order(differences,decreasing=T)[1:1000] & i %in% order(sum_occur,decreasing=T)[1:1000]){
    com_order=c(com_order,i)
  }
}
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
write.csv(as.character(bi_f),"bi_freq_feature_large.csv")
