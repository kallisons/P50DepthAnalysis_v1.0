#Change working directory to P50DepthAnalysis_v1.0/RCode using the setwd() command or using the Misc menu.  
#getwd() #shows the current working directory for the R gui.  

require(ncdf)
require(fields)
require(caTools)

#Longitude of the transect
trans.lon<-220.5

#------------------------------
#   ENVIRONMENTAL DATA
#------------------------------

#Filepath for the oxygen data
pO2_filepath<-paste("../EnvironmentalData/Bianchi_po2_annual_1deg.nc")

#Read in oxygen data
nc.po2<-open.ncdf(pO2_filepath)
lats.po2<-nc.po2$dim$LATITUDE$vals
lats.po2<-sort(lats.po2)
lons.po2<-nc.po2$dim$LONGITUDE$vals
depths.po2<-nc.po2$dim$DEPTH$vals
z.po2<-get.var.ncdf(nc.po2, nc.po2$var[[2]], start=c(which(lons.po2==trans.lon),1,1,1), count=c(1,length(lats.po2),length(depths.po2),1))
close.ncdf(nc.po2)

rownames(z.po2)<-lats.po2
colnames(z.po2)<-depths.po2
depths.po2<-abs(depths.po2)*-1
depths.po2<-depths.po2[order(depths.po2)]
z.po2<-z.po2[,ncol(z.po2):1]

#Select data for 10°N and 55°N
z.po2.10<-z.po2[which(rownames(z.po2)==9.5),]
z.po2.55<-z.po2[which(rownames(z.po2)==54.5),]

#Filepath for the temperature data
Temp_filepath<-paste("../EnvironmentalData/temperature_annual_1deg.nc")

#Read in temperature data
nc.temp<-open.ncdf(Temp_filepath)
lats.temp<-nc.temp$dim$lat$vals
lats.temp<-sort(lats.temp)
lons.temp<-nc.temp$dim$lon$vals
depths.temp<-nc.temp$dim$depth$vals
z.temp<-get.var.ncdf(nc.temp, nc.temp$var[[4]], start=c(which(lons.temp==trans.lon),1,1,1), count=c(1,length(lats.temp),length(depths.temp),1))
close.ncdf(nc.temp)

rownames(z.temp)<-lats.temp
colnames(z.temp)<-depths.temp
depths.temp<-abs(depths.temp)*-1
depths.temp<-depths.temp[order(depths.temp)]
z.temp<-z.temp[,ncol(z.temp):1]

#Select data for 10°N and 55°N
z.temp.10<-z.temp[which(rownames(z.temp)==9.5),]
z.temp.55<-z.temp[which(rownames(z.temp)==54.5),]

#-----------------------------
#  COMBINE ENVIRONMENTAL DATA
#-----------------------------

#Latitude 10°N
z.10<-cbind(as.matrix(z.po2.10), as.matrix(z.temp.10))
z.10<-z.10[nrow(z.10):1,]
colnames(z.10)<-c("PO2", "Temp")
z.10<-as.data.frame(z.10)
z.10$Depth<-rownames(z.10)
rownames(z.10)<-c()
z.10$Depth<-as.numeric(z.10$Depth)*-1

#Latitude 55°N
z.55<-cbind(as.matrix(z.po2.55), as.matrix(z.temp.55))
z.55<-z.55[nrow(z.55):1,]
colnames(z.55)<-c("PO2", "Temp")
z.55<-as.data.frame(z.55)
z.55$Depth<-rownames(z.55)
rownames(z.55)<-c()
z.55$Depth<-as.numeric(z.55$Depth)*-1

#-----------------------
#        P50
#-----------------------
folder<-paste("../Results/P50/")
filenames<-list.files(path=folder, pattern=NULL, full.names=FALSE, recursive=FALSE)

p50vals <- c()
deltaHvals <- c()

collist<-c("black", "green4", "blue", "red")
ltylist<-c(3,1,1,1)

for(i in 1:length(filenames)){

nc<-open.ncdf(paste(folder, filenames[i], sep=""))
dims<-nc$var[[2]]$ndim
lats<-nc$var$P50$dim[[2]]$vals
lats<-sort(lats)
lons<-nc$var$P50$dim[[1]]$vals
depths<-nc$var$P50$dim[[3]]$vals

i1<-which(lons==trans.lon)

z<-get.var.ncdf(nc, nc$var[[2]], start=c(i1,1,1,1), count=c(1,length(lats),length(depths),1))

rownames(z)<-lats
colnames(z)<-depths

p50.10<-z[which(rownames(z)==9.5),]
p50.55<-z[which(rownames(z)==54.5),]

p50<-cbind(as.matrix(p50.10), as.matrix(p50.55))
p50<-as.data.frame(p50)
colnames(p50)<-c("Lat10", "Lat55")
p50$depth<-rownames(p50)
rownames(p50)<-c()
p50$depth<-as.numeric(p50$depth)*-1

if(i==1){data.p50.2.H.m40<-p50}
if(i==2){data.p50.2.H.20<-p50}
if(i==3){data.p50.8.H.m40<-p50}

close.ncdf(nc)
}

merge10.p50.2.H.m40<-cbind(z.10, data.p50.2.H.m40$Lat10)
colnames(merge10.p50.2.H.m40)[4]<-"P50"
merge10.p50.2.H.m40$Above<-ifelse(merge10.p50.2.H.m40$P50<=merge10.p50.2.H.m40$PO2, merge10.p50.2.H.m40$P50, NA)
merge10.p50.2.H.m40$Below<-ifelse(merge10.p50.2.H.m40$P50>=merge10.p50.2.H.m40$PO2, merge10.p50.2.H.m40$P50, NA)

merge10.p50.2.H.20<-cbind(z.10, data.p50.2.H.20$Lat10)
colnames(merge10.p50.2.H.20)[4]<-"P50"
merge10.p50.2.H.20$Above<-ifelse(merge10.p50.2.H.20$P50<=merge10.p50.2.H.20$PO2, merge10.p50.2.H.20$P50, NA)
merge10.p50.2.H.20$Below<-ifelse(merge10.p50.2.H.20$P50>=merge10.p50.2.H.20$PO2, merge10.p50.2.H.20$P50, NA)

merge10.p50.8.H.m40<-cbind(z.10, data.p50.8.H.m40$Lat10)
colnames(merge10.p50.8.H.m40)[4]<-"P50"
merge10.p50.8.H.m40$Above<-ifelse(merge10.p50.8.H.m40$P50<=merge10.p50.8.H.m40$PO2, merge10.p50.8.H.m40$P50, NA)
merge10.p50.8.H.m40$Below<-ifelse(merge10.p50.8.H.m40$P50>=merge10.p50.8.H.m40$PO2, merge10.p50.8.H.m40$P50, NA)
merge10.p50.8.H.m40<-rbind(merge10.p50.8.H.m40, c(NA, NA, -890, 2.256559, 2.256559, 2.256559))
merge10.p50.8.H.m40<-merge10.p50.8.H.m40[order(merge10.p50.8.H.m40$Depth, decreasing=TRUE),]

merge55.p50.2.H.m40<-cbind(z.55, data.p50.2.H.m40$Lat55)
colnames(merge55.p50.2.H.m40)[4]<-"P50"
merge55.p50.2.H.m40$Above<-ifelse(merge55.p50.2.H.m40$P50<=merge55.p50.2.H.m40$PO2, merge55.p50.2.H.m40$P50, NA)
merge55.p50.2.H.m40$Below<-ifelse(merge55.p50.2.H.m40$P50>=merge55.p50.2.H.m40$PO2, merge55.p50.2.H.m40$P50, NA)
find<-approx(merge55.p50.2.H.m40$Depth, merge55.p50.2.H.m40$P50, -670) #P50 Depth is 670 m
merge55.p50.2.H.m40<-rbind(merge55.p50.2.H.m40, c(NA, NA, -670, find$y, find$y, find$y))
merge55.p50.2.H.m40<-merge55.p50.2.H.m40[order(merge55.p50.2.H.m40$Depth, decreasing=TRUE),]

merge55.p50.2.H.20<-cbind(z.55, data.p50.2.H.20$Lat55)
colnames(merge55.p50.2.H.20)[4]<-"P50"
merge55.p50.2.H.20$Above<-ifelse(merge55.p50.2.H.20$P50<=merge55.p50.2.H.20$PO2, merge55.p50.2.H.20$P50, NA)
merge55.p50.2.H.20$Below<-ifelse(merge55.p50.2.H.20$P50>=merge55.p50.2.H.20$PO2, merge55.p50.2.H.20$P50, NA)
merge55.p50.2.H.20$Below[14]<-merge55.p50.2.H.20$Above[14]  #P50 depth is 500 m

merge55.p50.8.H.m40<-cbind(z.55, data.p50.8.H.m40$Lat55)
colnames(merge55.p50.8.H.m40)[4]<-"P50"
merge55.p50.8.H.m40$Above<-ifelse(merge55.p50.8.H.m40$P50<=merge55.p50.8.H.m40$PO2, merge55.p50.8.H.m40$P50, NA)
merge55.p50.8.H.m40$Below<-ifelse(merge55.p50.8.H.m40$P50>=merge55.p50.8.H.m40$PO2, merge55.p50.8.H.m40$P50, NA)
merge55.p50.8.H.m40$Above[11]<-merge55.p50.8.H.m40$Below[11] #P50 Depth is 250 m


#------------------------------
#      Create Plot
#------------------------------

OutGraph<-"../Graphs/PointComparison.ps"
postscript(OutGraph, family="Helvetica", width=5, height=3, pointsize=12)

#quartz(h=3, w=5)
par(plt = c(0.10,0.22,0.10,0.75),   
    las = 1,                      # orientation of axis labels
    cex.axis = 0.8,                 # size of axis annotation
    tcl = -0.3,
    xaxs="i",
    yaxs="i")

plot(z.10$Temp, z.10$Depth, type="l", xaxt="n", xlim=c(0,30), yaxt="n", ylim=c(-1000,0), xlab="", ylab="", lwd=2)
axis(side=2, labels=TRUE, las=1, hadj=0.7)
axis(side=3, labels=FALSE, at=c(0,5,10,15,20,25,30))
axis(side=3, labels=c(0,15,30), at=c(0,15,30), mgp=c(0,0.4,0))
lines(z.10$PO2, z.10$Depth, lwd=2, col="grey55")
sltext<-expression(paste("Temp (C)", sep=""))
mtext(3,text=sltext, line=1.2, cex=0.8)
sltext2<-expression(paste("pO"[2], " (kPa)", sep=""))
mtext(3,text=sltext2, line=2.1, cex=0.8, col="grey55")


par(new = "TRUE",              
    plt = c(0.26,0.50,0.10,0.75),   
    las = 1,                      # orientation of axis labels
    cex.axis = 0.8,                 # size of axis annotation
    tcl = -0.3,
    xaxs="i",
    yaxs="i")

plot(merge10.p50.2.H.m40$Above,merge10.p50.2.H.m40$Depth, type="l", xlim=c(0,8), xaxt="n", yaxt="n", ylim=c(-1000,0), xlab="", ylab="", lwd=2, col="green4")
lines(merge10.p50.2.H.m40$Below, merge10.p50.2.H.m40$Depth, lty=3, lwd=2, col="green4")
lines(merge10.p50.2.H.20$Above, merge10.p50.2.H.20$Depth, lwd=2, col="blue")
lines(merge10.p50.2.H.20$Below, merge10.p50.2.H.20$Depth, lty=3, lwd=2, col="blue")
lines(merge10.p50.8.H.m40$Above, merge10.p50.8.H.m40$Depth, lwd=2, col="red")
lines(merge10.p50.8.H.m40$Below, merge10.p50.8.H.m40$Depth, lty=3, lwd=2, col="red")
lines(z.10$PO2, z.10$Depth, lwd=2, col="grey55")
axis(side=2, labels=FALSE)
axis(side=3, labels=FALSE, at=c(0,1,2,3,4,5,6,7,8))
axis(side=3, labels=c(0,2,4,6,8), at=c(0,2,4,6,8), mgp=c(0,0.4,0))
sltext3<-expression(paste("P"[50], " (kPa)", sep=""))
mtext(3,text=sltext3, line=1.2, cex=0.8)
sltext5<-expression(paste("pO"[2], " (kPa)", sep=""))
mtext(3,text=sltext5, line=2.1, cex=0.8, col="grey55")


par(new = "TRUE",              
    plt = c(0.57,0.69,0.10,0.75),   
    las = 1,                      # orientation of axis labels
    cex.axis = 0.8,                 # size of axis annotation
    tcl = -0.3,
    xaxs="i",
    yaxs="i")

plot(z.55$Temp, z.55$Depth, type="l", xaxt="n", xlim=c(0,30), yaxt="n", ylim=c(-1000,0), xlab="", ylab="", lwd=2)
axis(side=2, labels=FALSE, las=1, hadj=0.7)
axis(side=3, labels=FALSE, at=c(0,5,10,15,20,25,30))
axis(side=3, labels=c(0,15,30), at=c(0,15,30), mgp=c(0,0.4,0))
lines(z.55$PO2, z.55$Depth, lwd=2, col="grey55")
sltext4<-expression(paste("Temp (C)", sep=""))
mtext(3,text=sltext4, line=1.2, cex=0.8)
sltext5<-expression(paste("pO"[2], " (kPa)", sep=""))
mtext(3,text=sltext5, line=2.1, cex=0.8, col="grey55")


par(new = "TRUE",              
    plt = c(0.73,0.97,0.10,0.75),   
    las = 1,                      # orientation of axis labels
    cex.axis = 0.8,                 # size of axis annotation
    tcl = -0.3,
    xaxs="i",
    yaxs="i")

plot(merge55.p50.2.H.m40$Above, merge55.p50.2.H.m40$Depth, type="l", xlim=c(0,8), xaxt="n", yaxt="n", ylim=c(-1000,0), xlab="", ylab="", lwd=2, col="green4")
lines(merge55.p50.2.H.m40$Below, merge55.p50.2.H.m40$Depth, lty=3, lwd=2, col="green4")
lines(merge55.p50.2.H.20$Above, merge55.p50.2.H.20$Depth, lwd=2, col="blue")
lines(merge55.p50.2.H.20$Below, merge55.p50.2.H.20$Depth, lty=3, lwd=2, col="blue")
lines(merge55.p50.8.H.m40$Above, merge55.p50.8.H.m40$Depth, lwd=2, col="red")
lines(merge55.p50.8.H.m40$Below, merge55.p50.8.H.m40$Depth, lty=3, lwd=2, col="red")
lines(z.55$PO2, z.55$Depth, lwd=2, col="grey55")
axis(side=2, labels=FALSE)
axis(side=3, labels=FALSE, at=c(0,1,2,3,4,5,6,7,8))
axis(side=3, labels=c(0,2,4,6,8), at=c(0,2,4,6,8), mgp=c(0,0.4,0))
sltext3<-expression(paste("P"[50], " (kPa)", sep=""))
mtext(3,text=sltext3, line=1.2, cex=0.8)
sltext5<-expression(paste("pO"[2], " (kPa)", sep=""))
mtext(3,text=sltext5, line=2.1, cex=0.8, col="grey55")

dev.off()