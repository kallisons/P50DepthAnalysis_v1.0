#Change working directory to P50DepthAnalysis_v1.0/RCode using the setwd() command or using the Misc menu.  
#getwd() #shows the current working directory for the R gui.  

#The code in this file compares the output produced by P50Depth_maps.sh with test files to make sure that the output is the same.  If the files have the same data (to 3 significant digits), then the tests are passed.  A passed test means that P50 depth analysis code worked!  If the tests fail, the code is not working.

library(ncdf)


decimalplaces <- function(x) {      
       hold<-strsplit(sub('0+$', '', as.character(x)), ".", fixed=TRUE)
       hold2<-ifelse(hold=="character(0)", list(c("","")), hold)
       df<-data.frame(matrix(unlist(hold2), nrow=length(hold2), byrow=T))
       nchar(as.character(df[,2])) 
   };


TableCompare <- function(filename.new, filename.old) {

	#filename.new<-paste("../Results/P50Depth/P50Depth_p50_2.0_deltaH_-40.nc")
	#filename.old<-paste("../TestFiles/P50Depth/P50Depth_p50_2.0_deltaH_-40.nc")

	new.nc <- open.ncdf(filename.new)
	old.nc <- open.ncdf(filename.old)
	
	new <- get.var.ncdf(new.nc, start=c(1,1,1), count=c(360,180,1))
	old <- get.var.ncdf(old.nc, start=c(1,1,1), count=c(360,180,1))
	

#--------------------------------------------------------
# Round to 3 significant digits
#--------------------------------------------------------	
	new <- signif(new, digits=4)
	old <- signif(old, digits=4)

	#-----------------------------------------------------
	# Check if there are the same number of rows in files
	#-----------------------------------------------------
	rowcomp <- abs(nrow(new) - nrow(old))

	if (rowcomp > 0) {
		cat("***ERROR***\n")
		cat("*Different Numbers of Rows*\n")
		cat(paste(filename.new, "\n", sep = ""))
		cat(paste(filename.old, "\n", sep = ""))
		cat("--------------\n")
		stop("FAILS TEST, Exiting RScript")
	}

	#--------------------------------------------------------
	# Check if there are the same number of columns in files
	#--------------------------------------------------------
	colcomp <- abs(ncol(new) - ncol(old))

	if (colcomp > 0) {
		cat("***ERROR***\n")
		cat("*Different Numbers of Columns*\n")
		cat(paste(filename.new, "\n", sep = ""))
		cat(paste(filename.old, "\n", sep = ""))
		cat("--------------\n")
		stop("FAILS TEST, Exiting RScript")
	}

	#-----------------------------------------------------
	# Check values in tables
	#-----------------------------------------------------
	numcols <- ncol(new)

	for (i in 1:ncol(new)) {

		diffcols <- abs(new[, i] - old[, i])

		finddiffs <- which(diffcols > 0)

		#---------------------------------
		# Find rounding errors 
		#---------------------------------

		if (length(finddiffs > 0)) {
			vals <- new[finddiffs, i]

			thds <- c()

			for (k in 1:length(vals)) {
					thds <- c(thds, 1 * 10^(-decimalplaces(vals[k])))
			}

			diffvals <- diffcols[finddiffs]
			bigdiffs <- subset(finddiffs, diffvals > thds)

		#-----------------------------
		# Print non-rounding errors 
		#-----------------------------
			if (length(bigdiffs) > 0) {
				for (j in 1:length(bigdiffs)) {
					cat("***ERROR***\n")
					cat("*Different Values*\n")
					cat(paste("col=", i, "\t row=", bigdiffs[j], "\n", sep = ""))
					cat(paste("File 1:\n", sep = ""))
					cat(paste(filename.new, "\n", sep = ""))
					cat(paste("value=", new[bigdiffs[j], i], "\n", sep = ""))
					cat(paste("File 2:\n", sep = ""))
					cat(paste(filename.old, "\n", sep = ""))
					cat(paste("value=", old[bigdiffs[j], i], "\n", sep = ""))
					cat("--------------\n")
					stop("FAILS TEST, Exiting RScript")
				}
			}
		}
	}
	cat("***PASSES ALL COMPARISON TESTS***\n")
	cat(paste("File 1:\n", sep = ""))
	cat(paste(filename.new, "\n", sep = ""))
	cat(paste("File 2:\n", sep = ""))
	cat(paste(filename.old, "\n", sep = ""))
	cat("--------------\n")
	
close.ncdf(new.nc)
close.ncdf(old.nc)

}

TableCompare("../Results/P50Depth/P50Depth_P50_2.0_deltaH_-40.nc", "../TestFiles/P50Depth/P50Depth_P50_2.0_deltaH_-40.nc")
TableCompare("../Results/P50Depth/P50Depth_P50_2.0_deltaH_20.nc", "../TestFiles/P50Depth/P50Depth_P50_2.0_deltaH_20.nc")
TableCompare("../Results/P50Depth/P50Depth_P50_8.0_deltaH_-40.nc", "../TestFiles/P50Depth/P50Depth_P50_8.0_deltaH_-40.nc")

