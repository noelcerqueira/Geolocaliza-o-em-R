#-------- geobr ----

# geobr is a computational package to download official spatial data sets of Brazil. 
# The package includes a wide range of geospatial data as simple features or geopackages, available at 
# various geographic scales and for various years with harmonized attributes, projection and topology 
# (see detailed list of available data sets below). 

# Available datasets:

#  Function                         Geographies available     Years available                         Source
#  
#  read_country                     Country                   1872, 1900, 1911, 1920, 1933, 1940,     IBGE
#                                                             1950, 1960, 1970, 1980, 1991, 2000, 
#                                                             2001, 2010, 2013, 2014, 2015, 2016, 
#                                                             2017, 2018
#  read_region                      Region                    2000, 2001, 2010, 2013, 2014, 2015,     IBGE
#                                                             2016, 2017, 2018
#  read_state                       States                    1872, 1900, 1911, 1920, 1933, 1940,     IBGE
#                                                             1950, 1960, 1970, 1980, 1991, 2000, 
#                                                             2001, 2010, 2013, 2014, 2015, 2016, 
#                                                             2017, 2018
#  read_meso_region                 Meso region               2000, 2001, 2010, 2013, 2014, 2015,     IBGE
#                                                             2016, 2017, 2018 	
#  read_micro_region 	              Micro region 	            2000, 2001, 2010, 2013, 2014, 2015,     IBGE
#                                                             2016, 2017, 2018 	
#  read_intermediate_region 	      Intermediate region 	    2017 	                                  IBGE
#  read_immediate_region 	          Immediate region 	        2017 	                                  IBGE
#  read_municipality 	              Municipality 	            1872, 1900, 1911, 1920, 1933, 1940,     IBGE
#                                                             1950, 1960, 1970, 1980, 1991, 2000, 
#                                                             2001, 2005, 2007, 2010, 2013, 2014, 
#                                                             2015, 2016, 2017, 2018 	
#  read_weighting_area 	            Census área de ponderação 2010 	                                  IBGE
#  read_census_tract 	              Census setor censitário 	2000, 2010 	                            IBGE
#  read_statistical_grid 	          Grid of 200 x 200 meters 	2010 	                                  IBGE
#  read_health_facilities 	        Health facilities 	      2015 	                                  CNES, DataSUS
#  read_indigenous_land 	          Indigenous lands 	        201907 	                                FUNAI
#  read_biomes 	                    Biomes 	                  2004, 2019 	                            IBGE
#  read_disaster_risk_area 	        Disaster risk areas 	    2010 	                                  CEMADEN and IBGE
#  read_amazon 	                    Brazil's Legal Amazon 	  2012 	                                  MMA
#  read_conservation_units 	        Conservation Units 	      201909 	                                MMA
#  read_urban_area 	                Urban footprints 	        2005, 2015 	                            IBGE
#  read_semiarid 	                  Semi Arid region 	        2005, 2017 	                            IBGE
#  read_metro_area (dev) 	          Metropolitan areas 	      1970, 2001, 2002, 2003, 2005, 2010, 
#                                                             2013, 2014, 2015, 2016, 2017, 2018 	    IBGE
#
#  Note 1. Data sets and Functions marked with "dev" are only available in the development version of geobr
#  Note 2. All datasets use geodetic reference system "SIRGAS2000", CRS(4674). Most data sets are available 
#          at scale 1:250,000 (see documentation for details).



#--- Carregando Pacotes ---

library(geobr)
library(dplyr)
library(sf)
library(ggplot2)
library(magrittr)
library(rio)

#--- Carregando Datasets ---

state <- read_state(code_state="SE", year=2018)          # State
micro <- read_micro_region(code_micro=160101, year=2000) # Micro region
meso <- read_meso_region(code_meso="PA", year=2018)      # Meso region
muni <- read_municipality(code_muni= "AL", year=2007)    # Municipality

all_state <- read_state(code_state="all", year=1991)
all_muni_RJ <- read_municipality( code_muni = "RJ", year= 2000)

#--- Plotando os Mapas ---

# No plot axis
no_axis <- theme(axis.title=element_blank(),
                 axis.text=element_blank(),
                 axis.ticks=element_blank())

# Plot all Brazilian states
ggplot() + 
  geom_sf(data=all_state, fill="#2D3E50", color="#FEBF57", size=.15, show.legend = FALSE) + 
  labs(subtitle="States", size=8) + 
  theme_minimal() +
  no_axis

# plot
ggplot() + 
  geom_sf(data=all_muni_RJ, fill="#2D3E50", color="#FEBF57", size=.15, show.legend = FALSE) +
  labs(subtitle="Municipalities of Rio de Janeiro, 2000", size=8) + 
  theme_minimal() +
  no_axis

#--- Cruzando com dados externos ---

# download Life Expectancy data
adh <- rio::import("http://atlasbrasil.org.br/2013/data/rawData/Indicadores%20Atlas%20-%20RADAR%20IDHM.xlsx", which = "Dados")

# keep only information for the year 2010 and the columns we want
adh <- subset(adh, ANO == 2014)

# Download the sf of all Brazilian states
all_states <- read_state(code_state= "all", year= 2014)

# joind the databases
all_states <-left_join(all_states, adh, by = c("abbrev_state" = "NOME_AGREGA"))

# Plot thematic map
ggplot() + 
  geom_sf(data=all_states, aes(fill=ESPVIDA), color= NA, size=.15) + 
  labs(subtitle="Life Expectancy at birth, Brazilian States, 2014", size=8) + 
  scale_fill_distiller(palette = "Blues", name="Life Expectancy", limits = c(65,80)) +
  theme_minimal() +
  no_axis

