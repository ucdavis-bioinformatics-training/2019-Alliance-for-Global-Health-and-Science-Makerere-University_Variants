
samples <- readLines("samples.txt")
map_dir <- "02-BWA"
postfix <- "_bwa.bam.stats"

bwa_stats <- lapply(samples, function(s) {
  readLines(file.path(map_dir,s,paste0(s, postfix)))
})

if (length(bwa_stats) != length(samples)) stop("not all samples have samtools stats files")

SN_data <- lapply(bwa_stats, function(data)){
  sn <- grep("^SN",data, value=TRUE)
  sn <- separate(data.frame(sn),col=1, into=c("ID", "Name","Value"), sep="\t")[,-1]
}

cnames <- SN_data[[1]][,1]
LongTable <- sapply(SN_data, "[[", 2L)
rownames(LongTable) <- samples
colnames(LongTable) <- cnames
write.table(round(LongTable,2),"bwa_stats.txt",sep="\t",row.names=T,col.names=T,quote=F)
