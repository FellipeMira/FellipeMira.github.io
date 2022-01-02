library(tidyverse)
library(geobr)
library(tmap)

getwd()

setwd("C:/Users/Fellipe/Desktop/git/fellipe.mira.github.io/")
  
url <- "https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-states.csv"

dados <- readr::read_csv(url)

glimpse(dados)

dados$state <- as.factor(dados$state)

a <- dados %>%
  select(state, deaths) %>%
  group_by(state) %>%
  summarise(total_estado = sum(deaths))
  

states <- read_state(year = 2019)

dados_com_geom <- right_join(x = a,
                             y = states,
                             by= c("state" = "abbrev_state"))


dados_com_geom <- sf::st_as_sf(as.data.frame(dados_com_geom))


class(dados_com_geom)
dados_com_geom %>% glimpse()

tmap_mode(mode = 'view')
tm_shape(dados_com_geom)+
  tm_fill('total_estado',
          palette = 'Blues')+
  tm_shape(dados_com_geom)+
  tm_borders(col = 'gray')
  
library(echarts4r.maps)
e_charts(dados_com_geom) |>
  em_map("Brazil") |> 
  e_geo(map = "Brazi") |> 
  e_visual_map(total_estado) |> 
  e_theme("infographic")
  
  

e_charts(dados_com_geom,
         x = ) %>%
  em_map("Brazil") %>% 
  e_geo(map = "Brazil") 

################################################################################
br <- jsonlite::read_json("https://code.highcharts.com/mapdata/countries/br/br-all.geo.json")

e_charts(dados_com_geom,
         x = total_estado) %>% 
  e_map_register("BR", 
                 br) %>% 
  e_map(total_estado,
        map = "BR") %>% 
  e_visual_map(total_estado)
  

