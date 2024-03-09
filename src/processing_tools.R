# processing tools



#' Read in data
#'
#' @param file 
#'
#' @return dataframe
#' @export
#'
#' @examples
getData <- function(file){
  
  sf::read_sf(file)
}

clean_overlap <- function(data.d, data.nd){
  require(sf)
  require(tidyverse)
  #filter data difference to be greater than 1
  data.nd <- data.nd |> 
    filter(area_ha >=1)
  
  # get paired fire names
  non.defol.names <- data.nd |> 
    pull(fire_id)
  
  data.d <- data.d |> 
    filter(fire_id %in% non.defol.names)
  
  ################## ADD DEFOL COLUMN #############
  
  # get row numbers and set first
  data.d.length.out <- nrow(data.d)
  data.nd.length.out <- nrow(data.nd)
  data.length.in <- 1
  data.length.in.nd <- 0
  
  data.d <-  data.d |> 
    mutate(defoliated = rep(data.length.in,data.d.length.out))
  data.nd <- data.nd |> 
    mutate(defoliated = rep(data.length.in.nd, data.nd.length.out))
  
  # relocate geo column
  
  data.d <- data.d |> 
    relocate(geometry, .after = defoliated)
  
  data.nd <- data.nd |> 
    relocate(geometry, .after = defoliated)
  
  ##################### merge crs ###############
  
  data.nd <-  data.nd |> 
    st_transform(st_crs(data.d))
  
  # change crs to wgs 
  data.nd <- st_transform(data.nd, 4326)
  data.d <- st_transform(data.d, 4326)
  

  
  data <- list(data.nd, data.d)
  
  return(data)
}


clean_names <- function(x){
  if("fire_year" %in% colnames(x)){
    x <- rename(x, Fire_Year = fire_year)
  }
  if("fire_id" %in% colnames(x)){
    x <- rename(x, Fire_ID = fire_id)
  }
  if("cmltve_yrs" %in% colnames(x)){
    x <- rename(x, cumltve_yrs = cmltve_yrs)
  }
  if("defoliated" %in% colnames(x)){
    x <- rename(x, defoliated = defoliated)
  }
  
  return(x)
  
}


output_data <- function(data.list, df.name, RES_DIR){
  source("src/fire_area.R")
  if(df.name == "data.d"){
    data <- data.list[[2]]
    path <- paste0(RES_DIR, "defoliated_perimeters.shp")
    data <- clean_names(data)
  } else if(df.name == "data.nd"){
    data <- data.list[[1]]
    path <- paste0(RES_DIR, "non_defoliated_perimeters.shp")
    data <- clean_names(data)
    
  }
  
  sf::write_sf(data, path)
  
}

setCrs <- function(df1, df2){
  require(sf)
  if(st_crs(df1) != st_crs(df2)){
    crs.df1 <- st_crs(df1)
    
    df2 <- st_transform(df2, st_crs(crs.df1))
    
  }
  
  return(df2)
  
}


