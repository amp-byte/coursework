DSCI605 HW12

#install.packages("ggnewscale")
library(tidyverse)
library(raster)          #raster()
library(sf)              #st_read()
library(ggspatial)       #annotation_scale, annotation_north_arrow
library(ggnewscale)      #new_scale_color() 
library(ggmap)            #scalebar()

setwd("/Users/ampops/Desktop/DSCI605LABS2")

### Read all states in USA. Please note tl_2019_us_state.shp is located in the file folder "tl_2019_us_state". A shapefile data includes many files in the file folder. You cannot have only file "tl_2019_us_state.shp". 

us_states_sf <- st_read("/Users/ampops/Desktop/DSCI605LABS2/data/tl_2019_us_state/tl_2019_us_state.shp")

##Select Indiana (IN) from the object "state". This process is analogous to working with data frames. You can perform a similar operation for the cities.
state = us_states_sf[us_states_sf$STUSPS == "IN",]

##Read the Watershed in Indiana. Similar like the all states in USA.
watershed <- st_read("/Users/ampops/Desktop/DSCI605LABS2/data/Watersheds_HUC08_2009/WATERSHEDS_HUC08_2009_USDA_IN.shp")

##Read the Polygons of cities in Indiana. Similar like the all states in USA.
place <-  st_read("/Users/ampops/Desktop/DSCI605LABS2/data/tl_2016_18_place/tl_2016_18_place.shp")

##Select cities of interest
Somecities <- place %>% 
  filter(NAME %in% c("Muncie", "Carmel"))

ggplot() +
  geom_sf(data = state) +
  geom_sf(data = watershed, alpha = 0) +
  geom_sf(data = place) +
  xlab("Longitude") + 
  ylab("Latitude") +
  ggtitle("Map of Indiana", subtitle = paste0("(",length(unique(place$NAME)), " places)"))

cv1 = colorspace::diverge_hcl(20)

#watershed
ggplot(data = state) +
  geom_sf(data = watershed, aes(fill = REGION)) +
  scale_fill_manual(values = cv1) +
  guides(fill = guide_legend(title = "Watershed Regions")) +
  
  # watershed color fill
  # indiana red state line
  new_scale_fill() +
  geom_sf(data = state, linewidth = 1, alpha = 0, aes(color = "A", show.legend = "polygon")) +
  geom_sf(data = watershed, alpha = 0, aes(color = "B", show.legend = "polygon")) +
  scale_color_manual(values = c("A" = "red", "B" = "black"), labels = c("Indiana", "Watershed"), name = " ") +
  #cities
  new_scale_color() +
  geom_sf(data = Somecities, aes(fill = as.factor(NAME))) +
  scale_fill_manual(values = c("red", "green")) + #legend fill city with a color
  theme(legend.position = "right",
        plot.title = element_text(hjust = 0.5, color = "gray40", size = 16, face = "bold"), 
        
        #dark grey title coloring
        plot.subtitle = element_text(color = "blue"), #X cities selected color
        plot.caption = element_text(color = "gray60")) + #light gray subtitle coloring
  guides(fill = guide_legend(title = "IN Cities")) +
  
  #map items using annotation_scale because ggsn doesn't install
  annotation_scale(data = state, location= "bl", width_hint = 0.5) + #the scale bar
  #north arrow
  annotation_north_arrow(location = "br", which_north = "true",
                         pad_x = unit(0, "in"), pad_y = unit(0.2, "in"),
                         style = north_arrow_fancy_orienteering) +
  coord_sf(xlim = c(-89, -83), ylim = c(37, 43)) + # puts the north arrow in the bottom right corner
  
  # x and y label and title font
  theme(text = element_text(size = 20)) +
  xlab("Longitude") + 
  ylab("Latitude") +
  ggtitle("Map of Indiana Watershed and Major Cities", subtitle = paste0("(", length(unique(Somecities$NAME)), " cities selected)")) #include number of cities selected 
