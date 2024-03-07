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
    filter(fire_id %in% non_defol_names)
  
  ################## ADD DEFOL COLUMN #############
  
  # get row numbers and set first
  data.d.length.out <- nrow(data.d)
  data.nd.length.out <- nrow(data.nd)
  data.length.in <- 1
  
  data.d <-  data.d |> 
    mutate(defoliated = rep(data.length.in,data.d.length.out))
  data.nd <- data.nd |> 
    mutate(defoliated = rep(data.length.in, data.nd.length.out))
  
  # relocate geo column
  
  data.d <- data.d |> 
    relocate(geometry, .after = defoliated)
  
  data.nd <- data.nd |> 
    relocate(geometry, .after = defoliated)
  
  ##################### merge crs ###############
  
  data.nd <-  data.nd |> 
    st_transform(st_crs(data.d))
  
  data <- list(data.nd, data.d)
  
  return(data)
}


output_data <- function(data.list, df.name, RES_DIR){
  
  if(df.name == "data.d"){
    data <- data.list[names(data.list) = "data.d"]
    data <- do.call(rbind, data)
    path <- paste0(RES_DIR, "defoliated_perimeters.shp")
  } else if(df.name == "data.nd"){
    
    data <- data.list[names(data.list) = "data.nd"]
    data <- do.call(rbind, data)
    path <- paste0(RES_DIR, "non_defoliated_perimeters.shp")
    
  }
  
  sf::write_sf(data, path)
  
}

