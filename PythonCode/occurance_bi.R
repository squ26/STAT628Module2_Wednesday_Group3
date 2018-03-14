#train1 <- readRDS("new_train1.rds")

occur1=data.frame(read.csv("bi_occur1.csv",header=T))
occur2=data.frame(read.csv("bi_occur2.csv",header=T))
occur3=data.frame(read.csv("bi_occur3.csv",header=T))
occur4=data.frame(read.csv("bi_occur4.csv",header=T))
occur5=data.frame(read.csv("bi_occur5.csv",header=T))


occurrence <- list(occur1, occur2, occur3, occur4, occur5)
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
      cmb_oname[i,k+1] = occurrence[[k]]$occur[which(occurrence[[k]]$name == unique_oname[i])]
    } else {
	cmb_oname[i,k+1] = alloccur[[k]]$occur[which(alloccur[[k]]$name == unique_oname[i])]
    }
  }
}

cmb_oname$star1 <- cmb_oname$star1 / 16427
cmb_oname$star2 <- cmb_oname$star2 / 15458
cmb_oname$star3 <- cmb_oname$star3 / 22309
cmb_oname$star4 <- cmb_oname$star4 / 44142
cmb_oname$star5 <- cmb_oname$star5 / 56283
write.csv(cmb_oname,"combine_o_biwords.csv")
differences <- rep(0, dim(cmb_oname)[1])
for(i in 1:length(differences)) {
  differences[i] = (abs(cmb_oname[i,2]-cmb_oname[i,3]) + abs(cmb_oname[i,2]-cmb_oname[i,4]) + abs(cmb_oname[i,2]-cmb_oname[i,5]) + abs(cmb_oname[i,2]-cmb_oname[i,6]) + 
                      abs(cmb_oname[i,3]-cmb_oname[i,4]) + abs(cmb_oname[i,3]-cmb_oname[i,5]) + abs(cmb_oname[i,3]-cmb_oname[i,6]) +
                      abs(cmb_oname[i,4]-cmb_oname[i,5]) + abs(cmb_oname[i,4]-cmb_oname[i,6]) + abs(cmb_oname[i,5]-cmb_oname[i,6])) / sum(cmb_oname[i,2:6])
}
saveRDS(differences,"difference_o_biwords.rds")

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
write.csv(as.character(bi_f),"bi_occur_feature_large.csv")