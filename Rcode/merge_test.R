t=readRDS(paste0('t1',".rds"))
for(s in 2:10){
  new=readRDS(paste0('t',as.character(s),".rds"))
  t=rbind(t,new)
}
t=t[,which(names(t) %in% c("Id","newtext"))]
