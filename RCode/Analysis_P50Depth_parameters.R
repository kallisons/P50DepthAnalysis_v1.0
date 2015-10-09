#Change working directory to P50DepthAnalysis_v1.0/RCode using the setwd() command or using the Misc menu.
#getwd() #shows the current working directory for the R gui.

require(ncdf)
require(colorRamps)

source('RCode/filled.contour/Filled.contour.R', chdir = TRUE)
source('RCode/filled.contour/Filled.legend.R', chdir = TRUE)

data<-read.table("RCode/p50_deltaH_data.txt", header=TRUE, sep="\t", stringsAsFactors=FALSE)
data<-subset(data, data$Habitat=="pelagic")
data.hb<-subset(data, data$Protein=="hb")
data.hc<-subset(data, data$Protein=="hc")

folder<-paste("Results/P50Depth/")
filenames<-list.files(path=folder, pattern=NULL, full.names=FALSE, recursive=FALSE)

dtable<-as.data.frame(matrix(NA, length(filenames), 8))
colnames(dtable)<-c("p50", "deltaH", "iqr", "med")

for(i in 1:length(filenames)){

nc<-open.ncdf(paste(folder, filenames[i], sep=""))
dims<-nc$var[[1]]$ndim
lats<-nc$dim$LATITUDE$vals
lats<-sort(lats)
lons<-nc$dim$LONGITUDE$vals
z<-get.var.ncdf(nc, nc$var[[1]], start=c(1,1,1), count=c(length(lons),length(lats),1))
z<-as.vector(z)
z<-z[!is.na(z)]
p50<-substr(filenames[i], 14,16)
p50<-gsub("_", "", p50)
deltaH<-substr(filenames[i], 24, nchar(filenames[i]))
deltaH<-gsub(".nc", "", deltaH)
deltaH<-gsub("_", "", deltaH)
dtable$p50[i]<-as.numeric(p50)
dtable$deltaH[i]<-as.numeric(deltaH)
dtable$iqr[i]<-IQR(z)
dtable$med[i]<-median(z)
close.ncdf(nc)
}

dtable2<-dtable[order(dtable$p50, dtable$deltaH),]
p50vals<-unique(dtable2$p50)
deltaHvals<-unique(dtable2$deltaH)

iqr.table<-matrix(NA, length(p50vals), length(deltaHvals))
colnames(iqr.table)<-c(deltaHvals)
rownames(iqr.table)<-c(p50vals)

med.table<-matrix(NA, length(p50vals), length(deltaHvals))
colnames(med.table)<-c(deltaHvals)
rownames(med.table)<-c(p50vals)


for(i in 1:length(p50vals)){

div1<-subset(dtable2, dtable2$p50==p50vals[i])

for(j in 1:length(deltaHvals)){

div2<-subset(div1, div1$deltaH==deltaHvals[j])

iqr.table[i,j]<-div2$iqr
med.table[i,j]<-div2$med

}
}

data1<-read.table("Results/Geostats_P50Depth/P50Depth_geostats.txt")

data1<-data1[,4:9]
colnames(data1)<-c("p50", "deltaH", "ocean_area", "p50_area", "min_p50depth", "max_p50depth")

data1$areafrac<-(data1$p50_area/data1$ocean_area)*100

p50vals<-unique(data1$p50)
deltaHvals<-unique(data1$deltaH)

areafrac.table<-matrix(NA, length(p50vals), length(deltaHvals))
colnames(areafrac.table)<-c(deltaHvals)
rownames(areafrac.table)<-c(p50vals)

min_p50depth.table<-matrix(NA, length(p50vals), length(deltaHvals))
colnames(min_p50depth.table)<-c(deltaHvals)
rownames(min_p50depth.table)<-c(p50vals)

max_p50depth.table<-matrix(NA, length(p50vals), length(deltaHvals))
colnames(max_p50depth.table)<-c(deltaHvals)
rownames(max_p50depth.table)<-c(p50vals)


for(i in 1:length(p50vals)){

div1<-subset(data1, data1$p50==p50vals[i])

for(j in 1:length(deltaHvals)){

div2<-subset(div1, div1$deltaH==deltaHvals[j])

areafrac.table[i,j]<-div2$areafrac
min_p50depth.table[i,j]<-div2$min_p50depth
max_p50depth.table[i,j]<-div2$max_p50depth
}
}

OutGraph<-paste("Graphs/P50Depth_Parameters_area.ps", sep="")
postscript(OutGraph, family="Helvetica", width=4, height=4, pointsize=12)
par(plt = c(0.15,0.75,0.25,0.85),
    las = 1,                      # orientation of axis labels
    cex.axis = 1,                 # size of axis annotation
    tck = -0.04,
    pty="s")
ls.col<-grey.colors(18, start=0.9, end=0.1, gamma=2.2)
filled.contour3(p50vals, deltaHvals, areafrac.table, col=ls.col, xlim=c(0,10), ylim=c(-140,140), zlim=c(0,90), ylab="delta H (kJ mol^-1)", xlab="p50 (kPa)", axes=FALSE)
axis(side=1, at=seq(0,10,2), labels=seq(0,10,2))
axis(side=2, at=seq(-140,140,20), labels=seq(-140,140,20))
axis(side=3, at=c(0,10), lwd.ticks=0, labels=FALSE)
axis(side=4, at=c(-140, 140), lwd.ticks=0, labels=FALSE)
contour(p50vals, deltaHvals, areafrac.table, add=TRUE, labcex=0.8, levels=c(1,5,10,15,20,30,40,50,60,70,80,90))
points(data.hb$p50, data.hb$deltaH, pch=16, cex=0.65, col="white")
points(data.hb$p50, data.hb$deltaH, pch=1, cex=0.65, col="black")
points(data.hc$p50, data.hc$deltaH, pch=17, cex=0.65, col="white")
points(data.hc$p50, data.hc$deltaH, pch=2, cex=0.65, col="black")
dev.off()


OutGraph<-paste("Graphs/P50Depth_Parameters_min_med_iqr.ps", sep="")
postscript(OutGraph, family="Helvetica", width=3, height=7, pointsize=12)

plot.new()
par(new = "TRUE",
    plt = c(0.18,0.78,0.70,0.95),
    las = 1,                      # orientation of axis labels
    cex.axis = 1,                 # size of axis annotation
    tck = -0.04)
ls.col<-matlab.like2(16)
ls.col<-ls.col[length(ls.col):1]
filled.contour3(p50vals, deltaHvals, min_p50depth.table, col=ls.col, levels=c(seq(0,150,10),400), xlim=c(0,10), ylim=c(-140,140), zlim=c(0,500), ylab="delta H (kJ mol^-1)", axes=FALSE)
axis(side=1, at=seq(0,10,2), labels=FALSE)
axis(side=2, at=seq(-140,140,20), labels=seq(-140,140,20))
axis(side=3, at=c(0,10), lwd.ticks=0, labels=FALSE)
axis(side=4, at=c(-140, 140), lwd.ticks=0, labels=FALSE)
contour(p50vals, deltaHvals, areafrac.table, add=TRUE, labcex=0.8, levels=c(1,5,10,15,20,30,40,50,60,70,80,90,100))
points(data.hb$p50, data.hb$deltaH, pch=16, cex=0.65, col="white")
points(data.hb$p50, data.hb$deltaH, pch=1, cex=0.65, col="black")
points(data.hc$p50, data.hc$deltaH, pch=17, cex=0.65, col="white")
points(data.hc$p50, data.hc$deltaH, pch=2, cex=0.65, col="black")

par(new = "TRUE",
    plt = c(0.8,0.85,0.70,0.95),   # define plot region for legend
    las = 1,
    cex.axis = 1,
    tck=-0.4)
filled.legend(p50vals, deltaHvals, min_p50depth.table, col=ls.col, levels=seq(0,150,10), xlim=c(0,10), ylim=c(-140,140), zlim=c(0,150))
filled.legend(p50vals, deltaHvals, min_p50depth.table, col=ls.col, levels=seq(0,150,10), xlim=c(0,10), ylim=c(-140,140), zlim=c(0,150))

par(new = "TRUE",
    plt = c(0.18,0.78,0.40,0.65),
    las = 1,
    cex.axis = 1,                 # size of axis annotation
    tck = -0.04)
ls.col<-matlab.like2(25)
ls.col<-ls.col[length(ls.col):1]
filled.contour3(p50vals, deltaHvals, med.table, col=ls.col, xlim=c(0,10), ylim=c(-140,140), levels=seq(100,700,25), ylab="delta H (kJ mol^-1)", axes=FALSE)
axis(side=1, at=seq(0,10,2), labels=FALSE)
axis(side=2, at=seq(-140,140,20), labels=seq(-140,140,20))
axis(side=3, at=c(0,10), lwd.ticks=0, labels=FALSE)
axis(side=4, at=c(-140, 140), lwd.ticks=0, labels=FALSE)
contour(p50vals, deltaHvals, areafrac.table, add=TRUE, labcex=0.8, levels=c(1,5,10,15,20,30,40,50,60,70,80,90,100))
#abline(h=0)
points(data.hb$p50, data.hb$deltaH, pch=16, cex=0.65, col="white")
points(data.hb$p50, data.hb$deltaH, pch=1, cex=0.65, col="black")
points(data.hc$p50, data.hc$deltaH, pch=17, cex=0.65, col="white")
points(data.hc$p50, data.hc$deltaH, pch=2, cex=0.65, col="black")

par(new = "TRUE",
    plt = c(0.8,0.85,0.40,0.65),   # define plot region for legend
    las = 1,
    cex.axis = 1,
    tck=-0.4)
filled.legend(p50vals, deltaHvals, med.table, col=ls.col, levels=seq(100,700,25), xlim=c(0,10), ylim=c(-80,40))
filled.legend(p50vals, deltaHvals, med.table, col=ls.col, levels=seq(100,700,25), xlim=c(0,10), ylim=c(-80,40))

par(new = "TRUE",
    plt = c(0.18,0.78,0.10,0.35),
    las = 1,
    cex.axis = 1,                 # size of axis annotation
    tck = -0.04)
filled.contour3(p50vals, deltaHvals, iqr.table, color.palette = colorRampPalette(c("yellow", "white", "black")), xlim=c(0,10), ylim=c(-140,140), ylab="delta H (kJ mol^-1)", xlab="", axes=FALSE)
axis(side=1, at=seq(0,10,2), labels=seq(0,10,2))
axis(side=2, at=seq(-140,140,20), labels=seq(-140,140,20))
axis(side=3, at=c(0,10), lwd.ticks=0, labels=FALSE)
axis(side=4, at=c(-140, 140), lwd.ticks=0, labels=FALSE)
contour(p50vals, deltaHvals, areafrac.table, add=TRUE, labcex=0.8, levels=c(1,5,10,15,20,30,40,50,60,70,80,90,100))
points(data.hb$p50, data.hb$deltaH, pch=16, cex=0.65, col="white")
points(data.hb$p50, data.hb$deltaH, pch=1, cex=0.65, col="black")
points(data.hc$p50, data.hc$deltaH, pch=17, cex=0.65, col="white")
points(data.hc$p50, data.hc$deltaH, pch=2, cex=0.65, col="black")
mtext("p50 (kPa)", side=1, line=2)

par(new = "TRUE",
    plt = c(0.8,0.85,0.10,0.35),   # define plot region for legend
    las = 1,
    cex.axis = 1,
    tck=-0.4)
filled.legend(p50vals, deltaHvals, iqr.table, color.palette = colorRampPalette(c("yellow", "white", "black")), xlim=c(0,10), ylim=c(-140,140))
filled.legend(p50vals, deltaHvals, iqr.table, color.palette = colorRampPalette(c("yellow", "white", "black")), xlim=c(0,10), ylim=c(-140,140))

dev.off()
