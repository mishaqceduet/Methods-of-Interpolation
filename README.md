Here’s the updated README with your email address included:

```markdown
# Comparison of Interpolation Methods for Rainfall Data Analysis and Visualization in a Watershed

## Overview

This repository contains R scripts and data files for comparing different interpolation methods used for rainfall data analysis and visualization within a watershed. The methods compared include Inverse Distance Weighting (IDW), Thiessen polygons, and the nearest neighbor method.

## Table of Contents
1. [Features](#features)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Contribution](#contribution)
5. [License](#license)
6. [Contact](#contact)

## Features
- **Data Loading and Preparation**: Reads and preprocesses precipitation data from Excel files.
- **Spatial Interpolation**: Implements IDW for spatial interpolation of precipitation data.
- **Thiessen Polygon Method**: Calculates weighted average precipitation using Thiessen polygons.
- **Visualization**: Plots the watershed, rain gauge stations, Thiessen polygons, and interpolated precipitation surfaces.

## Installation
Ensure you have R and the following packages installed:

```R
install.packages(c("readxl", "dplyr", "sf", "ggplot2", "ggspatial", "gstat", "sp", "FNN"))
```

## Usage
1. **Load Data**:
   Load precipitation data and Thiessen weights from an Excel file.

   ```R
   library(readxl)
   library(dplyr)

   file_path <- "D:/Python_Practice/Streamflow_Visualization/Thiesson_data.xlsx"
   thiessen_data <- read_excel(file_path)
   colnames(thiessen_data) <- c("P", "nom", "Thiessen_Weight")
   ```

2. **Extract Specific Stations**:
   Extract precipitation data for specific rain gauge stations.
   
   ```R
   stations_to_extract <- c("Otelfingen", "Disentis / Sedrun", "Sarnen", "Cham", "Mettmenstetten", "Sattel-Aegeri", "Trun")
   extracted_stations <- df.P.200 %>%
     filter(nom %in% stations_to_extract) %>%
     select(P, nom)
   print(extracted_stations)
   ```

3. **Calculate Weighted Rainfall**:
   Calculate the weighted average rainfall using Thiessen weights.
   
   ```R
   weighted_rainfall <- sum(thiessen_data$P * thiessen_data$Thiessen_Weight, na.rm = TRUE)
   print(weighted_rainfall)
   ```

4. **Plotting**:
   Visualize the watershed, rain gauge stations, and Thiessen polygons.
   
   ```R
   library(sf)
   library(ggplot2)
   library(ggspatial)

   # Convert data to spatial objects
   thiessen_data <- thiessen_data %>%
     mutate(
       latitude = c(46.953, 46.704, 46.900, 47.182, 47.243, 47.055, 46.742),
       longitude = c(8.307, 8.769, 8.250, 8.456, 8.463, 8.635, 8.993)
     )

   stations_sf <- st_as_sf(thiessen_data, coords = c("longitude", "latitude"), crs = 4326)
   voronoi <- st_voronoi(st_union(stations_sf))
   thiessen_polygons <- st_collection_extract(voronoi)
   bounding_box <- st_as_sfc(st_bbox(stations_sf))
   clipped_polygons <- st_intersection(st_as_sf(thiessen_polygons), bounding_box)
   thiessen_sf <- st_sf(geometry = clipped_polygons, crs = 4326)

   # Plotting
   ggplot() +
     geom_sf(data = thiessen_sf, fill = NA, color = "blue") +  # Thiessen polygons
     geom_sf(data = stations_sf, color = "red", size = 2) +    # Rain gauge stations
     theme_minimal() +
     ggtitle("Thiessen Polygons and Rain Gauge Stations") +
     xlab("Longitude") +
     ylab("Latitude") +
     annotation_scale(location = "bl", width_hint = 0.5) +
     annotation_north_arrow(location = "tl", which_north = "true", style = north_arrow_fancy_orienteering)
   ```

5. **Spatial Interpolation with IDW**:
   Interpolate precipitation data using IDW and visualize the result.
   
   ```R
   library(gstat)
   library(sp)
   
   coordinates(df.P.33) <- c("x", "y")
   grd.idw <- idw(P ~ 1, locations = df.P.33, newdata = grd)
   
   prec.palette <- colorRampPalette(c("white", "blue", "yellow", "red"), space = "rgb")
   
   layout(matrix(c(1, 2), nrow = 1, ncol = 2), widths = c(4, 1), heights = c(1))
   image(grd.idw, col = prec.palette(100),
         xlim = c(630000, 720000), ylim = c(150000, 270000),
         xlab = "X-coordinates", ylab = "Y-coordinates")
   plot(basin.sp, border = "maroon", lwd = 2, add = TRUE)
   points(df.P.33$x, df.P.33$y, cex = df.P.33$P / 20, pch = 19, col = "black")
   breaks <- seq(min(grd.idw@data$var1.pred), max(grd.idw@data$var1.pred), length.out = 100)
   image.scale(grd.idw@data$var1.pred, col = prec.palette(length(breaks) - 1), breaks = breaks, horiz = FALSE, xlab = "", ylab = "")
   ```

## Contribution
Feel free to contribute by submitting a pull request or reporting an issue. Contributions to improve the code or documentation are welcome.

## License
This project is licensed under the MIT License.

## Contact
For any inquiries or feedback, please contact Muhammad Ishaq at muhammad.ishaq@uetpeshawar.edu.pk.
