#Analysis of Results: Geographic comparison of latitudinal gradients along the transect between 10 and 20 degrees N and between 20 degrees North and 59 degrees North

#Change working directory to P50DepthAnalysis_v1.0/RCode using the setwd() command or using the Misc menu.  
#getwd() #shows the current working directory for the R gui.  

require(ncdf)
#require(fields)
#require(RColorBrewer)
#require(colorRamps)
#require(caTools)

source('filled.contour/filled.contour.R', chdir = TRUE)
source('filled.contour/filled.legend.R', chdir = TRUE)

trans.lon<-220.5

#------------------------------
#      Environmental Data
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

#Oxygen data formatted for graph
rownames(z.po2)<-lats.po2
colnames(z.po2)<-depths.po2
depths.po2<-abs(depths.po2)*-1
depths.po2<-depths.po2[order(depths.po2)]
z.po2<-z.po2[,ncol(z.po2):1]

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

#Temperature data formatted for graph
depths.temp<-abs(depths.temp)*-1
depths.temp<-depths.temp[order(depths.temp)]
z.temp<-z.temp[,ncol(z.temp):1]


#Calculate the mean oxygen gradient 
#nc.po2<-open.ncdf(pO2_filepath)
#lats.po2<-nc.po2$dim$LATITUDE$vals
#lats.po2<-sort(lats.po2)
#lons.po2<-nc.po2$dim$LONGITUDE$vals
#depths.po2<-nc.po2$dim$DEPTH$vals
#z.po2<-get.var.ncdf(nc.po2, nc.po2$var[[2]], start=c(which(lons.po2==trans.lon),1,1,1), count=c(1,length(lats.po2),length(depths.po2),1))
#close.ncdf(nc.po2)
#rownames(z.po2)<-lats.po2
#colnames(z.po2)<-depths.po2
#z.po2.subset<-subset(z.po2, as.numeric(rownames(z.po2))>=-10 & as.numeric(rownames(z.po2))<=60)
#t.z.po2<-t(z.po2.subset)
#t.z.po2<-t.z.po2[nrow(t.z.po2):1,]
#diff.po2<-diff(t.z.po2)/diff(as.numeric(rownames(t.z.po2)))
#diff.mins<-apply(diff.po2[,1:69], 2, min, na.rm=TRUE)
#mins.south<-subset(diff.mins, as.numeric(names(diff.mins))>=10 & as.numeric(names(diff.mins))<=20)
#mins.north<-subset(diff.mins, as.numeric(names(diff.mins))>20 & as.numeric(names(diff.mins))<=59)
#print(mean(mins.south, na.rm=TRUE))
#print(sd(mins.south, na.rm=TRUE))
#print(mean(mins.north, na.rm=TRUE))
#print(sd(mins.north, na.rm=TRUE))

#Calculate temperature statistics from data
#nc.temp<-open.ncdf(Temp_filepath)
#lats.temp<-nc.temp$dim$lat$vals
#lats.temp<-sort(lats.temp)
#lons.temp<-nc.temp$dim$lon$vals
#depths.temp<-nc.temp$dim$depth$vals
#z.temp<-get.var.ncdf(nc.temp, nc.temp$var[[4]], start=c(which(lons.temp==trans.lon),1,1,1), count=c(1,length(lats.temp),length(depths.temp),1))
#close.ncdf(nc.temp)
#rownames(z.temp)<-lats.temp
#colnames(z.temp)<-depths.temp
#z.temp.10m<-z.temp[,2]
#print(z.temp.10m[which(names(z.temp.10m)=="20.5")]-z.temp.10m[which(names(z.temp.10m)=="40.5")])









#-----------------------
#    P50 Depth
#-----------------------
folder<-paste("../Results/P50Depth/")
filenames<-list.files(path=folder, pattern=NULL, full.names=FALSE, recursive=FALSE)
filenames<-filenames[-4]

p50vals <- c()
deltaHvals <- c()
#collist <- c()
#m<-8

#colornums<-colorRampPalette(brewer.pal(9,"Greys"))(10)
#colornums<-colornums[length(colornums):1]

#colornums<-brewer.pal(6,"Set1")
#colornums<-colornums[length(colornums):1]
#colornums<-colornums[c(1,3,5,7,9,11)]

#collist<-c("black", "green4", "blue", "red")
#ltylist<-c(3,1,1,1)

for(i in 1:length(filenames)){

nc<-open.ncdf(paste(folder, filenames[i], sep=""))

dims<-nc$var[[1]]$ndim
lats<-nc$dim$LATITUDE$vals
lats<-sort(lats)
lons<-nc$dim$LONGITUDE$vals
z<-get.var.ncdf(nc, nc$var[[1]], start=c(1,1,1), count=c(length(lons),length(lats),1))

rownames(z)<-lons
colnames(z)<-lats

p50<-substr(filenames[i], 9,11)
p50<-gsub("_", "", p50)

p50vals<-c(p50vals, p50)

deltaH<-substr(filenames[i], 19, nchar(filenames[i]))
deltaH<-gsub(".nc", "", deltaH)
deltaH<-gsub("_", "", deltaH)

deltaHvals<-c(deltaHvals, deltaH)

#if(i==1){data.60.umolkg<-z[which(rownames(z)==trans.lon),]}
if(i==2){data.p50.2.H.m40<-z[which(rownames(z)==trans.lon),]}
if(i==3){data.p50.2.H.20<-z[which(rownames(z)==trans.lon),]}
if(i==4){data.p50.8.H.m40<-z[which(rownames(z)==trans.lon),]}

close.ncdf(nc)
}

#------------------------------
#      Create Plot
#------------------------------

OutGraph<-paste("../Graphs/TransectComparison.ps")
postscript(OutGraph, family="Helvetica", width=3, height=7, pointsize=12)

#quartz(h=7, w=3)
par(new = "TRUE",              
    plt = c(0.15,0.75,0.70,0.95),   
    las = 1,                      # orientation of axis labels
    cex.axis = 1,                 # size of axis annotation
    tck = -0.04,
    xaxs="i",
    yaxs="i")


plot(names(data.60.umolkg), data.60.umolkg*-1, type="l", xlim=c(-10,60), xaxt="n", yaxt="n", ylim=c(-1000,0), col="black", lty=3, lwd=2.5, xlab="")
lines(names(data.p50.2.H.m40), data.p50.2.H.m40*-1, col="green4", lty=1, lwd=2.5) 
lines(names(data.p50.2.H.20), data.p50.2.H.20*-1, col="blue", lty=1, lwd=2.5) 
lines(names(data.p50.8.H.m40), data.p50.8.H.m40*-1, col="red", lty=1, lwd=2.5) 
axis(side=1, labels=FALSE)
axis(side=2, labels=TRUE, las=2)

text(55,-190,"C",col="red")
text(55,-450,"B",col="blue")
text(55,-620,"A",col="green4")

#legendvals<-as.data.frame(cbind(p50vals, deltaHvals, collist), stringsAsFactors=FALSE)
#colnames(legendvals)<-c("p50", "deltaH", "colors")
#legendvals[1,1:2]<-c(NA, NA)
#legendvals$type<-c("60 umol kg", "type A", "type B", "type C")
#legend(-8, -700, c(legendvals$type), seg.len=0.80, lty=ltylist, ncol=1, lwd=2.5, cex=1, xjust=0, col=c(legendvals$colors), y.intersp=0.9, x.intersp=0.8)
#mtext("Depth (m)", side=2, line=1, cex=1.0, outer=TRUE)

par(new = "TRUE",              
    plt = c(0.15,0.75,0.40,0.65),                                    
    las = 1,                      
    cex.axis = 1,                 # size of axis annotation
    tck = -0.04
    ) 

filled.contour3(lats.po2,depths.po2,z.po2, xlim=c(-10,60), ylim=c(-1000,0), zlim=c(0, 25), axes=FALSE, color.palette = colorRampPalette(c("grey20","grey","darkgreen","yellowgreen","lightyellow")))
axis(side=1, at=seq(-10,60,10), labels=FALSE)
axis(side=2, at=seq(-1000,0,200), labels=TRUE)
axis(side=3, at=c(-10,60), lwd.ticks=0, labels=FALSE)
axis(side=4, at=c(-1000, 0), lwd.ticks=0, labels=FALSE)
lines(names(data.60.umolkg), data.60.umolkg*-1, col="white", lty=3, lwd=2.5)
lines(names(data.p50.2.H.m40), data.p50.2.H.m40*-1, col="white", lty=1, lwd=2.5) 
lines(names(data.p50.2.H.20), data.p50.2.H.20*-1, col="white", lty=1, lwd=2.5) 
lines(names(data.p50.8.H.m40), data.p50.8.H.m40*-1, col="white", lty=1, lwd=2.5) 

#color.palette = colorRampPalette(c("lightblue","blue","darkgreen","yellowgreen","lightyellow"))

par(new = "TRUE",
    plt = c(0.8,0.85,0.40,0.65),   # define plot region for legend
    las = 1,
    cex.axis = 0.8,
    tck=-0.4)

filled.legend(lats.po2,depths.po2,z.po2, xlim=c(-10,60), ylim=c(-1000,0), zlim=c(0, 25), color.palette=colorRampPalette(c("grey20","grey","darkgreen","yellowgreen","lightyellow")))
filled.legend(lats.po2,depths.po2,z.po2, xlim=c(-10,60), ylim=c(-1000,0), zlim=c(0, 25), color.palette=colorRampPalette(c("grey20","grey","darkgreen","yellowgreen","lightyellow")))


par(new = "TRUE",              
    plt = c(0.15,0.75,0.10,0.35),                                    
    las = 1,                      
    cex.axis = 1,                 # size of axis annotation
    tck = -0.04)   
    
filled.contour3(lats.temp,depths.temp,z.temp,xlim=c(-10,60), ylim=c(-1000,0), zlim=c(0,30), color.palette = colorRampPalette(c("lightblue","navy", "purple", "red","orange","lightyellow")))
lines(names(data.60.umolkg), data.60.umolkg*-1, col="white", lty=3, lwd=2.5)
lines(names(data.p50.2.H.m40), data.p50.2.H.m40*-1, col="white", lty=1, lwd=2.5) 
lines(names(data.p50.2.H.20), data.p50.2.H.20*-1, col="white", lty=1, lwd=2.5) 
lines(names(data.p50.8.H.m40), data.p50.8.H.m40*-1, col="white", lty=1, lwd=2.5) 

par(new = "TRUE",
    plt = c(0.8,0.85,0.10,0.35),   # define plot region for legend
    las = 1,
    cex.axis = 0.8,
    tck=-0.4)

filled.legend(lats.temp,depths.temp,z.temp,xlim=c(-10,60), ylim=c(-1000,0), zlim=c(0,30), color.palette = colorRampPalette(c("lightblue", "navy", "purple", "red","orange","lightyellow")))
filled.legend(lats.temp,depths.temp,z.temp,xlim=c(-10,60), ylim=c(-1000,0), zlim=c(0,30), color.palette = colorRampPalette(c("lightblue", "navy", "purple", "red","orange","lightyellow")))

#mtext("Latitude", side=1, line=0, cex=1.0, outer=TRUE)

dev.off()



