library(gstat)
library(sp)
library(FNN)
plot(grd, xlab="X-coordinates", ylab="Y-coordinates")
plot(basin.sp, border="green", lwd=2, add=T)
points(df.P.200$x, df.P.200$y, cex=df.P.200$P/20, pch=19, col="red")
legend("topleft", legend=c("10mm", "50mm"), pch=19, col="maroon", pt.cex=c(10, 50)/20, bty="o", bg="white", box.col="black", text.col="black")
# set the color palette
prec.palette <- colorRampPalette(c("white", "blue","yellow","red"), space = "rgb")
plot(basin.sp,border="maroon",xlab="X-coordinates", ylab="Y-coordinates")
points(df.P.33$x,df.P.33$y,cex=df.P.33$P/20,pch=19,col="blue")
plot(grd,add=T)
legend("topleft",legend=c("10mm","50mm"),pch=19, col="blue", pt.cex=c(10,50)/20,bty="n")
prec.palette <- colorRampPalette(c("white", "blue", "yellow", "red"), space = "rgb")
plot(basin.sp, border="maroon", xlab="X-coordinates", ylab="Y-coordinates")
points(df.P.33$x, df.P.33$y, cex=df.P.33$P/20, pch=19, col="blue")
plot(grd, add=T)
legend("topleft", legend=c("10mm", "50mm"), pch=19, col="blue", pt.cex=c(10, 50)/20, bty="n")
coordinates(df.P.33) = c("x","y")
grd.idw = idw(P~1, locations = df.P.33, newdata = grd)
layout(matrix(c(1,2), nrow=1, ncol=2), widths=c(4,1), heights=c(1))
image(grd.idw, col = prec.palette(100),
      xlim=c(630000,720000),ylim=c(150000,270000),
      xlab="X-coordinates", ylab="Y-coordinates")
plot(basin.sp,border="maroon",lwd=2,add=T)
points(df.P.33$x,df.P.33$y,cex=df.P.33$P/20,pch=19,col="black")
breaks <- seq(min(grd.idw@data$var1.pred), max(grd.idw@data$var1.pred),length.out=100)
image.scale(grd.idw@data$var1.pred, col=prec.palette(length(breaks)-1), breaks=breaks,
            horiz=F,xlab="",ylab="")
# selection of the grids points inside the watershed
coords.basin = basin.sp@polygons[[1]]@Polygons[[1]]@coords
coords.grd = grd@coords
is.grd.in.basin = point.in.polygon(coords.grd[,1],coords.grd[,2],
                                   coords.basin[,1],coords.basin[,2])
# nearest neighbour method
P.knn <- P.knn <-mean(grd.knn@data$P[as.logical(is.grd.in.basin)])
# inverse distance
P.idw <- mean(grd.idw@data$var1.pred[as.logical(is.grd.in.basin)])
# thiessen polygons
Thiessen.Weights
print(sum(Thiessen.Weights))
P.TW <- sum(Thiessen.Weights*df.P.33$P)
#Sort the Thiessen weights. What is the maximum weight ? To which polygon does it correspond ?
library(dplyr)
stations_to_extract <- c("Otelfingen", "Disentis / Sedrun", "Sarnen", "Cham", "Mettmenstetten", "Sattel-Aegeri", "Trun")
extracted_stations <- df.P.200 %>%
  filter(nom %in% stations_to_extract) %>%
  select(P, nom)
print(extracted_stations)
library(dplyr)
library(readxl)
file_path <- "D:/Python_Practice/Streamflow_Visualization/Thiesson_data.xlsx"
thiessen_data <- read_excel(file_path)
colnames(thiessen_data) <- c("P", "nom", "Thiessen_Weight")
weighted_rainfall <- sum(thiessen_data$P * thiessen_data$Thiessen_Weight, na.rm = TRUE)
print(weighted_rainfall)
 
